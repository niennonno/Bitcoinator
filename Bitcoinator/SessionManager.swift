//
//  SessionManager.swift
//  Bitcoinator
//
//  Created by Aditya Vikram Godawat on 04/07/18.
//  Copyright © 2018 Aditya Vikram Godawat. All rights reserved.
//

import Foundation
import SwiftyJSON

class UTX: NSObject {
    var transactionHash: String!
    var largestValue: Int!
    
    init(fromJSON json: JSON?) {
        super.init()
        guard let json = json else { return }
        
        transactionHash = json["hash"].stringValue
        if let outs = json["out"].array {
            var highValue = [Int]()
            for out in outs {
                highValue.append(out["value"].intValue)
            }
            largestValue = highValue.max()
            print(largestValue)
        }
    }
}

class Block: NSObject {
    var blockHash: String!
    var blockHeight: Int!
    var btcSent: Double!
    var reward: Double!

    init(fromJSON json: JSON?) {
        super.init()
        guard let json = json else { return }

        blockHash = json["hash"].stringValue
        blockHeight = json["height"].intValue
        btcSent = json["totalBTCSent"].doubleValue
        reward = json["reward"].doubleValue
    }
}
