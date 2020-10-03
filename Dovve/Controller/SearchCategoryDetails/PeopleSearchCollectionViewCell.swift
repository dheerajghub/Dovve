//
//  PeopleSearchCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 01/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class PeopleSearchCollectionViewCell: UICollectionViewCell {
    
    var searchData:[SearchUserModel]?
    var userList:[FollowDetail]?
    var delegate:FollowDetailActionProtocol?
    var controller:SearchWithCategoryViewController?
    var pageCount = 1
    
    var query:String?{
        didSet {
            SearchUserModel.fetchSearchedUsers(view: controller!,params: "q=\(query ?? "")", query: "&q=\(query ?? "")") { (searchData) in
                self.searchData = searchData
                self.getUserArray(searchData)
                self.collectionView.reloadData()
            }
        }
    }
    
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = CustomColors.appBackground
        refreshControl.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.refreshControl = refresher
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.register(FollowDetailCollectionViewCell.self, forCellWithReuseIdentifier: "FollowDetailCollectionViewCell")
        cv.setCollectionViewLayout(layout, animated: false)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.pin(to: self)
    }
    
    @objc func pullToRefresh(){
       SearchUserModel.fetchSearchedUsers(view: controller!,params: "q=\(query ?? "")", query: "&q=\(query ?? "")") { (searchData) in
            self.searchData = searchData
            self.userList?.removeAll()
            self.getUserArray(searchData)
            self.collectionView.reloadData()
       }
        refresher.endRefreshing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getUserArray( _ data:[SearchUserModel]){
        var users = [FollowDetail]()
        let userData = data
        for i in 0..<userData.count {
            let user = FollowDetail(id: userData[i].id, name: userData[i].name, screenName: userData[i].screenName, bio: userData[i].bio, isVerified: userData[i].isVerified, profileImage: userData[i].profileImage)
            users.append(user)
        }
        if(userList == nil){
            userList = users
        } else {
            userList?.append(contentsOf: users)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let loadMoreFrom = collectionView.contentSize.height - (collectionView.contentSize.height * 30/100)
        if ((collectionView.contentOffset.y + collectionView.frame.size.height) >= loadMoreFrom)
        {
            pageCount += 1
            SearchUserModel.fetchSearchedUsers(view: controller!, params: "page=\(pageCount)&q=\(query ?? "")", query: "&page=\(pageCount)&q=\(query ?? "")") { (searchData) in
                self.getUserArray(searchData)
                if let userList = self.userList {
                    if userList.count > 0 {
                        if userList[0].id != searchData[0].id {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension PeopleSearchCollectionViewCell:UICollectionViewDelegateFlowLayout , UICollectionViewDelegate, UICollectionViewDataSource, FollowActionProtocol {
    
    func didMentionTapped(screenName: String) {
        delegate?.didMentionTapped(screenName: screenName)
    }
    
    func didUrlTapped(url: String) {
        delegate?.didUrlTapped(url: url)
    }
    
    func didHashtagTapped(_ hashtag: String) {
        delegate?.didHashtagTapped(hashtag)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let userList = userList {
            return userList.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowDetailCollectionViewCell", for: indexPath) as! FollowDetailCollectionViewCell
        if let userList = userList {
            cell.data = userList[indexPath.row]
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont(name: CustomFonts.appFont, size: 16)!
        let estimatedH = userList?[indexPath.row].bio.height(withWidth: (collectionView.frame.width - 100), font: font)
        return CGSize(width: collectionView.frame.width, height: estimatedH! + 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didUsertapped(userList![indexPath.row].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? FollowDetailCollectionViewCell {
                cell.contentView.backgroundColor = UIColor(white: 0, alpha: 0.2)
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? FollowDetailCollectionViewCell {
                cell.contentView.backgroundColor = .clear
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.7
    }
    
}


