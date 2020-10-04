//
//  ColorTheme.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 21/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

protocol AppThemeProtocol {
  var lightTheme: UIColor { get }
  var darkTheme: UIColor { get }
}

extension UIColor {
     enum AppColor: AppThemeProtocol {
       
        case appBackground
        case textColor
        case secondaryBackground
        case secondaryTextColor
        case darkBackground
        
        var lightTheme: UIColor {
            switch self {
            case .appBackground:
                return UIColor.white
            case .textColor:
                return CustomColors.appBlack
            case .secondaryBackground:
                return CustomColors.appExtraLightGray
            case .secondaryTextColor:
                return CustomColors.appDarkGray
            case .darkBackground:
                return CustomColors.appExtraLightGray
            }
        }

        var darkTheme: UIColor {
            switch self {
            case .appBackground:
                return CustomColors.appBackground
            case .textColor:
                return UIColor.white
            case .secondaryBackground:
                return CustomColors.appDarkGray
            case .secondaryTextColor:
                return CustomColors.appExtraLightGray
            case .darkBackground:
                return CustomColors.appSecondaryBackground
            }
        }
        
     }
     
     // Add business logic here, depending to use case.
     static func dynamicColor(_ color: AppColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return color.darkTheme
                } else {
                    return color.lightTheme
                }
            }
        } else {
            return color.lightTheme
        }
    }
}
