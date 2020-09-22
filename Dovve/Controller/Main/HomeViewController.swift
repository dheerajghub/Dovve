//
//  HomeViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 19/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var data = [SimpleTextedPost]()
    
    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
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
        collectionView.pin(to: view)
        setUpCustomNavBar()
        
        data = [
            SimpleTextedPost(profileImage: "demo", name: "Full name", screen_name: "username", isVerified: true, time: "2h", media: nil, tweet: "This is test this is test", comments: "2,322", retweets: "1,231", likes: "1,212",isQuotedView:false,quotedStatus:nil),
            SimpleTextedPost(profileImage: "demo", name: "Full name", screen_name: "username", isVerified: false, time: "2h",media: nil, tweet: "This is test this is test this is test is test this is test this is testasd is test this is test this is test This is test this is test this is test is test this is test this is testasd is test this is test this is test This is test this is test this is test is.", comments: "2,322", retweets: "1,231", likes: "1,212",isQuotedView:true,quotedStatus: QuotedStatus(profileImage: "demo", name: "Full name", screen_name: "username", time: "2h", isVerified: false, tweet: "This is long long tweet hello this is long long tweet This is long long tweet hello this is long long tweet This is long long tweet hello this is long long tweet This is long long tweet hello this is long long tweet", media: nil)),
            SimpleTextedPost(profileImage: "demo", name: "Full name", screen_name: "username", isVerified: false, time: "2h",media: ["demo", "demo"], tweet: "This is test this is test this is test is test this is test this is testasd is test this is test this is test This is test this is test this is test.", comments: "2,322", retweets: "1,231", likes: "1,212",isQuotedView:true,quotedStatus: QuotedStatus(profileImage: "demo", name: "Full name", screen_name: "username", time: "2h", isVerified: false, tweet: "This is long long tweet hello this is long long tweet This is long long tweet hello this is long long tweet.", media: nil)),
            SimpleTextedPost(profileImage: "demo", name: "Full name", screen_name: "username", isVerified: true, time: "2h",media: ["demo"], tweet: "This is test this is test this is test is test this is test this is testasd is test this is test this is test", comments: "2,322", retweets: "1,231", likes: "1,212",isQuotedView:false,quotedStatus: nil),
            SimpleTextedPost(profileImage: "demo", name: "Full name", screen_name: "username", isVerified: true, time: "2h",media: ["demo","demo"], tweet: "This is test this is test this is test is test this is test this is testasd is test this is test this is test", comments: "2,322", retweets: "1,231", likes: "1,212",isQuotedView:false,quotedStatus: nil),
            SimpleTextedPost(profileImage: "demo", name: "Full name", screen_name: "username", isVerified: false, time: "2h",media: nil, tweet: "This is test this is test this is test is test this is test this is testasd is test this is test this.", comments: "2,322", retweets: "1,231", likes: "1,212",isQuotedView:true,quotedStatus: QuotedStatus(profileImage: "demo", name: "Full name", screen_name: "username", time: "2h", isVerified: false, tweet: "This is long long tweet hello this is long long tweet This is long long tweet hello this is long long tweet.", media: ["demo", "demo"])),
            SimpleTextedPost(profileImage: "demo", name: "Full name", screen_name: "username", isVerified: false, time: "2h",media: ["demo", "demo" , "demo" , "demo"], tweet: "This is test this is test this is test is test this is test this is testasd is test this is test this.", comments: "2,322", retweets: "1,231", likes: "1,212",isQuotedView:true,quotedStatus: QuotedStatus(profileImage: "demo", name: "Full name", screen_name: "username", time: "2h", isVerified: false, tweet: "This is long long tweet hello this is long long tweet This is long long tweet hello this is long long tweet.", media: ["demo", "demo"])),
        ]
    }
    
    func setUpCustomNavBar(){
        navigationController?.navigationBar.topItem?.title = "Home"
        navigationController?.navigationBar.barTintColor = UIColor.dynamicColor(.appBackground)
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: CustomFonts.appFontBold, size: 19)!,
            NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(.textColor)
        ]
        
    }
    
}

extension HomeViewController:UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if data[indexPath.row].media == nil && data[indexPath.row].isQuotedView == false {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleTextPostCollectionViewCell", for: indexPath) as! SimpleTextPostCollectionViewCell
            cell.data = data[indexPath.row]
            return cell
        }
        if data[indexPath.row].media != nil &&  data[indexPath.row].isQuotedView == false {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostWithImagesCollectionViewCell", for: indexPath) as! PostWithImagesCollectionViewCell
            cell.data = data[indexPath.row]
            return cell
        }
        if data[indexPath.row].media == nil && data[indexPath.row].isQuotedView == true && data[indexPath.row].quotedStatus.media == nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotedPostCollectionViewCell", for: indexPath) as! QuotedPostCollectionViewCell
            cell.data = data[indexPath.row]
            return cell
        }
        if data[indexPath.row].media != nil && data[indexPath.row].isQuotedView == true && data[indexPath.row].quotedStatus.media == nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostWithImageAndQuoteCollectionViewCell", for: indexPath) as! PostWithImageAndQuoteCollectionViewCell
            cell.data = data[indexPath.row]
            return cell
        }
        if data[indexPath.row].media == nil && data[indexPath.row].isQuotedView == true && data[indexPath.row].quotedStatus.media != nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotedPostWithImageCollectionViewCell", for: indexPath) as! QuotedPostWithImageCollectionViewCell
            cell.data = data[indexPath.row]
            return cell
        }
        if data[indexPath.row].media != nil && data[indexPath.row].isQuotedView == true && data[indexPath.row].quotedStatus.media != nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostWithImageAndQuotedImageCollectionViewCell", for: indexPath) as! PostWithImageAndQuotedImageCollectionViewCell
            cell.data = data[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if data[indexPath.row].media == nil && data[indexPath.row].isQuotedView == false {
            let font = UIFont(name: CustomFonts.appFont, size: 17)!
            let estimatedH = data[indexPath.row].tweet.height(withWidth: (collectionView.frame.width - 100), font: font)
            return CGSize(width: collectionView.frame.width, height: estimatedH + 95 )
        }
        if data[indexPath.row].media != nil &&  data[indexPath.row].isQuotedView == false {
            let font = UIFont(name: CustomFonts.appFont, size: 17)!
            let estimatedH = data[indexPath.row].tweet.height(withWidth: (collectionView.frame.width - 100), font: font)
            let extraHeight = 105 + ((collectionView.frame.width - 100) * (9 / 16))
            return CGSize(width: collectionView.frame.width, height: estimatedH + extraHeight )
        }
        if data[indexPath.row].media == nil && data[indexPath.row].isQuotedView == true && data[indexPath.row].quotedStatus.media == nil {
            let font = UIFont(name: CustomFonts.appFont, size: 17)!
            let estimatedH = data[indexPath.row].tweet.height(withWidth: (collectionView.frame.width - 100), font: font)
            let estimatedHForQuotedTweet = data[indexPath.row].quotedStatus.tweet.height(withWidth: ((collectionView.frame.width - 100) - 30), font: font)
            return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + 160)
        }
        if data[indexPath.row].media != nil && data[indexPath.row].isQuotedView == true && data[indexPath.row].quotedStatus.media == nil {
            let font = UIFont(name: CustomFonts.appFont, size: 17)!
            let estimatedH = data[indexPath.row].tweet.height(withWidth: (collectionView.frame.width - 100), font: font)
            let estimatedHForQuotedTweet = data[indexPath.row].quotedStatus.tweet.height(withWidth: ((collectionView.frame.width - 100) - 30), font: font)
            let imageCollectionForPostH = (collectionView.frame.width - 100) * (9/16)
            return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + imageCollectionForPostH + 175)
        }
        if data[indexPath.row].media == nil && data[indexPath.row].isQuotedView == true && data[indexPath.row].quotedStatus.media != nil {
            let font = UIFont(name: CustomFonts.appFont, size: 17)!
            let estimatedH = data[indexPath.row].tweet.height(withWidth: (collectionView.frame.width - 100), font: font)
            let estimatedHForQuotedTweet = data[indexPath.row].quotedStatus.tweet.height(withWidth: ((collectionView.frame.width - 100) - 30), font: font)
            let imageCollectionHeight = ((collectionView.frame.width - 100) * (9/16))
            return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + imageCollectionHeight + 160)
        }
        if data[indexPath.row].media != nil && data[indexPath.row].isQuotedView == true && data[indexPath.row].quotedStatus.media != nil {
            let font = UIFont(name: CustomFonts.appFont, size: 17)!
            let estimatedH = data[indexPath.row].tweet.height(withWidth: (collectionView.frame.width - 100), font: font)
            let estimatedHForQuotedTweet = data[indexPath.row].quotedStatus.tweet.height(withWidth: ((collectionView.frame.width - 100) - 30), font: font)
            let imageCollectionHeight = ((collectionView.frame.width - 100) * (9/16))
            let imageCollectionForPostH = (collectionView.frame.width - 100) * (9/16)
            return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + imageCollectionHeight + imageCollectionForPostH + 175)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.7
    }
    
}
