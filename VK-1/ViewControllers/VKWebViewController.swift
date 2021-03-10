//
//  VKWebViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 17.01.2021.
//

import UIKit
import WebKit
import RealmSwift

class VKWebViewController: UIViewController {
    
    let networkService = NetworkService()
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var webview: WKWebView! {
            didSet{
                webview.navigationDelegate = self
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = "oauth.vk.com"
                urlComponents.path = "/authorize"
                urlComponents.queryItems = [
                    URLQueryItem(name: "client_id", value: "7728615"),
                    URLQueryItem(name: "display", value: "mobile"),
                    URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                    URLQueryItem(name: "scope", value: "manage,photos,docs,wall,groups,friends"),
                    URLQueryItem(name: "response_type", value: "token"),
                    URLQueryItem(name: "v", value: "5.68")
                ]
                
                let request = URLRequest(url: urlComponents.url!)
                
                webview.load(request)
    }
    
    


}
extension VKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
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
        
        Session.instance.token = params["access_token"]!
        Session.instance.userId = params["user_id"]!
        networkService.ref.child("users").child(Session.instance.userId).setValue(["username": Session.instance.userId])

        decisionHandler(.cancel)
        performSegue(withIdentifier: "accessLogin", sender: self)
    }
}
