//
//  TourokuViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2022/01/18.
//

import UIKit
import Firebase
import FirebaseFirestore

class TourokuViewController: UIViewController {
    
    
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    
    @IBAction func loginButton(_ sender: Any) {
        
        
        if let email = loginEmailTextField.text,
           let password = loginPasswordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password, completion: {(result, error) in
                
                if let user = result?.user{
                    print("ログイン完了 uid:" + user.uid)
                    //画面遷移
                    let storybord: UIStoryboard = self.storyboard!
                    let next = storybord.instantiateViewController(withIdentifier: "tabVC")
                    self.present(next, animated: true, completion: nil)
                    
                }else if let error = error{
                    
                    print("ログイン失敗" + error.localizedDescription)
                    let dialog = UIAlertController(title: "ログイン失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
                
                
                
            })
            
        }
        
        
    }
    
  

}
