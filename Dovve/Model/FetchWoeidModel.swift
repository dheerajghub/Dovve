//
//  FetchWoeidModel.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 04/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetWoeidModel: NSObject {
    var country:String!
    var woeid:Int!
    
    static func fetchWoeid(searchQ:String,completionHandler: @escaping ([GetWoeidModel]) -> ()){
        
        if let path = Bundle.main.path(forResource: "Woeid", ofType: "json") {
            do {
                  let JsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let data = JSON(JsonData)
                var modelList = [GetWoeidModel]()
                for i in 0..<data.count {
                    if searchQ != "" {
                        let searchFor = searchQ.lowercased()
                        let searchingFor = data[i]["country"].string?.lowercased()
                        if (searchingFor?.hasPrefix(searchFor))! {
                            let model = GetWoeidModel()
                            model.country = "\(data[i]["country"].string ?? "") - \(data[i]["name"].string ?? "")"
                            model.woeid = data[i]["woeid"].int
                            modelList.append(model)
                        }
                    } else {
                        let model = GetWoeidModel()
                        model.country = "\(data[i]["country"].string ?? "") - \(data[i]["name"].string ?? "")"
                        model.woeid = data[i]["woeid"].int
                        modelList.append(model)
                    }
                }
                
                DispatchQueue.main.async {
                    completionHandler(modelList)
                }
              } catch {
                   // handle error
              }
        }
    }
}
