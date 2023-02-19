//
//  LoginViewController.swift
//  VKClientApp
//
//  Created by Sergey Simashov on 13.11.2021.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var firstRoundView: UIView!
    @IBOutlet weak var secondRoundView: UIView!
    @IBOutlet weak var thirdRoundView: UIView!
   
    let toOrangeSegue = "toTabBarController"
    
    
    
    func dotsAnimate(exitAfter: Int, currentCount: Int){
        let timeInterval: CGFloat = 1
        UIView.animate(withDuration: timeInterval) {[weak self] in
            self?.firstRoundView.alpha = 0
            self?.secondRoundView.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: timeInterval) {[weak self] in
                self?.secondRoundView.alpha = 0
                self?.thirdRoundView.alpha = 1
            } completion: { _ in
                UIView.animate(withDuration: timeInterval) {[weak self] in
                    self?.thirdRoundView.alpha = 0
                    self?.firstRoundView.alpha = 1
                } completion: {[weak self] _ in
                    if currentCount < exitAfter {
                        self?.dotsAnimate(exitAfter: exitAfter, currentCount: currentCount + 1)
                    }
                    else {
                        self?.firstRoundView.alpha = 0
                    }
                }
            }
        }
    }
    
    
    func animating(){
        UIView.animate(withDuration: 4) {
            self.loginTextField.transform = .identity
            self.passwordTextField.transform = .identity
            self.loginLabel.transform = .identity
            self.passwordLabel.transform = .identity
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginTextField.transform = CGAffineTransform(translationX: -(self.view.frame.width), y: 0)
       passwordTextField.transform = CGAffineTransform(translationX: -(self.view.frame.width), y: 0)
        loginLabel.transform = CGAffineTransform(translationX: (self.view.frame.width), y: 0)
        passwordLabel.transform = CGAffineTransform(translationX: (self.view.frame.width), y: 0)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        secondRoundView.alpha = 0
        thirdRoundView.alpha = 0
        dotsAnimate(exitAfter: 5, currentCount: 0)
        UIView.transition(with: imageView, duration: 3, options: .transitionFlipFromTop,
                          animations: {[weak self] in
            guard let self = self else {return}
            self.imageView.bounds = .zero
        }, completion: nil)
        animating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        recognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(recognizer)
        
        
    }
    

    @objc func onTap(_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        guard let keyboardHeight = keyboardSize?.height else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 100, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
     }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
     }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func pressLoginButton(_ sender: Any) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text
        else {return}

        if login.isEmpty || password.isEmpty {
            loginTextField.backgroundColor = UIColor.red
            passwordTextField.backgroundColor = UIColor.red
            return
        }


        if login == "1" && password == "1"{
            performSegue(withIdentifier: toOrangeSegue, sender: nil)

        }

    

}
}
