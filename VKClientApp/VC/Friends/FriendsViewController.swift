//
//  FriendsViewController.swift
//  VKClientApp
//
//  Created by Sergey Simashov on 23.11.2021.
//

import UIKit
import RealmSwift

class FriendsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var friends: Results<RealmFriends>? = try? RealmService.load(typeOf: RealmFriends.self){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var filteredFriends = [RealmFriends]()
    
    private var isSearch: Bool = false
    
    //    private var timer = Timer()
    
    let customCellReuseIdentifier = "customCellReuseIdentifier"
    let heightCustomTableViewCell:CGFloat = 150
    let toGallerySegue = "toCollectionViewSegue"
    
    private let networkService = NetworkService()
    private let userID = Session.instance.userId
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: customCellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        networkService.fetchFriends(userID: userID) { [weak self] result in
            switch result {
            case .success(let friends):
                let realmFriends = friends.map { RealmFriends(friends: $0)}
                DispatchQueue.main.async {
                    do {
                        try RealmService.save(items: realmFriends)
                        self?.friends = try RealmService.load(typeOf: RealmFriends.self)
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

extension FriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (isSearch){
            return filteredFriends.count
        }
        else {
            return friends?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let currentFriend = friends?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: customCellReuseIdentifier, for: indexPath) as? CustomTableViewCell else {return UITableViewCell()}
        
        if (isSearch){
            cell.configure(model: filteredFriends[indexPath.row])
        }
        else {
            cell.configure(model: currentFriend)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCustomTableViewCell
    }
    
    
}

extension FriendsViewController: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == toGallerySegue, let indexPath = tableView.indexPathForSelectedRow
        else { return }
        
        guard let vc = segue.destination as? GalleryViewController,
              let currentFriend = friends?[indexPath.row]
        else { return }
        vc.friendID = currentFriend.friendId
    }
    
    //        if segue.identifier == toGallerySegue {
    //            guard
    //                let vc = segue.destination as? GalleryViewController,
    //                let indexPath = tableView.indexPathForSelectedRow
    //            else { return }
    //            vc.friendID = currentFriend.friendId
    //        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: toGallerySegue, sender: nil)
    }
}


extension FriendsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            //
        }
        else {
            isSearch = true
            filteredFriends = friends!.filter({ friendItem in
                friendItem.friendFirstName.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
}




