//
//  CustomLocationSearchView.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 04/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class CustomLocationSearchView: UIView, UITextFieldDelegate {

    var controller:SelectLocationViewController? {
        didSet{
            searchTextField.addTarget(controller, action: #selector(SelectLocationViewController.textFieldDidChange), for: .editingChanged)
        }
    }
    
    let searchBarView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 0.3, alpha: 0.1)
        v.layer.cornerRadius = 17.5
        return v
    }()
    
    let searchTextField:UITextField = {
        let stf = UITextField()
        stf.translatesAutoresizingMaskIntoConstraints = false
        stf.placeholder = "Search"
        stf.textAlignment = .center
        stf.tintColor = UIColor.dynamicColor(.secondaryTextColor)
        stf.font = UIFont(name: CustomFonts.appFont, size: 16)
        stf.autocapitalizationType = .none
        return stf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.dynamicColor(.appBackground)
        addSubview(searchBarView)
        searchBarView.addSubview(searchTextField)
        searchTextField.pin(to: searchBarView)
        setUpconstraints()
    }
    
    func setUpconstraints(){
        NSLayoutConstraint.activate([
            searchBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            searchBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            searchBarView.heightAnchor.constraint(equalToConstant: 35),
            searchBarView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
