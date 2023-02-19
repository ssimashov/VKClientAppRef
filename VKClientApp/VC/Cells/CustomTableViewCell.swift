//
//  CustomTableViewCell.swift
//  VKClientApp
//
//  Created by Sergey Simashov on 06.12.2021.

import UIKit

class CustomTableViewCell: UITableViewCell {


    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        nameLabel.text = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        avatarImageView.layer.cornerRadius = 60
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        backView.layer.cornerRadius = 60
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.7
        backView.layer.shadowRadius = 15
        backView.layer.shadowOffset = CGSize.zero
        
    }

//    func configure(image: UIImage?, text: String?) {
//        avatarImageView.image = image
//        nameLabel.text = text
//    }

//    func configure(friend: Friend) {
//        if let imageName = friend.avatar {
//            avatarImageView.image = UIImage(named: imageName)
//        }
//        nameLabel.text = friend.name
//    }

    func configure(model: GroupsItems) {
        self.nameLabel.text = model.groupName
        let imgUrl = URL(string: model.groupPhoto)
        let data = try? Data(contentsOf: imgUrl!)
        if let imageData = data {
            self.avatarImageView.image = UIImage(data: imageData)
        }
    }

    func configure(model: FriendItem){
        self.nameLabel.text = model.friendFirstName + " " + model.friendLastName
        let imgUrl = URL(string: model.friendPhoto)
        let data = try? Data(contentsOf: imgUrl!)
        if let imageData = data {
            self.avatarImageView.image = UIImage(data: imageData)
        }
    }
    func configure(model: RealmFriends){
        self.nameLabel.text = model.friendFirstName + " " + model.friendLastName
        let imgUrl = URL(string: model.friendPhoto)
        let data = try? Data(contentsOf: imgUrl!)
        if let imageData = data {
            self.avatarImageView.image = UIImage(data: imageData)
        }
    }
//    func configure(model: GroupsItems) {
//        self.nameLabel.text = model.groupName
//        let imgUrl = URL(string: model.groupPhoto)
//        let data = try? Data(contentsOf: imgUrl!)
//        if let imageData = data {
//            self.avatarImageView.image = UIImage(data: imageData)
//        }
//    }
    
    func configure(model: RealmGroups) {
        self.nameLabel.text = model.groupName
        let imgUrl = URL(string: model.groupPhoto)
        let data = try? Data(contentsOf: imgUrl!)
        if let imageData = data {
            self.avatarImageView.image = UIImage(data: imageData)
        }
    }
    func configure(model: RealmAllGroups) {
        self.nameLabel.text = model.groupName
        let imgUrl = URL(string: model.groupPhoto)
        let data = try? Data(contentsOf: imgUrl!)
        if let imageData = data {
            self.avatarImageView.image = UIImage(data: imageData)
        }
    }
}

