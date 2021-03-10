//
//  highscoreTableViewController.swift
//  testLeaderboard
//
//  Created by Trent NaPatalung on 5/1/18.
//  Copyright © 2018 Tnaps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
//file not currently in use

class highscoreTableViewController: UITableViewController {
    private var fbusers: [FBUser]!
    private var fbRef:DatabaseReference!
    
    private func createDataModel(){
        fbusers = [FBUser]()
        
        let fbRef = Database.database().reference(withPath: "Highscores")
        print(fbRef)
        fbRef.queryOrdered(byChild: "User_Highscore").observe(.childAdded) { snapshot in
            print("The \(snapshot.key) dinosaur's score is \(snapshot.value ?? "null")")

            /*
            print(snapshot.value(forKey: "User Highscore"))
            print(snapshot.value(forKey: "Email"))
            print(snapshot.value(forKey: "Nickname"))
 */
            //print(snapshot.value(forKeyPath: "User Highscore"))
            //let test = snapshot.value as Dictionary
            let nickName = snapshot.childSnapshot(forPath: "Nickname").value as? String
            let fbtime = snapshot.childSnapshot(forPath: "User_Highscore").value as? NSNumber
            let fbuser = FBUser(id: snapshot.key, Nickname: nickName!, fasttime: "\(fbtime)")
            print(fbuser.FBNickname)
            print(fbuser.time)
            
            self.fbusers.append(fbuser)
            
        }
        print(fbusers)
    }
    override func viewDidLoad() {
        createDataModel()

        super.viewDidLoad()
        self.title = "Fastest Times Leaderboard"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fbusers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)

        let fbuser = self.fbusers[indexPath.row]
        
        cell.textLabel?.text = "\(fbuser.FBNickname) "
        cell.detailTextLabel?.text = String(fbuser.time)
        
        return cell
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
