//
//  gameViewController.swift
//  testLeaderboard
//
//  Created by Trent NaPatalung on 4/25/18.
//  Copyright © 2018 Tnaps. All rights reserved.
//

import UIKit
import Firebase

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

class gameViewController: UIViewController {
    var fbRef: DatabaseReference!

    @IBOutlet weak var scoreNum: UILabel!
    @IBOutlet weak var nicknameTxtField: UITextField!
    @IBOutlet weak var submitStatusLbl: UILabel!
    @IBOutlet weak var gamePiece: UIImageView!
    
    var time:CGFloat = 0.0
    var finalTime:CGFloat = 0.0
    var timer = Timer()
    var limit:Int = 10
    var gamePieceWidth:CGFloat = 0.0
    var gamePieceHeight:CGFloat = 0.0
    var count:Int = 0
    
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var scoreStamp: UILabel!
    
    var shapeID = Int(arc4random_uniform(4))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //for leaderboards
        fbRef = Database.database().reference()
        let user = Auth.auth().currentUser
        if(user == nil){
            submitStatusLbl.text = "Please sign in to submit score"
        }
        else{//user is not nil
            let userID = Auth.auth().currentUser?.uid;
            fbRef.child("Highscores").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let currentScore = value?["User_Highscore"] as? String
            if(currentScore  == "N/A"){//new player
                self.submitStatusLbl.text="First time playing? Good luck and be fast!"
                }
            else{
                let currentScore = value?["User_Highscore"] as? Float
                let s = NSString(format: "%.2f", currentScore!)
                self.submitStatusLbl.text="Current Highscore is \(s)"
                }

            })
            
        }
        
            self.title = "Shape Race"
            self.view.backgroundColor = UIColor.white
            self.gamePieceWidth = self.gamePiece.frame.size.width
            self.gamePieceHeight = self.gamePiece.frame.size.height
            gamePiece.isUserInteractionEnabled = true
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            shapeGenerator(newShapeID: shapeID)
            gamePiece.frame.size.width = 100
            gamePiece.frame.size.height = 100
            gamePiece.isUserInteractionEnabled = true
            gamePiece.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            gamePiece.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func shapeGenerator(newShapeID:Int) {
        if newShapeID == 0 {
            // New shape is a triangle
            self.gamePiece.image = UIImage(named: "greentriangle")
        }
        if newShapeID == 1 {
            // New shape is a square
            self.gamePiece.image = UIImage(named: "pinksquare")
        }
        if newShapeID == 2 {
            // New shape is a circle
            self.gamePiece.image = UIImage(named: "redcircle")
        }
        if newShapeID == 3 {
            // New shape is an "X"
            self.gamePiece.image = UIImage(named: "bluex")
        }
        self.gamePiece.center.x = screenWidth / 2
        self.gamePiece.center.y = screenHeight / 2
        
    }
    
    func gameOver() {
        finalTime = time
        self.timer.invalidate()
        let finalTimeMessage = "Final Time: " + String(describing: round(100*finalTime)/100)
        let alertView = UIAlertController(title: "CONGRATULATIONS!!!",
                                          message: finalTimeMessage, preferredStyle: .alert)
        
        let returnToMenu = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            alertView.dismiss(animated: true, completion: nil)
        }
        
        alertView.addAction(returnToMenu)
        
        self.present(alertView, animated: true)
    }
    
    @objc func updateCounter() {
        time += 0.01
        timeStamp.text  = String(describing: round(100*time)/100)
    }
    
    
    @IBAction func swipeUp(_ sender: Any) {
        
        UIImageView.animate(withDuration: 1) {
            self.gamePiece.center.y -= screenHeight
        }
        // Check that the shape was a triangle. If the shape was a triangle, then generate a new shape, otherwise return the shape to the center.
        if self.shapeID == 0 {
            self.count = self.count + 1
            if self.count == limit {
                gameOver()
            }
            // Create a new shape
            self.shapeID = Int(arc4random_uniform(4))
        }
        self.scoreStamp.text = String(describing: self.count)
        self.shapeGenerator(newShapeID: self.shapeID)
    }
    
    @IBAction func swipeDown(_ sender: Any) {
        UIImageView.animate(withDuration: 1) {
            self.gamePiece.frame.origin.y += screenHeight / 2
        }
        // Check that the shape was an X. If the shape was an X, then generate a new shape, otherwise return the shape to the center.
        if self.shapeID == 3 {
            self.count = self.count + 1
            if self.count == limit {
                gameOver()
            }
            // Create a new shape
            self.shapeID = Int(arc4random_uniform(4))
        }
        self.scoreStamp.text = String(describing: self.count)
        self.shapeGenerator(newShapeID: self.shapeID)
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        UIImageView.animate(withDuration: 1) {
            self.gamePiece.frame.origin.x -= screenWidth / 2
        }
        // Check that the shape was a square. If the shape was a square, then generate a new shape, otherwise return the shape to the center.
        if self.shapeID == 1 {
            self.count = self.count + 1
            if self.count == limit {
                gameOver()
            }
            // Create a new shape
            self.shapeID = Int(arc4random_uniform(4))
        }
        self.scoreStamp.text = String(describing: self.count)
        self.shapeGenerator(newShapeID: self.shapeID)
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        UIImageView.animate(withDuration: 1) {
            self.gamePiece.frame.origin.x += screenWidth / 2
        }
        // Check that the shape was a circle. If the shape was a circle, then generate a new shape, otherwise return the shape to the center.
        if self.shapeID == 2 {
            self.count = self.count + 1
            if self.count == limit {
                gameOver()
            }
            // Create a new shape
            self.shapeID = Int(arc4random_uniform(4))
        }
        self.scoreStamp.text = String(describing: self.count)
        self.shapeGenerator(newShapeID: self.shapeID)
    }
    
    @IBAction func submitScoreBtnClicked(_ sender: Any) {
        let user = Auth.auth().currentUser
        var emailName:String = ""
        //need to sign out cached current user
        
        if ((user) != nil) {
            emailName = (user?.email!)!
        }
        else{
            emailName = "Guest"
        }
        //let myScoreCard = scoreCard(score:Int(scoreNum.text!)!, uName:emailName)
        let myScore:Float = Float(finalTime)
        

        if(nicknameTxtField.text == ""){ //check for blank text field
            //label showing message
            DispatchQueue.main.async {
                self.submitStatusLbl.text = "Please enter a nickname"
            }
        }
        else if(emailName != "Guest" ){ //check to see if guest logged in
            
        fbRef.child("Highscores").child((user?.uid)!).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var myScoreCard = currentData.value as? [String : AnyObject]
                //,let uid = Auth.auth().currentUser?.uid
            {
                var scoreCount:Float = myScoreCard["User_Highscore"] as? Float ?? 9999.9
                let scoreCountString = myScoreCard["User_Highscore"] as? String
                if(scoreCountString == "N/A"){
                    scoreCount = myScore
                    self.fbRef.child("Leaderboard").child((user?.uid)!).setValue(["Nickname":self.nicknameTxtField.text as! String, "Fastest time":String(scoreCount)])
                    DispatchQueue.main.async {
                        self.submitStatusLbl.text = "Wow great job for your first time!"
                    }
                    
                }
                else if (myScore<scoreCount){
                    scoreCount = myScore
                    print(scoreCount)
                    //leaderboard code?
                //self.fbRef.child("Leaderboard").child((user?.uid)!).setValue(["Nickname":self.nicknameTxtField.text as! String, "Fastest time":String(scoreCount)])
                    DispatchQueue.main.async {
                    self.fbRef.child("Leaderboard").child((user?.uid)!).setValue(["Nickname":self.nicknameTxtField.text as! String, "Fastest time":String(scoreCount)])
                        self.submitStatusLbl.text = "New Highscore! Rock on!"

                    }
                    //self.submitStatusLbl.text = "New Highscore! Rock on!"

                } else {
                    //time per shape longer than user highscore
                    DispatchQueue.main.async {

                    self.submitStatusLbl.text = "Awww darn too slow"
                    }
                }
                
                myScoreCard["User_Highscore"] = scoreCount as AnyObject?
                myScoreCard["Nickname"] = self.nicknameTxtField.text as AnyObject? //if user decides to change username associated with their highscore
                
                // Set value and report transaction success
                currentData.value = myScoreCard
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        }
        else{ //guest logged in
            print("Guest scores are not saved")

        }
        
        //code below are attempts at coding a leaderboard
        //self.fbRef.child("Highscores/\(user?.uid)/the score").setValue(myScore)
        //fbRef.child("Highscores").child((user?.uid)!).updateChildValues(["the score":myScore])
        /*
        var currentScore:Int = 0
        let userID = Auth.auth().currentUser?.uid
        fbRef.child("Highscores").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
        let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            //let user = User(username: username)
        currentScore = value?["the score"] as! Int
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        if(myScore<currentScore){
            fbRef.child("Highscores").child((user?.uid)!).updateChildValues(["the score":myScore])

        }
        else{
            print("fail")
        }
        fbRef.child("Highscores").child((user?.uid)!).setValue(["the score": myScore])
*/
        //print(user?.uid)
       // fbRef.child("Highscores").child((user?.uid)!).setValue(["the score": myScore])

      



        //notes

        //need to get authenticated user's user name
        //but currently only have email and password
        //need to get user to supply a unique username
        
        // need to check if current score is user's highscore to check whether or not to update it
        // need to have only one highscore node per user
        
        //need to create table log view to display/query the highscores along with usernames
        //fbRef.child("Highscores").childByAutoId().setValue(myScoreCard.toAnyObject())
        
        
        //fbRef.updateChildValues(<#T##values: [AnyHashable : Any]##[AnyHashable : Any]#>)
        
        //fbRef.child("Highscores").childByAutoId().setValue(["the score":myScore,"name":emailName])
        

        //fbRef.child("Highscores").childByAutoId().setValue(myname:String = emailName, score:Int = (scoreNum.text!)!)
        //fbRef.child("Highscores").childByAutoId().updateChildValues(<#T##values: [AnyHashable : Any]##[AnyHashable : Any]#>)

//flatten data structure
    }
    func textFieldShouldReturn(_ textField: UITextField) ->
        Bool {
            // 'First Responder' is the same as 'input focus'.
            // We are removing input focus from the text field.
            self.nicknameTxtField.resignFirstResponder()
            return true
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This causes the keyboard to be dismissed.
        self.view.endEditing(true)
    }
}
