//
//  createUserViewController.swift
//  testLeaderboard
//
//  Created by Trent NaPatalung on 4/20/18.
//  Copyright © 2018 Tnaps. All rights reserved.
//

import UIKit
import Firebase

class createUserViewController: UIViewController {
    var fbRef: DatabaseReference!

    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var createUserBtn: UIButton!
    @IBOutlet weak var acctCreationResultLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbRef = Database.database().reference()
        self.title = "Sign up for the race"
        createUserBtn.addTarget(self, action: #selector(createUserBtnClicked(_:)), for: UIControlEvents.touchUpInside)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createAcct(){
        if(emailTxtField.text != "" && passwordTxtField.text != ""){

            Auth.auth().createUser(withEmail: emailTxtField.text!, password: passwordTxtField.text!, completion: { (user, err) in
                if let error = err {
                    print(error.localizedDescription)
                    self.acctCreationResultLbl.text = error.localizedDescription
                    //sleep(3)
            }
            else {

                    print("Signed in as \(user?.email ?? "Guest" )")
                    let user = Auth.auth().currentUser
                    var emailName:String = ""
                    
                    if ((user) != nil) { //If a user
                        emailName = (user?.email!)!
                    }
                    self.fbRef.child("Users").childByAutoId().setValue(["name":emailName])
                    //adds account to users database
                    self.fbRef.child("Highscores").child((user?.uid)!).setValue(["User_Highscore":"N/A","Email":emailName,"Nickname":"New User"])
                    //NA might mess up query if so change it to 999999 high number
                    //make this add one not set to one
                    //self.fbRef.child("Count").setValue(1)
                    //adds a default "highscore"/ slowest possible time
                    self.acctCreationResultLbl.text = "Account creation was successful"
                    
                    //test for table view code below
                    let fbuser = FBUser(id: (user?.uid)!, Nickname: (user?.email!)!, fasttime: "99999999")
                    DataStorage.shared.addFBUser(fbuser: fbuser)
                }
            }
            
        )
    // need to have text to signify if user already created


        }
    }
    @IBAction func createUserBtnClicked(_ sender: Any) {

            //current problem - createAcct doesnt finish before vc is instantiated
        //DispatchQueue.main.async{
        acctCreationResultLbl.text = "Please wait a moment"
        createAcct()
        //}
        //Delay so createAcct can finish before new controller instantiated
        DispatchQueue.main.asyncAfter(deadline: .now() + 4){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let ngcvc = storyboard.instantiateViewController(withIdentifier: "navGCVC") as? UINavigationController {

            // Present the view controller over the current one.
            // Present the view controller instead of segue to force sign out when returning to login screen
            self.present(ngcvc, animated: true, completion: nil)
            }
        
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
