//
//  CustomSegue.swift
//  VKClientApp
//
//  Created by Sergey Simashov on 19.12.2021.
//

import UIKit

class CustomMoveToPhotoSegue: UIStoryboardSegue {

    override func perform() {
        guard let containerView = source.view.superview,
              let destinationView = destination.view,
              let sourceController = source as? GalleryViewController
        else {return}
        
        
        UIView.animate(withDuration: 1) {
            sourceController.collectionView.alpha = 0
        }
            
        let destinationFrame = self.source.view.frame
        
        containerView.addSubview(destinationView)
            destinationView.frame = CGRect(x: self.source.view.frame.width / 2, y: self.source.view.frame.height / 2, width: 0, height: 0)
        UIView.animate(withDuration: 1) {[weak self] in
            self?.source.view.frame = destinationView.frame
        } completion: { _ in
            UIView.animate(withDuration: 1) {
                destinationView.frame = destinationFrame
            } completion: {[weak self] isSuccess in
                if isSuccess,
                    let self = self {
                        self.source.present(self.destination, animated: false, completion: nil)
                    }
            }

        }

    }
    
                       
}
