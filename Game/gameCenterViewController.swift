//
//  gameCenterViewController.swift
//  testLeaderboard
//
//  Created by Trent NaPatalung on 4/27/18.
//  Copyright © 2018 Tnaps. All rights reserved.
//

import UIKit
import Firebase

class gameCenterViewController: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Race Hub"
        whoSignedIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutBtnClicked(_ sender: Any) {
        //signs out the user
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        //brings back to previous screen
        self.dismiss(animated: true, completion: nil)
        
    }
    func whoSignedIn(){
        //doesnt work for create user login because VC is instantiated before being logged in
        let user = Auth.auth().currentUser

        if(user != nil){
            userLabel.text = user?.email
        }
        else{
            userLabel.text = "Guest"
        }
    }

}
