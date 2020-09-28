//
//  UserFollowingCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 27/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

protocol FollowDetailActionProtocol {
    func didUsertapped(_ userId:String)
}

class UserFollowingCollectionViewCell: UICollectionViewCell {
    
    var followingData:FollowingListModel?
    var followingPostList:[FollowDetail]?
    var delegate:FollowDetailActionProtocol?
    
    var userId:String?{
        didSet{
            FollowingListModel.fetchFollowingList(userId: userId!, params: "") { (followingData) in
                self.followingData = followingData
                self.getfollowingArray(followingData)
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
        FollowingListModel.fetchFollowingList(userId: userId!, params: "") { (followingData) in
            self.followingData = followingData
            self.followingPostList?.removeAll()
            self.getfollowingArray(followingData)
            self.collectionView.reloadData()
        }
        refresher.endRefreshing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getfollowingArray( _ data:FollowingListModel){
        var follow = [FollowDetail]()
        let userData = data.userData
        for i in 0..<userData!.count {
            let following = FollowDetail(id: userData![i].id, name: userData![i].name, screenName: userData![i].screenName, bio: userData![i].bio, isVerified: userData![i].isVerified, profileImage: userData![i].profileImage)
            follow.append(following)
        }
        if(followingPostList == nil){
            followingPostList = follow
        } else {
            followingPostList?.append(contentsOf: follow)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let loadMoreFrom = collectionView.contentSize.height - (collectionView.contentSize.height * 30/100)
        if ((collectionView.contentOffset.y + collectionView.frame.size.height) >= loadMoreFrom)
        {
            if followingData?.nextCursor != "0" {
                FollowingListModel.fetchFollowingList(userId: userId!, params: "&cursor=\(followingData?.nextCursor ?? "0")") { (followingData) in
                    self.followingData = followingData
                    self.getfollowingArray(followingData)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}

extension UserFollowingCollectionViewCell:UICollectionViewDelegateFlowLayout , UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let followingPostList = followingPostList {
            return followingPostList.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowDetailCollectionViewCell", for: indexPath) as! FollowDetailCollectionViewCell
        if let followingPostList = followingPostList {
            cell.data = followingPostList[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont(name: CustomFonts.appFont, size: 16)!
        let estimatedH = followingPostList?[indexPath.row].bio.height(withWidth: (collectionView.frame.width - 100), font: font)
        return CGSize(width: collectionView.frame.width, height: estimatedH! + 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didUsertapped(followingPostList![indexPath.row].id)
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

