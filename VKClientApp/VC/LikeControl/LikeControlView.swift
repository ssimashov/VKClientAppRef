//
//  LikeControlView.swift
//  VKClientApp
//
//  Created by Sergey Simashov on 12.12.2021.
//

import UIKit

class LikeControlView: UIView {

    
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    
    private var view: UIView?
    
    var isHeartActive = false
    var countLike = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
   
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LikeControlView", bundle: bundle )
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {return UIView()}
        return view
    }
    
    private func setup() {
        view = loadFromNib()
        guard let view = view else {return}
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    @IBAction func pressHeartButton(_ sender: UIButton) {
        
        if isHeartActive {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            countLike -= 1
            countLabel.text = String(countLike)
        }
        else {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            countLike += 1
            countLabel.text = String(countLike)
        }
        isHeartActive = !isHeartActive
    }
}
