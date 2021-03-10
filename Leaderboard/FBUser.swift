//
//  FBUser.swift
//  testLeaderboard
//
//  Created by Trent NaPatalung on 4/29/18.
//  Copyright © 2018 Tnaps. All rights reserved.
//

import Foundation
//firebase user
class FBUser {
    var id:String
    var FBNickname: String
    var time: String
    
    init(id:String, Nickname: String, fasttime: String) {
        self.id = id
        self.FBNickname = Nickname
        self.time = fasttime
    }
}
