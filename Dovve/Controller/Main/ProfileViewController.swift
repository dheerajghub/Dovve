//
//  ProfileViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 20/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
//
//    lazy var navBar:CustomProfileNavBar = {
//        let v = CustomProfileNavBar()
//        v.controller = self
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .white
//        v.layer.shadowRadius = 10
//        v.layer.shadowColor = UIColor(white: 0, alpha: 0.1).cgColor
//        v.layer.shadowOpacity = 1
//        v.layer.shadowOffset = CGSize(width: 0, height: 10)
//        return v
//    }()
//
//    lazy var collectionView:UICollectionView = {
//        let layout:UICollectionViewFlowLayout = StretchyCollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.showsVerticalScrollIndicator = false
//        cv.register(HomeFeedCollectionViewCell.self, forCellWithReuseIdentifier: "HomeFeedCollectionViewCell")
//        cv.register(ProfileStrechyHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileStrechyHeader")
//        cv.register(ProfileHeaderCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileHeaderCollectionViewCell")
//        cv.setCollectionViewLayout(layout, animated: false)
//        cv.delegate = self
//        cv.dataSource = self
//        cv.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
//        return cv
//    }()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
//        view.addSubview(collectionView)
//        view.addSubview(navBar)
//        collectionView.pin(to: view)
//        setUpCustomNavBar()
//        setUpConstraints()
    }
//
//    func setUpConstraints(){
//        NSLayoutConstraint.activate([
//            navBar.topAnchor.constraint(equalTo: view.topAnchor),
//            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            navBar.heightAnchor.constraint(equalToConstant: 100)
//        ])
//    }
//
//    func setUpCustomNavBar(){
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//    }
//
}
//
//extension ProfileViewController:UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileStrechyHeader", for: indexPath) as? ProfileStrechyHeader {
//                headerView.imageView.image = UIImage(named: "demo")
//                return headerView
//            }
//            return UICollectionReusableView()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHeaderCollectionViewCell", for: indexPath) as! ProfileHeaderCollectionViewCell
//            return cell
//        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFeedCollectionViewCell", for: indexPath) as! HomeFeedCollectionViewCell
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.row == 0 {
//            return CGSize(width: collectionView.frame.width, height: 250)
//        }
//        return CGSize(width: collectionView.frame.width, height: 150)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.width * 1/5)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.7
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.7
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let y = scrollView.contentOffset.y
//        let v = y/80
//        let value = Double(round(100*v)/100)
//
//        if value >= 1.0 {
//            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
//                self.navBar.alpha = 1
//            }, completion: nil)
//
//            UIView.animate(withDuration: 0.4) {
//                self.navBar.titleLabel.transform = CGAffineTransform(translationX: 0, y: 0)
//            }
//
//        } else {
//            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
//                self.navBar.alpha = 0
//            }, completion: nil)
//
//            UIView.animate(withDuration: 0.4) {
//                self.navBar.titleLabel.transform = CGAffineTransform(translationX: 0, y: +50)
//            }
//        }
//    }
//
//}
