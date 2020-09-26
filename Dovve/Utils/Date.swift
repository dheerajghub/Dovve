//
//  Date.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 26/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import Foundation

extension Date{
    
    func getTimeAgoDisplay(_ type : String) -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        if secondsAgo == 0{
            if type == "short" {
                return "just now"
            } else if type == "long" {
                return "just now"
            }
        } else if secondsAgo < minute {
            if type == "short" {
                return "\(secondsAgo)s"
            } else if type == "long" {
                return "\(secondsAgo) second ago"
            }
        } else if secondsAgo < hour {
            if type == "short" {
                return "\(secondsAgo / minute)m"
            } else if type == "long" {
                return "\(secondsAgo / minute) minute ago"
            }
        } else if secondsAgo < day {
            if type == "short" {
                return "\(secondsAgo / hour)h"
            } else if type == "long" {
                return "\(secondsAgo / hour) hour ago"
            }
        } else if secondsAgo < week {
            if type == "short" {
                return "\(secondsAgo / day)d"
            } else if type == "long" {
                return "\(secondsAgo / day) day ago"
            }
        }
        if type == "short" {
            return "\(secondsAgo / week)w"
        } else if type == "long" {
            return "\(secondsAgo / week) week ago "
        }
        return ""
    }
}
