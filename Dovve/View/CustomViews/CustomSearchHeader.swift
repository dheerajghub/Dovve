//
//  CustomSearchHeader.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 01/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class CustomSearchHeader: UIView {

    var controller:SearchWithCategoryViewController?{
        didSet{
            backBtn.addTarget(controller, action: #selector(SearchWithCategoryViewController.backBtnPressed), for: .touchUpInside)
        }
    }
    
    let backBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "back2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = CustomColors.appBlue
        return btn
    }()
    
    let searchBarView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 0, alpha: 0.1)
        v.layer.cornerRadius = 20
        return v
    }()
    
    let searchTextField:UITextField = {
        let stf = UITextField()
        stf.translatesAutoresizingMaskIntoConstraints = false
        stf.placeholder = "Search"
        stf.textAlignment = .center
        stf.tintColor = UIColor.dynamicColor(.secondaryTextColor)
        stf.font = UIFont(name: CustomFonts.appFont, size: 16)
        return stf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backBtn)
        addSubview(searchBarView)
        searchBarView.addSubview(searchTextField)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            backBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            backBtn.widthAnchor.constraint(equalToConstant: 30),
            backBtn.heightAnchor.constraint(equalToConstant: 30),
            backBtn.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            searchBarView.leadingAnchor.constraint(equalTo: backBtn.trailingAnchor, constant: 10),
            searchBarView.heightAnchor.constraint(equalToConstant: 40),
            searchBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55),
            searchBarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 15),
            searchTextField.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -15),
            searchTextField.topAnchor.constraint(equalTo: searchBarView.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
