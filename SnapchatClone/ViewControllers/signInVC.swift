//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Furkan Deniz Albaylar on 13.09.2023.
//

import UIKit
import Firebase


class signInVC: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func makeAlert(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }


    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text ?? "", password: passwordText.text ?? "") { authData, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
    
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
        }
        
    }
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && usernameText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }
                else{
                    
                    let fireStore  = Firestore.firestore()
                    let userDict = ["email" : self.emailText.text!, "username" : self.usernameText.text!] as [String : Any]
                    fireStore.collection("UserInfo").addDocument(data: userDict)
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else {
            makeAlert(title: "Error", message: "Username or Password or email ? ")
            
        }
    }
}

