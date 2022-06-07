//
//  LoginViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2021/11/11.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
class LoginViewController: UIViewController {

    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerNameTextField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil {
            
            let storyboard: UIStoryboard = self.storyboard!
            let next = storyboard.instantiateViewController(withIdentifier: "tabVC")
            self.present(next, animated: true, completion: nil)
        } else {
        
            
        }
        
        
    }
    
    
    
    
    

    
    
    @IBAction func registerButton(_ sender: Any) {
        
        if let email = registerEmailTextField.text,
           let password = registerPasswordTextField.text,
           let name = registerNameTextField.text{
            
            Auth.auth().createUser(withEmail: email, password: password, completion: {(result, error) in
                
                if let user = result?.user{
                    
                    print("ユーザー作成完了 uid:" + user.uid)
                    
                    //firebaseのUserコレクションにdocumentID = ログインしたuidでデータを作成する
                    Firestore.firestore().collection("users").document(user.uid).setData(["name": name], completion: {error in
                        
                        if let error = error{
                            
                            print("Firestore 新規登録失敗" + error.localizedDescription)
                            let dialog = UIAlertController(title: "新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(dialog, animated: true, completion: nil)
                            
                        }else{
                            print("ユーザー作成完了 name:" + name)
                            //画面遷移
                            let storybord: UIStoryboard = self.storyboard!
                            let next = storybord.instantiateViewController(withIdentifier: "tabVC")
                            self.present(next, animated: true, completion: nil)
            
                        }
                        
                    })
                }else if let error = error{
                    print("Firebase Auth 新規登録失敗" + error.localizedDescription)
                    let dialog = UIAlertController(title: "新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
                
                
                
                
                
            })
                
                

            
        }
        
        
    }
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    @IBOutlet weak var textField: UITextField!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    func login(){
//        Auth.auth().signInAnonymously { (result,error) in
//            let user = result?.user
//            print(user)
//
//            UserDefaults.standard.set(self.textField.text, forKey: "userName")
//
//            //画面遷移
//            let viewVC = self.storyboard?.instantiateViewController(withIdentifier: "viewVC") as! ViewController
//            self.navigationController?.pushViewController(viewVC, animated: true)
//        }
//    }
//
//
//    @IBAction func done(_ sender: Any) {
//        login()
//    }
    

}
