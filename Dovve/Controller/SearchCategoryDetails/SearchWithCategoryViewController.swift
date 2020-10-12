//
//  SearchWithCategoryViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 01/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class SearchWithCategoryViewController: UIViewController, FollowDetailActionProtocol {

    var query = ""
    var query_str = ""
    var query_user = ""
    
    lazy var searchHeaderView:CustomSearchHeader = {
        let v = CustomSearchHeader()
        v.controller = self
        v.searchTextField.text = query_str
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.appBackground)
        return v
    }()
    
    lazy var menuBar:CategoryMenuBar = {
        let mb = CategoryMenuBar()
        mb.searchDetailController = self
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.categoryArr = ["Top" , "Latest" , "People"]
        mb.widthAnchorContraints = mb.selectedBarView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3)
        mb.widthAnchorContraints?.isActive = true
        return mb
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.setCollectionViewLayout(layout, animated: false)
        cv.register(TopSearchCollectionViewCell.self, forCellWithReuseIdentifier: "TopSearchCollectionViewCell")
        cv.register(LatestSearchCollectionViewCell.self, forCellWithReuseIdentifier: "LatestSearchCollectionViewCell")
        cv.register(PeopleSearchCollectionViewCell.self, forCellWithReuseIdentifier: "PeopleSearchCollectionViewCell")
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        view.addSubview(collectionView)
        view.addSubview(searchHeaderView)
        view.addSubview(menuBar)
        view.backgroundColor = UIColor.dynamicColor(.appBackground)
        setUpConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = UIColor.dynamicColor(.appBackground)
        setUpNavBar()
    }
    
    func setUpNavBar(){
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @objc func backBtnPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            searchHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchHeaderView.heightAnchor.constraint(equalToConstant: 45),
            
            menuBar.topAnchor.constraint(equalTo: searchHeaderView.bottomAnchor),
            menuBar.heightAnchor.constraint(equalToConstant: 40),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func scrollToMenuIndex(_ index:Int, _ anim:Bool){
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: anim)
    }
}

extension SearchWithCategoryViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,FollowActionProtocol,TweetActions {
    
    func tweetSelected(with id: String) {
        let VC = TweetDetailViewController()
        VC.tweetId = id
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func didHashtagTapped(_ hashtag: String) {
        SearchForHashtag(hashtag)
    }
    
    func didMentionTapped(screenName: String) {
        PushToProfile("", screenName)
    }
    
    func didUrlTapped(url: String) {
        let VC = WebViewController()
        VC.url = URL(string: url)
        let navVC = UINavigationController(rootViewController: VC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    
    func didUsertapped(_ userId: String) {
        PushToProfile(userId , "")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeadingAnchorConstraints?.constant = scrollView.contentOffset.x / 3
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopSearchCollectionViewCell", for: indexPath) as! TopSearchCollectionViewCell
            cell.controller = self
            cell.delegate = self
            cell.query = query
            return cell
        }
        if indexPath.row == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestSearchCollectionViewCell", for: indexPath) as! LatestSearchCollectionViewCell
            cell.controller = self
            cell.delegate = self
            cell.query = query
            return cell
        }
        if indexPath.row == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleSearchCollectionViewCell", for: indexPath) as! PeopleSearchCollectionViewCell
            cell.controller = self
            cell.query = query_user
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
