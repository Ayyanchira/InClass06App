//
//  NewAccountViewController.swift
//  InClass06App
//
//  Created by Ayyanchira, Akshay Murari on 10/21/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
import Firebase
class NewAccountViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let username = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            confirmPasswordTextField.text! == passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                DispatchQueue.main.async{
                    if error != nil{
                        
                        let alert = UIAlertController(title: "Failed", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        
                        alert.addAction(okAction)
                        self.show(alert, sender: nil)
                    }
                    else{
                        print("user created with username \(user.debugDescription)")
                        //store uuid in userdefaults
                        UserDefaults.standard.set(user?.uid, forKey: "uuid")
                        let rootreference = Database.database().reference()
                        let userReference = rootreference.child("Users").child(user!.uid)
                        let user = [
                            "name":username,
                            "email":email
                        ]
                        userReference.setValue(user)
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                }
            })
        }
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
