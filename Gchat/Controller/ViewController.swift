//
//  ViewController.swift
//  Gchat
//
//  Created by Ahmed Ghareeb on 2019-04-12.
//  Copyright © 2019 Ahmed Ghareeb. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(handleLogout))
       // user is not loged in
        if Firebase.Auth.auth().currentUser == nil{
            //performSelector(#selector(handleLogout), with: nil)
            handleLogout()
        }
    }
    
    @objc func handleLogout(){
        do{
            try Firebase.Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
}

