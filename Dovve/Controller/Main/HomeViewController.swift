//
//  HomeViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 19/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.register(HomeFeedCollectionViewCell.self, forCellWithReuseIdentifier: "HomeFeedCollectionViewCell")
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFeedCollectionViewCell", for: indexPath) as! HomeFeedCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.7
    }
    
}
