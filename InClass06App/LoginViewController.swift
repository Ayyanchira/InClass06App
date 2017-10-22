//
//  LoginViewController.swift
//  InClass06App
//
//  Created by Ayyanchira, Akshay Murari on 10/21/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser != nil{
            performSegue(withIdentifier: "notebooksview", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //check if uuid exists in userdefaults and navigate or stay accordingly
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTextfield.text,
            let password = passwordTextfield.text{
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil{
                    
                }
                else{
                    let uuid = user?.uid
                    UserDefaults.standard.set(uuid, forKey: "uuid")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "notebooksview", sender: nil)
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
