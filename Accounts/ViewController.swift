//
//  ViewController.swift
//  testLeaderboard
//
//  Created by Trent NaPatalung on 4/20/18.
//  Copyright © 2018 Tnaps. All rights reserved.
//

import UIKit
import Firebase
//import AVFoundation //for music
//Espionage Music - Snake Eater (Instrumental) - Super Smash Bros. Brawl
//Hills Music - Green Hill Zone - Super Smash Bros. Brawl
//Background Music - Avengers: Infinity War - Official Final Trailer #2 Music (2018) - MAIN THEME - TRAILER VERSION
//App Icon - https://ar.m.wikipedia.org/wiki/%D9%85%D9%84%D9%81:Seal_of_Seoul.svg


class ViewController: UIViewController {
    

   //var backGroundPlayer = AVAudioPlayer() //for music
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: #selector(logInButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.title = "Sign in for the race"
        //code for leaderboard
        //DataStorage.shared.loadFBUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func logIn() {
        //if(emailTxtField.text != "" && passwordTxtField.text != ""){
        //if statement for case of not blank
                Auth.auth().signIn(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (user, error) in
                print("Signed in as \(user?.email ?? "Guest" )")
                //label telling user signed in as guest b/c email/password combination not found
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let ngcvc = storyboard.instantiateViewController(withIdentifier: "navGCVC") as? UINavigationController {

                        // Present the view controller instead of segue to force sign out when returning to login screen
                        self.present(ngcvc, animated: true, completion: nil)
                    }
                    }
                }
        //If login information doesnt exist then user signed in as guest

        }
    /* else if the text fields were empty
        else {
            //alert controller saying text field is empty
            print("blank text fields")
        }
        
    }
 */

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
    func textFieldShouldReturn(_ textField: UITextField) ->
        Bool {
            // 'First Responder' is the same as 'input focus'.
            // We are removing input focus from the text field.
            self.passwordTxtField.resignFirstResponder()
            self.emailTxtField.resignFirstResponder()
            return true
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This causes the keyboard to be dismissed.
        self.view.endEditing(true)
    }
    

}

