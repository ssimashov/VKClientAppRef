//
//  TestViewController.swift
//  VKClientAppCS
//
//  Created by Sergey Simashov on 13.02.2022.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    
    
    @IBOutlet weak var label2: UILabel!
    
    private let networkService = NetworkService()
    
    private let userID = Session.instance.userId
  let query = ""
    
//    private var friends = [Friend0]()
    private var photos = [Photos]()
    private var groups = [GroupsItems]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        label1.text = Session.instance.token
        label2.text = String( Session.instance.userId)
//        networkService.fetchUsers(userID: userID) { [weak self] result in
//            switch result {
//            case .success(let friends):
//                self?.friends = friends
//                print(friends)
//            case .failure(let error):
//                print(error)
//            }
//
//        }
       
        
        
//        networkService.fetchPhotos(userID: userID){
//            [weak self] result in
//                switch result {
//                case .success(let photos):
//                    self?.photos = photos
//                    print(photos)
//                case .failure(let error):
//                    print(error)
//                }
//        }
//        
//        
        
//        networkService.fetchGroups(userID: userID){
//            [weak self] result in
//                        switch result {
//                        case .success(let groups):
//                            self?.groups = groups
//                            print(groups)
//                        case .failure(let error):
//                            print(error)
//                        }
////        }
//        networkService.fetchSearchGroups(query: query)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
