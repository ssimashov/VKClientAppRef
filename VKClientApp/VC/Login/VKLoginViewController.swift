//
//  VKLoginViewController.swift
//  VKClientAppCS
//
//  Created by Sergey Simashov on 11.02.2022.
//

import UIKit
import WebKit

final class VKLoginViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    @IBAction func unwindToVKLogin(_ segue: UIStoryboardSegue) {
        Session.instance.token = ""
        Session.instance.userId = 0
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach{
                if $0.displayName.contains("vk"){
                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [$0]) {[weak self] in
                        guard
                            let self = self,
                            let url = self.urlComponents.url
                        else { return }
                        self.webView.load(URLRequest(url: url))
                    }
                }
            }
        }
    }
    
    private var urlComponents: URLComponents = {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "oauth.vk.com"
        comp.path = "/authorize"
        comp.queryItems = [
            URLQueryItem(name: "client_id", value: "8077521"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "336918"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.131")
        ]
        return comp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard
            let url = urlComponents.url
        else { return }
        
        webView.load(URLRequest(url: url))
    }
}


extension VKLoginViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            guard
                let url = navigationResponse.response.url,
                url.path == "/blank.html",
                let fragment = url.fragment
            else { return decisionHandler(.allow) }
            
            let params = fragment
                .components(separatedBy: "&")
                .map { $0.components(separatedBy: "=") }
                .reduce([String: String]()) { result, param in
                    var dict = result
                    let key = param[0]
                    let value = param[1]
                    dict[key] = value
                    return dict
                }
            
            guard
                let token = params["access_token"],
                let userIDString = params["user_id"],
                let userID = Int(userIDString)
            else { return decisionHandler(.allow) }
            
            Session.instance.token = token
            Session.instance.userId = userID
            
            performSegue(
                withIdentifier: "moveToLogin",
                sender: nil)
            
            decisionHandler(.cancel)
            
        }
    
}
