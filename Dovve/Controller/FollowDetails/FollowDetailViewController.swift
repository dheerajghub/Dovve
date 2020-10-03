//
//  FollowDetailViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 27/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class FollowDetailViewController: UIViewController {

    var userId = ""
    var username = ""
    var followType = ""
    
    lazy var menuBar:CategoryMenuBar = {
        let mb = CategoryMenuBar()
        mb.followDetailController = self
        mb.translatesAutoresizingMaskIntoConstraints = false
        mb.categoryArr = ["Followers" , "Following"]
        mb.widthAnchorContraints = mb.selectedBarView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2)
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
        cv.register(UserFollowersCollectionViewCell.self, forCellWithReuseIdentifier: "UserFollowersCollectionViewCell")
        cv.register(UserFollowingCollectionViewCell.self, forCellWithReuseIdentifier: "UserFollowingCollectionViewCell")
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        view.addSubview(collectionView)
        view.backgroundColor = .white
        view.addSubview(menuBar)
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(followType == "follower"){
            let index = IndexPath(item: 0, section: 0)
            menuBar.collectionView.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
            scrollToMenuIndex(0,false)
        } else if(followType == "following"){
            let index = IndexPath(item: 1, section: 0)
            menuBar.collectionView.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
            scrollToMenuIndex(1,false)
        }
    }
    
    func setUpNavBar(){
        navigationItem.title = "\(username)"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.layer.shadowOpacity = 0
        navigationController?.navigationBar.barTintColor = UIColor.dynamicColor(.appBackground)
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: CustomFonts.appFontBold, size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(.textColor)
        ]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "back2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = CustomColors.appBlue
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backBtn), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            menuBar.topAnchor.constraint(equalTo: view.topAnchor),
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
    
    @objc func backBtn(){
        navigationController?.popViewController(animated: true)
    }
   
}

extension FollowDetailViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FollowDetailActionProtocol {
    
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
        menuBar.horizontalBarLeadingAnchorConstraints?.constant = scrollView.contentOffset.x / 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserFollowersCollectionViewCell", for: indexPath) as! UserFollowersCollectionViewCell
            cell.userId = userId
            cell.delegate = self
            return cell
        }
        if indexPath.row == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserFollowingCollectionViewCell", for: indexPath) as! UserFollowingCollectionViewCell
            cell.userId = userId
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
