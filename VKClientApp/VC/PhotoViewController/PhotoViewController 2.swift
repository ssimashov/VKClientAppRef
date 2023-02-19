//
//  PhotoViewController.swift
//  VKClientApp
//
//  Created by Sergey Simashov on 07.12.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.photoImageView.image = photo
   
    }
    
}


