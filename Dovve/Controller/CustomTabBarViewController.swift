//
//  CustomTabBarViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 19/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate{

    var homeViewController:UIViewController!
    var exploreViewController:UIViewController!
    var mentionViewController:UIViewController!
    var profileViewController:UIViewController!
    
    var tabItem = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        let vc1 = HomeViewController()
        homeViewController = UINavigationController(rootViewController: vc1)
        
        let vc2 = SearchViewController()
        exploreViewController = UINavigationController(rootViewController: vc2)
        
        let vc3 = MentionsViewController()
        mentionViewController = UINavigationController(rootViewController: vc3)
        
        let vc4 = ProfileViewController()
        profileViewController = UINavigationController(rootViewController: vc4)
        
        viewControllers = [homeViewController , exploreViewController , mentionViewController , profileViewController]
        
        setUpViews()
        
        customTab(selectedImage: "home-selected", deselectedImage: "home", indexOfTab: 0 , tabTitle: "")
        customTab(selectedImage: "explore", deselectedImage: "search", indexOfTab: 1 , tabTitle: "")
        customTab(selectedImage: "mentions-selected", deselectedImage: "mentions", indexOfTab: 2 , tabTitle: "")
        customTab(selectedImage: "profile-selected", deselectedImage: "profile", indexOfTab: 3 , tabTitle: "")
    }
    
    func setUpViews(){
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.barTintColor = UIColor.dynamicColor(.appBackground)
    }
    
    func customTab(selectedImage image1 : String , deselectedImage image2: String , indexOfTab index: Int , tabTitle title: String ){

        let selectedImage = UIImage(named: image1)!.withRenderingMode(.alwaysTemplate)
        let deselectedImage = UIImage(named: image2)!.withRenderingMode(.alwaysTemplate)
        
        tabItem = self.tabBar.items![index]
        tabItem.image = deselectedImage
        tabItem.selectedImage = selectedImage
        tabItem.title = .none
        tabItem.imageInsets.bottom = -11
    }
}
