//
//  DataStorage.swift
//  testLeaderboard
//
//  Created by Trent NaPatalung on 4/29/18.
//  Copyright © 2018 Tnaps. All rights reserved.
//

import Foundation
import Firebase
//file not currently in use
class DataStorage {
    
    // Instantiate the singleton object.
    static let shared = DataStorage()
    
    private var ref: DatabaseReference!
    private var Highscores: [FBUser]!
    
    // Private only this class can instantion obj type
    private init() {
        // Get a database reference.
        // Needed so can read/write to/from the firebase database.
        ref = Database.database().reference()
    }
    
    func count() -> Int {
        return Highscores.count
    }
    
    func getFBUser(index: Int) -> FBUser {
        return Highscores[index]
    }
    
    func loadFBUsers() {
        // empty array
        Highscores = [FBUser]()
        
        // Fetches the data from Firebase to store in internal people array.
        // This is a one-time listener.
        //let fastestTimesQuery = (ref?.child("Highscores").queryLimited(toFirst: 10))!
        //let myTopPostsQuery = (ref.child("Highscores").queryLimited(toLast: 10).child(getUid())).queryOrdered(byKey: "score")

        ref.child("Leaderboard").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get the top-level dictionary.
            let value = snapshot.value as? NSDictionary
            
            if let fbusers = value {
                // Iterate over fbuser objects to put in internal array
                for u in fbusers {
                    let id = u.key as! String
                    let fbuser = u.value as! [String:String]
                    let nName = fbuser["Nickname"]
                    let ntime = fbuser["Fastest time"]
                    let newFBUser = FBUser(id: id, Nickname: nName!, fasttime: ntime! )
                    self.Highscores.append(newFBUser)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addFBUser(fbuser: FBUser) {
        // define array of key/value pairs to store for this user.
        let userRecord = ["Nickname": fbuser.FBNickname, "Fastest time": fbuser.time]
        
        // Saves to Firebase.
        self.ref.child("Leaderboard").child(fbuser.id).setValue(userRecord)
        
        // Also saves to internal array, to stay in sync with info in Firebase.
        Highscores.append(fbuser)
    }
}
