//
//  leaderboardTableViewController.swift
//  testLeaderboard
//
//  Created by Trent NaPatalung on 4/28/18.
//  Copyright © 2018 Tnaps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class leaderboardTableViewController: UITableViewController {

    private var fbusers: [FBUser]!
    private var fbRef:DatabaseReference!
    public var listoffbusers:[FBUser]!
    
    private func createDataModel(){
            fbusers = [FBUser]()
            listoffbusers = [FBUser]()
            
            let fbRef = Database.database().reference(withPath: "Highscores")
            //print(fbRef) for debugging
    
            fbRef.queryOrdered(byChild: "User_Highscore").observe(.childAdded) { snapshot in
                //print("The \(snapshot.key) User key for \(snapshot.value ?? "null")")
                let nickName = snapshot.childSnapshot(forPath: "Nickname").value as? String
                var fbuser = FBUser(id: snapshot.key, Nickname: nickName!, fasttime: "N/A")
                if(snapshot.childSnapshot(forPath: "User_Highscore").value as? String != "N/A"){ //if new user time will be N/A
                    let fbtime = snapshot.childSnapshot(forPath: "User_Highscore").value as? Float
                    //let fbtimeint = snapshot.childSnapshot(forPath: "User_Highscore").value as? Int
                    let fbtimestring = fbtime!
                    fbuser = FBUser(id: snapshot.key, Nickname: nickName!, fasttime: "\(fbtimestring)")
                }

                print(fbuser.FBNickname)
                print(fbuser.time)
                
                self.listoffbusers.append(fbuser)
                print(self.listoffbusers)
                //self.fbusers.append(fbuser)
                    }
        //code below not needed because now using listoffbuserslist
        let delayInSeconds = 1.5
        let popTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
        for user in self.listoffbusers{
            self.fbusers.append(user)
            //self.tableView.reloadData()

            }
            self.tableView.reloadData()
        }
        //self.tableView.reloadData()

    }

        override func viewDidLoad() {
            //Problem right now - tableview takes listoffbusers count  before the create datamodel method finishes

            createDataModel()
            
           // let delayInSeconds = 1
           // let popTime = DispatchTime.now() + Double(Int64(Double(delayInSeconds) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
          //  DispatchQueue.main.asyncAfter(deadline: popTime) {
 
            super.viewDidLoad()
            self.title = "Fastest Times Leaderboard"
       // }

    }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //Problem right now - tableview takes listoffbusers count  before the create datamodel method finishes
            //currently hard coded for three entries
            //var count:Int = 3
            let count = fbusers.count
            return count
            
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
           let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
           // let delayInSeconds = 0.5
           // let popTime = DispatchTime.now() + Double(Int64(Double(delayInSeconds) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
           // DispatchQueue.main.asyncAfter(deadline: popTime) {
            
            let fbuser = self.listoffbusers[indexPath.row]
            
            cell.textLabel?.text = "\(fbuser.FBNickname) "
            cell.detailTextLabel?.text = String(fbuser.time)
            
         //   }
            return cell
        }
}
