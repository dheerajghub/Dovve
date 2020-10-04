//
//  SearchViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 03/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class SearchViewController: UIViewController {

    var trendList:[GetTrends]?
    
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = CustomColors.appBackground
        refreshControl.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    let activityIndicator:UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView()
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.tintColor = UIColor.dynamicColor(.secondaryTextColor)
        return ac
    }()
    
    lazy var searchHeaderView:CustomMainSearchHeader = {
        let v = CustomMainSearchHeader()
        v.controller = self
//        v.searchTextField.text = query_str
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.appBackground)
        return v
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.setCollectionViewLayout(layout, animated: false)
        cv.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
        cv.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: "TrendingCollectionViewCell")
        cv.delegate = self
        cv.dataSource = self
        cv.refreshControl = refresher
        cv.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dynamicColor(.appBackground)
        view.addSubview(searchHeaderView)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        setUpNavBar()
        setUpConstraints()
        
        activityIndicator.startAnimating()
        let woeid: String? = KeychainWrapper.standard.string(forKey: "woeid")
        GetTrends.fetchTrends(view: self, woeid: woeid ?? "") { (trendList) in
            self.trendList = trendList
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavBar()
        let woeid: String? = KeychainWrapper.standard.string(forKey: "woeid")
        GetTrends.fetchTrends(view: self, woeid: woeid ?? "") { (trendList) in
            self.trendList = trendList
            self.collectionView.reloadData()
        }
    }
    
    @objc func pullToRefresh(){
        let woeid: String? = KeychainWrapper.standard.string(forKey: "woeid")
        GetTrends.fetchTrends(view: self, woeid: woeid ?? "") { (trendList) in
            self.trendList = trendList
            self.collectionView.reloadData()
        }
        refresher.endRefreshing()
    }
    
    @objc func settingBtnPressd(){
        let VC = ExploreSettingsViewController()
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func setUpNavBar(){
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            searchHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchHeaderView.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: searchHeaderView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: searchHeaderView.bottomAnchor, constant: 30),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}

extension SearchViewController:UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let trendList = trendList {
            return trendList.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
            let country: String? = KeychainWrapper.standard.string(forKey: "country")
            let titleArr = country?.components(separatedBy: "-")
            header.headerText.text = "\(titleArr![0])Trends"
            return header
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as! TrendingCollectionViewCell
        if let trendList = trendList {
            cell.title.text = trendList[indexPath.row].name
            cell.subTitle.text = "\(indexPath.row + 1) • Trending"
            if trendList[indexPath.row].tweetVolume != nil {
                cell.tweetCount.text = "\(Double(trendList[indexPath.row].tweetVolume).kmFormatted) Tweets"
            } else {
                cell.tweetCount.text = ""
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let trendList = trendList{
            let query = trendList[indexPath.row].query
            let name = trendList[indexPath.row].name
            let VC = SearchWithCategoryViewController()
            VC.query = query ?? ""
            VC.query_str = name ?? ""
            VC.query_user = name!.getQueryForUser()
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
