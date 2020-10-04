//
//  CustomMainSearchHeader.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 03/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class CustomMainSearchHeader: UIView {

    var controller:SearchViewController? {
        didSet{
            settingBtn.addTarget(controller, action: #selector(SearchViewController.settingBtnPressd), for: .touchUpInside)
        }
    }
    
    let searchBarView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 0, alpha: 0.1)
        v.layer.cornerRadius = 17.5
        return v
    }()
    
    let searchTextField:UITextField = {
        let stf = UITextField()
        stf.translatesAutoresizingMaskIntoConstraints = false
        stf.placeholder = "Search"
        stf.textAlignment = .center
        stf.tintColor = UIColor.dynamicColor(.secondaryTextColor)
        stf.font = UIFont(name: CustomFonts.appFont, size: 15)
        return stf
    }()
    
    let settingBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "setting"), for: .normal)
        return btn
    }()
    
    let dividerView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchBarView)
        searchBarView.addSubview(searchTextField)
        addSubview(settingBtn)
        addSubview(dividerView)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            searchBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            searchBarView.heightAnchor.constraint(equalToConstant: 35),
            searchBarView.trailingAnchor.constraint(equalTo: settingBtn.leadingAnchor, constant: -10),
            searchBarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 15),
            searchTextField.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -15),
            searchTextField.topAnchor.constraint(equalTo: searchBarView.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            
            settingBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            settingBtn.heightAnchor.constraint(equalToConstant: 35),
            settingBtn.widthAnchor.constraint(equalToConstant: 35),
            settingBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
