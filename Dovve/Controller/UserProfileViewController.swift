//
//  UserProfileViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 27/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    var profileData:UserProfileModel?
    var dataModel:[UserTimeLineModel]?
    var dataList:[TweetData]?
    var userProfileId:String?
    
    private lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = CustomColors.appBackground
        refreshControl.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var navBar:CustomUserProfileNavBar = {
        let v = CustomUserProfileNavBar()
        v.controller = self
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.shadowRadius = 10
        v.layer.shadowColor = UIColor(white: 0, alpha: 0.1).cgColor
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize(width: 0, height: 10)
        return v
    }()

    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = StretchyCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.register(SimpleTextPostCollectionViewCell.self, forCellWithReuseIdentifier: "SimpleTextPostCollectionViewCell")
        cv.register(PostWithImagesCollectionViewCell.self, forCellWithReuseIdentifier: "PostWithImagesCollectionViewCell")
        cv.register(QuotedPostCollectionViewCell.self, forCellWithReuseIdentifier: "QuotedPostCollectionViewCell")
        cv.register(QuotedPostWithImageCollectionViewCell.self, forCellWithReuseIdentifier: "QuotedPostWithImageCollectionViewCell")
        cv.register(PostWithImageAndQuoteCollectionViewCell.self, forCellWithReuseIdentifier: "PostWithImageAndQuoteCollectionViewCell")
        cv.register(PostWithImageAndQuotedImageCollectionViewCell.self, forCellWithReuseIdentifier: "PostWithImageAndQuotedImageCollectionViewCell")
        cv.register(ProfileStrechyHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileStrechyHeader")
        cv.register(ProfileHeaderCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileHeaderCollectionViewCell")
        cv.setCollectionViewLayout(layout, animated: false)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        view.addSubview(collectionView)
        view.addSubview(navBar)
        collectionView.pin(to: view)
        setUpCustomNavBar()
        setUpConstraints()
        
        UserProfileModel.fetchUserProfile(view: self, userId: "\(userProfileId ?? "")") { (profileData) in
            self.profileData = profileData
            self.navBar.setAttributedText(profileData.name ?? "", tweetCount: "\(Double(profileData.tweetCount).kmFormatted)")
            self.navBar.cardImageView.cacheImageWithLoader(withURL: profileData.backgroundImage ?? "", view: self.navBar.cardBackView)
            self.collectionView.reloadData()
        }
        
        UserTimeLineModel.fetchUserTimeLine(view:self, params:"&user_id=\(userProfileId ?? "")") {(dataModel) in
            self.dataModel = dataModel
            self.dataList?.removeAll()
            self.getDataListArray(dataModel)
            self.collectionView.reloadData()
        }
    }
    
    @objc func pullToRefresh(){
        UserTimeLineModel.fetchUserTimeLine(view:self, params:"&user_id=\(userProfileId ?? "")") {(dataModel) in
            self.dataModel = dataModel
            self.dataList?.removeAll()
            self.getDataListArray(dataModel)
            self.collectionView.reloadData()
        }
        refresher.endRefreshing()
    }

    func setUpConstraints(){
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    func setUpCustomNavBar(){
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let backButton = UIButton(type: .system)
        backButton.setBackgroundImage(UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
    }
    
    func getDataListArray(_ data:[UserTimeLineModel]){
        var tweets = [TweetData]()
        let tweetCount = data.count
        for i in 0..<tweetCount{
            if data[i].isQuotedStatus == true {
                if data[i].isRetweetedStatus == true {
                    let tweet = TweetData(createdAt: data[i].createdAt, id: data[i].id, text: data[i].text, user: TweetUser(userId: data[i].user.userId, name: data[i].user.name, screenName: data[i].user.screen_name, profileImage: data[i].user.profileImage, isVerified: data[i].user.isVerified), media: data[i].media, isRetweetedStatus: true, retweetedBy: TweetRetweetedData(userProfileImage: data[i].retweetedBy.userProfileImage, userID: data[i].retweetedBy.userID) ,isQuotedStatus: data[i].isQuotedStatus, tweetQuotedStatus:TweetQuotedStatus(createdAt: data[i].quotedStatus.createdAt, user: TweetUser(userId: data[i].quotedStatus.user.userId, name: data[i].quotedStatus.user.name, screenName: data[i].quotedStatus.user.screen_name, profileImage: data[i].quotedStatus.user.profileImage, isVerified: data[i].quotedStatus.user.isVerified), text: data[i].quotedStatus.text, media: data[i].quotedStatus.media), retweetCount: data[i].retweetCount, favoriteCount: data[i].favoriteCount, favorited: data[i].favorited, retweeted: data[i].retweeted)
                    tweets.append(tweet)
                } else {
                    let tweet = TweetData(createdAt: data[i].createdAt, id: data[i].id, text: data[i].text, user: TweetUser(userId: data[i].user.userId, name: data[i].user.name, screenName: data[i].user.screen_name, profileImage: data[i].user.profileImage, isVerified: data[i].user.isVerified), media: data[i].media, isRetweetedStatus: false , retweetedBy: nil , isQuotedStatus: data[i].isQuotedStatus, tweetQuotedStatus:TweetQuotedStatus(createdAt: data[i].quotedStatus.createdAt, user: TweetUser(userId: data[i].quotedStatus.user.userId, name: data[i].quotedStatus.user.name, screenName: data[i].quotedStatus.user.screen_name, profileImage: data[i].quotedStatus.user.profileImage, isVerified: data[i].quotedStatus.user.isVerified), text: data[i].quotedStatus.text, media: data[i].quotedStatus.media), retweetCount: data[i].retweetCount, favoriteCount: data[i].favoriteCount, favorited: data[i].favorited, retweeted: data[i].retweeted)
                    tweets.append(tweet)
                }
            } else {
                if data[i].isRetweetedStatus == true {
                    let tweet = TweetData(createdAt: data[i].createdAt, id: data[i].id, text: data[i].text, user: TweetUser(userId: data[i].user.userId, name: data[i].user.name, screenName: data[i].user.screen_name, profileImage: data[i].user.profileImage, isVerified: data[i].user.isVerified), media: data[i].media, isRetweetedStatus: true , retweetedBy: TweetRetweetedData(userProfileImage: data[i].retweetedBy.userProfileImage, userID: data[i].retweetedBy.userID), isQuotedStatus: data[i].isQuotedStatus, tweetQuotedStatus:nil, retweetCount: data[i].retweetCount, favoriteCount: data[i].favoriteCount, favorited: data[i].favorited, retweeted: data[i].retweeted)
                    tweets.append(tweet)
                } else {
                    let tweet = TweetData(createdAt: data[i].createdAt, id: data[i].id, text: data[i].text, user: TweetUser(userId: data[i].user.userId, name: data[i].user.name, screenName: data[i].user.screen_name, profileImage: data[i].user.profileImage, isVerified: data[i].user.isVerified), media: data[i].media, isRetweetedStatus: false, retweetedBy: nil ,isQuotedStatus: data[i].isQuotedStatus, tweetQuotedStatus:nil, retweetCount: data[i].retweetCount, favoriteCount: data[i].favoriteCount, favorited: data[i].favorited, retweeted: data[i].retweeted)
                    tweets.append(tweet)
                }
            }
        }
        if dataList == nil {
            dataList = tweets
        } else {
            dataList?.append(contentsOf: tweets)
        }
    }
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: true)
    }

}

extension UserProfileViewController:UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataList = dataList {
            return dataList.count + 1
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileStrechyHeader", for: indexPath) as? ProfileStrechyHeader {
                headerView.imageView.cacheImageWithLoader(withURL: profileData?.backgroundImage ?? "", view: headerView.imageBackView)
                return headerView
            }
            return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHeaderCollectionViewCell", for: indexPath) as! ProfileHeaderCollectionViewCell
            cell.data = UserProfile(id:profileData?.id, name: profileData?.name, screenName: profileData?.screenName, bio: profileData?.bio, followers: profileData?.followers, friends: profileData?.friends, joiningDate: profileData?.joiningDate, tweetCount: profileData?.tweetCount, isVerified: profileData?.isVerified, profileImage: profileData?.profileImage, backgroundImage: profileData?.backgroundImage, website: profileData?.website)
            return cell
        }
        if indexPath.row > 0 {
            if let dataList = dataList {
                if dataList[indexPath.row - 1].media == nil && dataList[indexPath.row - 1].isQuotedStatus == false {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleTextPostCollectionViewCell", for: indexPath) as! SimpleTextPostCollectionViewCell
                    cell.data = dataList[indexPath.row - 1]
                    cell.delegate = self
                    return cell
                }
                if dataList[indexPath.row - 1].media != nil &&  dataList[indexPath.row - 1].isQuotedStatus == false {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostWithImagesCollectionViewCell", for: indexPath) as! PostWithImagesCollectionViewCell
                    cell.data = dataList[indexPath.row - 1]
                    cell.delegate = self
                    return cell
                }
                if dataList[indexPath.row - 1].media == nil && dataList[indexPath.row - 1].isQuotedStatus == true && dataList[indexPath.row - 1].tweetQuotedStatus.media == nil {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotedPostCollectionViewCell", for: indexPath) as! QuotedPostCollectionViewCell
                    cell.data = dataList[indexPath.row - 1]
                    cell.delegate = self
                    return cell
                }
                if dataList[indexPath.row - 1].media != nil && dataList[indexPath.row - 1].isQuotedStatus == true && dataList[indexPath.row - 1].tweetQuotedStatus.media == nil {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostWithImageAndQuoteCollectionViewCell", for: indexPath) as! PostWithImageAndQuoteCollectionViewCell
                    cell.data = dataList[indexPath.row - 1]
                    cell.delegate = self
                    return cell
                }
                if dataList[indexPath.row - 1].media == nil && dataList[indexPath.row - 1].isQuotedStatus == true && dataList[indexPath.row - 1].tweetQuotedStatus.media != nil {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotedPostWithImageCollectionViewCell", for: indexPath) as! QuotedPostWithImageCollectionViewCell
                    cell.data = dataList[indexPath.row - 1]
                    cell.delegate = self
                    return cell
                }
                if dataList[indexPath.row - 1].media != nil && dataList[indexPath.row - 1].isQuotedStatus == true && dataList[indexPath.row - 1].tweetQuotedStatus.media != nil {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostWithImageAndQuotedImageCollectionViewCell", for: indexPath) as! PostWithImageAndQuotedImageCollectionViewCell
                    cell.data = dataList[indexPath.row - 1]
                    cell.delegate = self
                    return cell
                }
            }
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            let font = UIFont(name: CustomFonts.appFont, size: 17)
            let estimatedH = profileData?.bio.height(withWidth: collectionView.frame.width - 40, font: font!) ?? 0
            return CGSize(width: collectionView.frame.width, height: estimatedH + 220)
        }
        if indexPath.row > 0 {
            if let dataList = dataList {
                if dataList[indexPath.row - 1].media == nil && dataList[indexPath.row - 1].isQuotedStatus == false {
                    let font = UIFont(name: CustomFonts.appFont, size: 17)!
                    let estimatedH = dataList[indexPath.row - 1].text.height(withWidth: (collectionView.frame.width - 100), font: font)
                    return CGSize(width: collectionView.frame.width, height: estimatedH + 95 )
                }
                if dataList[indexPath.row - 1].media != nil &&  dataList[indexPath.row - 1].isQuotedStatus == false {
                    let font = UIFont(name: CustomFonts.appFont, size: 17)!
                    let estimatedH = dataList[indexPath.row - 1].text.height(withWidth: (collectionView.frame.width - 100), font: font)
                    let extraHeight = 105 + ((collectionView.frame.width - 100) * (9 / 16))
                    return CGSize(width: collectionView.frame.width, height: estimatedH + extraHeight )
                }
                if dataList[indexPath.row - 1].media == nil && dataList[indexPath.row - 1].isQuotedStatus == true && dataList[indexPath.row - 1].tweetQuotedStatus.media == nil {
                    let font = UIFont(name: CustomFonts.appFont, size: 17)!
                    let estimatedH = dataList[indexPath.row - 1].text.height(withWidth: (collectionView.frame.width - 100), font: font)
                    let estimatedHForQuotedTweet = dataList[indexPath.row - 1].tweetQuotedStatus.text.height(withWidth: ((collectionView.frame.width - 100) - 30), font: font)
                    return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + 160)
                }
                if dataList[indexPath.row - 1].media != nil && dataList[indexPath.row - 1].isQuotedStatus == true && dataList[indexPath.row - 1].tweetQuotedStatus.media == nil {
                    let font = UIFont(name: CustomFonts.appFont, size: 17)!
                    let estimatedH = dataList[indexPath.row - 1].text.height(withWidth: (collectionView.frame.width - 100), font: font)
                    let estimatedHForQuotedTweet = dataList[indexPath.row - 1].tweetQuotedStatus.text.height(withWidth: ((collectionView.frame.width - 100) - 30), font: font)
                    let imageCollectionForPostH = (collectionView.frame.width - 100) * (9/16)
                    return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + imageCollectionForPostH + 175)
                }
                if dataList[indexPath.row - 1].media == nil && dataList[indexPath.row - 1].isQuotedStatus == true && dataList[indexPath.row - 1].tweetQuotedStatus.media != nil {
                    let font = UIFont(name: CustomFonts.appFont, size: 17)!
                    let estimatedH = dataList[indexPath.row - 1].text.height(withWidth: (collectionView.frame.width - 100), font: font)
                    let estimatedHForQuotedTweet = dataList[indexPath.row - 1].tweetQuotedStatus.text.height(withWidth: ((collectionView.frame.width - 100) - 30), font: font)
                    let imageCollectionHeight = ((collectionView.frame.width - 100) * (9/16))
                    return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + imageCollectionHeight + 160)
                }
                if dataList[indexPath.row - 1].media != nil && dataList[indexPath.row - 1].isQuotedStatus == true && dataList[indexPath.row - 1].tweetQuotedStatus.media != nil {
                    let font = UIFont(name: CustomFonts.appFont, size: 17)!
                    let estimatedH = dataList[indexPath.row - 1].text.height(withWidth: (collectionView.frame.width - 100), font: font)
                    let estimatedHForQuotedTweet = dataList[indexPath.row - 1].tweetQuotedStatus.text.height(withWidth: ((collectionView.frame.width - 100) - 30), font: font)
                    let imageCollectionHeight = ((collectionView.frame.width - 100) * (9/16))
                    let imageCollectionForPostH = (collectionView.frame.width - 100) * (9/16)
                    return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + imageCollectionHeight + imageCollectionForPostH + 175)
                }
            }
        }
        return CGSize()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.width * 1/5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.7
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.7
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let v = y/80
        let value = Double(round(100*v)/100)

        if value >= 1.0 {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
                self.navBar.alpha = 1
            }, completion: nil)

            UIView.animate(withDuration: 0.4) {
                self.navBar.titleLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            }

        } else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
                self.navBar.alpha = 0
            }, completion: nil)

            UIView.animate(withDuration: 0.4) {
                self.navBar.titleLabel.transform = CGAffineTransform(translationX: 0, y: +50)
            }
        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let loadMoreFrom = collectionView.contentSize.height - (collectionView.contentSize.height * 30/100)
        if ((collectionView.contentOffset.y + collectionView.frame.size.height) >= loadMoreFrom){
            if let dataList = dataList {
                let totalPosts = dataList.count
                let getLastId = Int(dataList[totalPosts - 1].id)
                if totalPosts < (profileData?.tweetCount)! {
                    UserTimeLineModel.fetchUserTimeLine(view:self, params:"&user_id=\(userProfileId ?? "")&max_id=\(getLastId ?? 0)") {(dataModel) in
                        self.dataList?.remove(at: totalPosts - 1)
                        self.getDataListArray(dataModel)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }

}

extension UserProfileViewController: SimpleTextPostDelegate, PostWithImagesDelegate, QuotedPostDelegate, QuotedPostWithImageDelegate , PostWithImageAndQuoteDelegate , PostWithImageAndQuotedImageDelegate {
    
    //MARK:-SimpleTextPost Actions
    func didUserProfileTapped(for cell: SimpleTextPostCollectionViewCell, _ isRetweetedUser: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if let dataList = dataList {
            if isRetweetedUser {
                let userId = dataList[indexPath.row - 1].retweetedBy.userID
                PushProfileToProfile(userId! , userProfileId!)
            } else {
                let userId = dataList[indexPath.row - 1].user.userId
                PushProfileToProfile(userId! , userProfileId!)
            }
        }
    }
    
    //MARK:-PostWithImages Actions
    func didUserProfileTapped(for cell: PostWithImagesCollectionViewCell, _ isRetweetedUser: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if let dataList = dataList {
            if isRetweetedUser {
                let userId = dataList[indexPath.row - 1].retweetedBy.userID
                PushProfileToProfile(userId! , userProfileId!)
            } else {
                let userId = dataList[indexPath.row - 1].user.userId
                PushProfileToProfile(userId! , userProfileId!)
            }
        }
    }
    
    //MARK:-QuotedPost Actions
    func didUserProfileTapped(for cell: QuotedPostCollectionViewCell, _ isQuotedUser: Bool, _ isRetweetedUser: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if let dataList = dataList {
            if isRetweetedUser {
                let userId = dataList[indexPath.row - 1].retweetedBy.userID
                PushProfileToProfile(userId! , userProfileId!)
            } else if isQuotedUser {
                let userId = dataList[indexPath.row - 1].tweetQuotedStatus.user.userId
                PushProfileToProfile(userId! , userProfileId!)
            } else {
                let userId = dataList[indexPath.row - 1].user.userId
                PushProfileToProfile(userId! , userProfileId!)
            }
        }
    }
    
    //MARK:-QuotedPostWithImage Actions
    func didUserProfileTapped(for cell: QuotedPostWithImageCollectionViewCell, _ isQuotedUser: Bool, _ isRetweetedUser: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if let dataList = dataList {
            if isRetweetedUser {
                let userId = dataList[indexPath.row - 1].retweetedBy.userID
                PushProfileToProfile(userId! , userProfileId!)
            } else if isQuotedUser {
                let userId = dataList[indexPath.row - 1].tweetQuotedStatus.user.userId
                PushProfileToProfile(userId! , userProfileId!)
            } else {
                let userId = dataList[indexPath.row - 1].user.userId
                PushProfileToProfile(userId! , userProfileId!)
            }
        }
    }
    
    //MARK:-PostWithImageAndQuote Actions
    func didUserProfileTapped(for cell: PostWithImageAndQuoteCollectionViewCell, _ isQuotedUser: Bool, _ isRetweetedUser: Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if let dataList = dataList {
            if isRetweetedUser {
                let userId = dataList[indexPath.row - 1].retweetedBy.userID
                PushProfileToProfile(userId! , userProfileId!)
            } else if isQuotedUser {
                let userId = dataList[indexPath.row - 1].tweetQuotedStatus.user.userId
                PushProfileToProfile(userId! , userProfileId!)
            } else {
                let userId = dataList[indexPath.row - 1].user.userId
                PushProfileToProfile(userId! , userProfileId!)
            }
        }
    }
    
    //MARK:-PostWithImageAndQuotedImage Actions
    func didUserProfileTapped(for cell: PostWithImageAndQuotedImageCollectionViewCell, _ isQuotedUser: Bool , _ isRetweetedUser:Bool) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if let dataList = dataList {
            if isRetweetedUser {
                let userId = dataList[indexPath.row - 1].retweetedBy.userID
                PushProfileToProfile(userId! , userProfileId!)
            } else if isQuotedUser {
                let userId = dataList[indexPath.row - 1].tweetQuotedStatus.user.userId
                PushProfileToProfile(userId! , userProfileId!)
            } else {
                let userId = dataList[indexPath.row - 1].user.userId
                PushProfileToProfile(userId! , userProfileId!)
            }
        }
    }
    
}
