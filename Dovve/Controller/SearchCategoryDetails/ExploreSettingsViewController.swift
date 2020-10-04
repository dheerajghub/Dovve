//
//  ExploreSettingsViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 03/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ExploreSettingsViewController: UIViewController {

    lazy var tableView:UITableView = {
        let tv = UITableView()
        tv.tableFooterView = UIView()
        tv.register(HeaderTableViewCell.self, forCellReuseIdentifier: "HeaderTableViewCell")
        tv.register(ExploreLocationTableViewCell.self, forCellReuseIdentifier: "ExploreLocationTableViewCell")
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        tv.separatorColor = UIColor.dynamicColor(.secondaryBackground)
        tv.backgroundColor = UIColor.dynamicColor(.darkBackground)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.pin(to: view)
        setUpNavBar()
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: true)
    }

}

extension ExploreSettingsViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            cell.headerText.text = "Location"
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreLocationTableViewCell", for:indexPath) as! ExploreLocationTableViewCell
            let country: String? = KeychainWrapper.standard.string(forKey: "country")
            cell.detailLabel.text = country
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            let cell = self.tableView.cellForRow(at: indexPath) as! ExploreLocationTableViewCell
            cell.contentView.backgroundColor = UIColor(white: 0, alpha: 0.2)        }, completion: { _ in
        })
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            let cell = self.tableView.cellForRow(at: indexPath) as! ExploreLocationTableViewCell
            cell.contentView.backgroundColor = .clear
        }, completion: { _ in
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = SelectLocationViewController()
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
