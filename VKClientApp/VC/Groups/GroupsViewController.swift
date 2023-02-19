//
//  GroupsViewController.swift
//  VKClientApp
//
//  Created by Sergey Simashov on 24.11.2021.
//

import UIKit
import RealmSwift

class GroupsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard
            segue.identifier == "addGroup",
            let allGroupsController = segue.source as? AllGroupsViewController,
            let groupIndexPath = allGroupsController.tableView.indexPathForSelectedRow//,
                //           !self.groups.contains(allGroupsController.groups[groupIndexPath.row])
        else { return }
        do {
            let currentGroup = allGroupsController.allGroups![groupIndexPath.row]
            let realm = try Realm()
            realm.beginWrite()
            let currentAddGroup = RealmGroups()
            currentAddGroup.groupId = currentGroup.groupId
            currentAddGroup.groupName = currentGroup.groupName
            currentAddGroup.groupPhoto = currentGroup.groupPhoto
            realm.add(currentAddGroup)
            try realm.commitWrite()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }

    private var groups: Results<RealmGroups>? = try? RealmService.load(typeOf: RealmGroups.self){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let customCellReuseIdentifier = "customCellReuseIdentifier"
    let heightCustomTableViewCell:CGFloat = 150
    
    private let networkService = NetworkService()
    private let userID = Session.instance.userId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: customCellReuseIdentifier)
        
        networkService.fetchGroups(userID: userID) { [weak self] result in
            
            switch result {
            case .success(let groups):
                let realmGroups = groups.map { RealmGroups(groups: $0)}
                DispatchQueue.main.async {
                    do {
                        try RealmService.save(items: realmGroups)
                        self?.groups = try RealmService.load(typeOf: RealmGroups.self)
                        self?.tableView.reloadData()
                    } catch {
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension GroupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let currentGroup = groups?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: customCellReuseIdentifier, for: indexPath) as? CustomTableViewCell
        else {return UITableViewCell()}
        
        cell.configure(model: currentGroup)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCustomTableViewCell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteGroup = self.groups![indexPath.row]
            let alertController = UIAlertController(title: "Delete cell", message: "Вы уверены что хотите удалить?", preferredStyle: .actionSheet)
            let actionYes = UIAlertAction(title: "Yes", style: .default) {_ in
                
                do {
                    let realm = try Realm()
                    let currentGroup = realm.objects(RealmGroups.self).filter("groupId == %@", deleteGroup.groupId)
                    DispatchQueue.main.async {
                        try? RealmService.delete(object: currentGroup)
                        tableView.deleteRows(
                            at: [indexPath],
                            with: .fade)
                    }
                } catch {
                    print(error)
                }
            }
            alertController.addAction(actionYes)
            let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alertController.addAction(actionNo)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }    
}
