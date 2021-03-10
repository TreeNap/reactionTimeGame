//
//  scoreCard.swift
//  testLeaderboard
//
//  Created by Trent NaPatalung on 4/25/18.
//  Copyright © 2018 Tnaps. All rights reserved.
//

import Foundation
//file not currently in use

class scoreCard{
    var highScore = 0
    var userName:String = ""


init(score:Int, uName:String){
    self.highScore = score
    self.userName = uName
}
func toAnyObject() -> Any {
        return ["name":self.userName ?? "",
                "score": self.highScore] as Any
    }
}
