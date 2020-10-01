//
//  WebViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 30/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var url:URL?
    
    let webView:WKWebView = {
        let v = WKWebView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.pin(to: view)
        setUpCustomNavigations()
        view.backgroundColor = UIColor.dynamicColor(.appBackground)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    func setUpCustomNavigations(){
        
        navigationItem.title = "WebView"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.barTintColor = UIColor.dynamicColor(.appBackground)
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16 , weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(.textColor)
        ]
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setBackgroundImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cancelButton.tintColor = CustomColors.appBlue
        cancelButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelBtn), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = cancelButton
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @objc func cancelBtn(){
        dismiss(animated: true, completion: nil)
    }

}
