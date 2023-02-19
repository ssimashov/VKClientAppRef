//
//  AllGroupsViewController.swift
//  VKClientApp
//
//  Created by Sergey Simashov on 24.11.2021.
//

import UIKit
import RealmSwift

class AllGroupsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var allGroups: Results<RealmAllGroups>? = try? RealmService.load(typeOf: RealmAllGroups.self){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var timer = Timer()
    
    let customCellReuseIdentifier = "customCellReuseIdentifier"
    let heightCustomTableViewCell:CGFloat = 150
    
    
    private let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: customCellReuseIdentifier)
        
        searchBar.delegate = self
    }
}

extension AllGroupsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allGroups?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let currentGroup = allGroups?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: customCellReuseIdentifier, for: indexPath) as? CustomTableViewCell
        else {return UITableViewCell()}
        
        cell.configure(model: currentGroup)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCustomTableViewCell
    }
}

extension AllGroupsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(
            at: indexPath,
            animated: true) }
            performSegue(
            withIdentifier: "addGroup",
            sender: nil)
    }
}


extension AllGroupsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        allGroups?.forEach({ deleteGroup in
            do {
                let realm = try Realm()
                let currentGroup = realm.objects(RealmAllGroups.self).filter("groupId == %@", deleteGroup.groupId)
                try RealmService.delete(object: currentGroup)
                tableView.reloadData()
            } catch {
                print(error)
            }
        })
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            let query = searchText
            
            self.networkService.fetchAllGroups(query: query.lowercased())
            {[weak self] result in
                switch result {
                case .success(let allGroups):
                    let realmGroup = allGroups.map { RealmAllGroups(allGroupsName: query, groups: $0)}
                    DispatchQueue.main.async {
                        do {
                            try RealmService.save(items: realmGroup)
                            self?.allGroups = try RealmService.load(typeOf: RealmAllGroups.self)
                            self?.tableView.reloadData()
                        } catch {
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
}
