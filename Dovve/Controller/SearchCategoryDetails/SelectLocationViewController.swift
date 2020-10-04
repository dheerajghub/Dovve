//
//  SelectLocationViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 04/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SelectLocationViewController: UIViewController {

    var woeidList:[GetWoeidModel]?
    var bottomConstraint: NSLayoutConstraint?
    
    lazy var searchView:CustomLocationSearchView = {
        let sb = CustomLocationSearchView()
        sb.controller = self
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    lazy var tableView:UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.tableFooterView = UIView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "locationId")
        tv.showsVerticalScrollIndicator = false
        tv.separatorColor = UIColor.dynamicColor(.secondaryBackground)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = UIColor.dynamicColor(.darkBackground)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchView)
        view.addSubview(tableView)
        setUpConstraints()
        setUpNavBar()
        
        GetWoeidModel.fetchWoeid(searchQ: "") { (woeidList) in
            self.woeidList = woeidList
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillShowNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillHideNotification , object: nil)
        
        bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.topAnchor.constraint(equalTo: view.topAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setUpNavBar(){
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.dynamicColor(.appBackground)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        navigationController?.navigationBar.layer.shadowColor = UIColor.dynamicColor(.secondaryBackground).cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 1
        navigationController?.navigationBar.layer.shadowRadius = 0.3
        
        setTitleAttribute()
        
        let backButton = UIButton(type: .system)
        backButton.setBackgroundImage(UIImage(named: "back2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = CustomColors.appBlue
        backButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
    }
    
    func setTitleAttribute(){
        let screenName: String? = KeychainWrapper.standard.string(forKey: "screenName")
        let attributedText = NSMutableAttributedString(string:"Trends Settings\n" , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFontBold, size: 17)!])
        attributedText.append(NSAttributedString(string: "@\(screenName ?? "")" , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFont, size: 13)!, NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))
        
        let titleLabel = UILabel()
        titleLabel.attributedText = attributedText
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .clear
        navigationItem.titleView = titleLabel
    }
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(){
        let text = searchView.searchTextField.text
        GetWoeidModel.fetchWoeid(searchQ: text ?? "") { (woeidList) in
            self.woeidList = woeidList
            self.tableView.reloadData()
        }
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight : 0
            
            UIView.animate(withDuration:0.1, delay: 0 , options: .curveEaseOut , animations: {
                self.view.layoutIfNeeded()
            } , completion: {(completed) in
                
            })
        }
    }

}

extension SelectLocationViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let woeidList = woeidList {
            return woeidList.count
        }
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationId", for: indexPath)
        
        if let woeidList = woeidList {
            cell.textLabel?.text = woeidList[indexPath.row].country
            let woeid: String? = KeychainWrapper.standard.string(forKey: "woeid")
            if woeid == "\(woeidList[indexPath.row].woeid ?? 0)" {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.backgroundColor = UIColor.dynamicColor(.appBackground)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let woeidList = woeidList {
            let _:Bool = KeychainWrapper.standard.set("\(woeidList[indexPath.row].woeid ?? 0)", forKey: "woeid")
            let _:Bool = KeychainWrapper.standard.set(woeidList[indexPath.row].country ?? "", forKey: "country")
            self.tableView.reloadData()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            let cell = self.tableView.cellForRow(at: indexPath)!
            cell.contentView.backgroundColor = UIColor(white: 0, alpha: 0.1)        },completion: { _ in
        })
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            let cell = self.tableView.cellForRow(at: indexPath)!
            cell.contentView.backgroundColor = .clear
        }, completion: { _ in
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}
