//
//  LoginController.swift
//  Gchat
//
//  Created by Ahmed Ghareeb on 2019-04-12.
//  Copyright © 2019 Ahmed Ghareeb. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

  
    let inputsContainerView : UIView = {
        let  view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton : UIButton = {
        let button = UIButton()
        button.backgroundColor  = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints  = false
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    func handelLogin(){
        guard let email = emailTextField.text, let pass = passwordTextField.text
            else{
                print("form is not valid")
                return
        }
        Firebase.Auth.auth().signIn(withEmail: email, password: pass, completion: {
            (user, error) in
            if error != nil{
                print(error)
                return
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    @objc func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handelLogin()
        }else{
            handleRegister()
        }
        
    }
    
    @objc func handleRegister(){
     
       guard let email = emailTextField.text, let pass = passwordTextField.text, let name = nameTextField.text
        else{
            print("form is not valid")
            return
        }
        
        Firebase.Auth.auth().createUser(withEmail: email, password: pass) { (user , error) in
            if error != nil{
                print(error)
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
        //successfully authinticated
             var ref: DatabaseReference!
             ref = Database.database().reference(fromURL: "https://gchat-aa142.firebaseio.com/")
            
            let usersRef = ref.child("users").child(uid)
            let values = ["name": name, "email": email ]
            usersRef.updateChildValues(values){
                (err, ref) in
                if err != nil{
                    print(err)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let nameSeperator : UIView = {
        let seperator = UIView()
        seperator.backgroundColor = UIColor(r: 220, g: 220 , b: 220)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        return seperator
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let emailSeperator : UIView = {
        let seperator = UIView()
        seperator.backgroundColor = UIColor(r: 220, g: 220 , b: 220)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        return seperator
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let loginRegisterSegmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterChange(){
        //change button title
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        // change containerView size
        inputsContainerHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        //change height of nameText
        nameTextFieldHeightAncor?.isActive = false
        nameTextFieldHeightAncor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAncor?.isActive = true
        
        //change height of emailText
        emailTextFieldHeightAncor?.isActive = false
        emailTextFieldHeightAncor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAncor?.isActive = true
        
        //change height of password
        passTextFieldHeightAncor?.isActive = false
        passTextFieldHeightAncor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passTextFieldHeightAncor?.isActive = true
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor  = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(passwordTextField)
        
        initialize()
    }
    
    var inputsContainerHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAncor: NSLayoutConstraint?
    var emailTextFieldHeightAncor: NSLayoutConstraint?
    var passTextFieldHeightAncor: NSLayoutConstraint?
    
    func initialize(){

        //x , y , width , height , constrains
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -24).isActive = true
        inputsContainerHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerHeightAnchor?.isActive = true
        setupLoginRegisterButton()
        setupNameTextFields()
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginRegisterSegementedControl()
    }
    
    func setupLoginRegisterButton(){
        
        //loginRegisterButton constraints
        
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginRegisterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        
    }
    
    func setupNameTextFields(){
        // name text field constraints
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        nameTextFieldHeightAncor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        
        nameTextFieldHeightAncor?.isActive = true
        
        //name seperator constrains
        inputsContainerView.addSubview(nameSeperator)
        nameSeperator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor)
        nameSeperator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperator.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func setupEmailTextField(){
        // email text field constraints
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAncor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
            emailTextFieldHeightAncor?.isActive = true
        
        //email seperator constrains
        inputsContainerView.addSubview(emailSeperator)
        emailSeperator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor)
        emailSeperator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperator.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupPasswordTextField(){
        // password text field constraints
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
       passTextFieldHeightAncor =  passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passTextFieldHeightAncor?.isActive = true
    }
    
    func setupLoginRegisterSegementedControl(){
       
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    
}

extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

