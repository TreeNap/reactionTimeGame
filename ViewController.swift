//
//  ViewController.swift
//  testLeaderboard
//
//  Created by Trent NaPatalung on 4/20/18.
//  Copyright © 2018 Tnaps. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation //for music

class ViewController: UIViewController {
    
    var backGroundPlayer = AVAudioPlayer() //for music
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: #selector(logInButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        playBackGroundMusic(fileNamed: "ES_Daffodils - Guustavv.mp3")
        self.title = "Sign in for the race"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //code below to add music
    func playBackGroundMusic(fileNamed: String){
        let url = Bundle.main.url(forResource: fileNamed, withExtension: nil)
        guard let newUrl = url else{
            print("Could not find file called \(fileNamed)")
                return
        }
            do {
                backGroundPlayer = try AVAudioPlayer(contentsOf: newUrl)
                backGroundPlayer.numberOfLoops = -1
                backGroundPlayer.prepareToPlay()
               // backGroundPlayer.play()
                
            }
            catch let error as NSError {
                print(error.description)
            }
    }
    
    
    func logIn() {
        if(emailTxtField.text != "" && passwordTxtField.text != ""){
                Auth.auth().signIn(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
                print("Signed in as \(user?.email ?? "Guest" )")
                //label telling user signed in as guest b/c email/password combination not found
                
                self.performSegue(withIdentifier: "loginToGameCenterSegue", sender: self)
                }

        }
        else {
            //alert controller saying text field is empty
            print("blank text fields")
            backGroundPlayer.stop() //this code for settings screen to stop playing music
        }
        
    }

    @objc func logInButtonClicked(sender: UIButton) {
        logIn()
    }

    @IBAction func signOutBtnClicked(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    

}

