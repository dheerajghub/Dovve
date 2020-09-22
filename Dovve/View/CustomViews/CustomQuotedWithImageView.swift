//
//  CustomQuotedWithImageView.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 22/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class CustomQuotedWithImageView: UIView {

    var data:[String]?
    var imageHeightContraints:NSLayoutConstraint?
    var delegate:QuotedPostWithImageCollectionViewCell?
    var delegate2:PostWithImageAndQuotedImageCollectionViewCell?
    
    let profileImageView:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "demo")
        img.clipsToBounds = true
        img.layer.cornerRadius = 12.5
        return img
    }()
    
    let userInfo:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let tweet:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: CustomFonts.appFont, size: 17)
        l.textColor = UIColor.dynamicColor(.textColor)
        l.numberOfLines = 0
        return l
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.setCollectionViewLayout(layout, animated: false)
        cv.backgroundColor = UIColor.dynamicColor(.appBackground)
        cv.delegate = self
        cv.dataSource = self
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        addSubview(profileImageView)
        addSubview(userInfo)
        addSubview(tweet)
        addSubview(collectionView)
        setUpConstraints()
        setUpAttributes("Full name", "username", "2h", true)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            profileImageView.widthAnchor.constraint(equalToConstant: 25),
            profileImageView.heightAnchor.constraint(equalToConstant: 25),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            
            userInfo.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            userInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            userInfo.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            userInfo.heightAnchor.constraint(equalToConstant: 25),
            
            tweet.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            tweet.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            tweet.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10),
            tweet.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5),
            
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpAttributes( _ name:String, _ userName:String , _ time:String, _ isVerified:Bool){
        let attributedText = NSMutableAttributedString(string:"\(name) " , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(.textColor)])
        
        if isVerified {
            let font = UIFont.systemFont(ofSize: 16)
            let verifiyImg = UIImage(named:"verify")
            let verifiedImage = NSTextAttachment()
            verifiedImage.image = verifiyImg
            verifiedImage.bounds = CGRect(x: 0, y: (font.capHeight - 16).rounded() / 2, width: 16, height: 16)
            verifiedImage.setImageHeight(height: 16)
            let imgString = NSAttributedString(attachment: verifiedImage)
            attributedText.append(imgString)
        }
        
        attributedText.append(NSAttributedString(string: " @\(userName)" , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 17)! , NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))
        
        attributedText.append(NSAttributedString(string: " • \(time)" , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 17)!, NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))
        
        userInfo.attributedText = attributedText
    }

}


extension CustomQuotedWithImageView:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (data?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.data = data?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (data?.count) == 1 {
          return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        if (data?.count) == 2 || (data?.count) == 3 {
          return CGSize(width: ((collectionView.frame.width / 2) - 1), height: collectionView.frame.height)
        }
        if (data?.count) == 4{
            return CGSize(width: ((collectionView.frame.width / 2) - 1), height: ((collectionView.frame.height / 2) - 1))
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
