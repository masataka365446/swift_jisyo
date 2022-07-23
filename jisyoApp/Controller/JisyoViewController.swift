//
//  JisyoViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2021/11/11.
//

import UIKit
import Firebase
import FirebaseFirestore
import EMAlertController


class JisyoViewController: UIViewController {
    
    var userName = String()
    
    let db1 = Firestore.firestore()
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーボードを表示
        self.textView.becomeFirstResponder()
        
//        if UserDefaults.standard.object(forKey: "userName") != nil{
//            userName = UserDefaults.standard.object(forKey: "userName") as! String
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = Auth.auth().currentUser{
            //ログインしているユーザー名の取得
            Firestore.firestore().collection("users").document(user.uid).getDocument(completion: { [self](snapShot,error) in
                
                if let snap = snapShot{
                    if let data = snap.data(){
                        userName = (data["name"] as? String)!
                    }
                }else if let error = error{
                    print("ユーザー名取得失敗:" + error.localizedDescription)
                }
            })
        }
    }
    
    
    
    
    
    
    
    
    
    @IBAction func send(_ sender: Any) {
        
        if let user = Auth.auth().currentUser{
            Firestore.firestore().collection("users/\(user.uid)/todos").document().setData(["title":textField.text as Any,"syousai":textView.text as Any, "postDate":Date().timeIntervalSince1970])
        }
        
        
//        db1.collection("Jisyo").document().setData(["title":textField.text as Any,"syousai":textView.text as Any,"userName":userName,"postDate":Date().timeIntervalSince1970])
        
        //テキストを空にする
        textField.text = ""
        textView.text = ""
        
        //アラート
//        let alert = EMAlertController(icon: UIImage(named: "check"), title: "辞書を作りました！", message: "オリジナルの辞書を完成させましょう。")
//                let doneAction = EMAlertAction(title: "OK", style: .normal)
//                alert.addAction(doneAction)
//        present(alert, animated: true, completion: nil)
        
        
//        let ViewController = self.storyboard?.instantiateViewController(withIdentifier: "viewVC") as! ViewController
//                ViewController.modalPresentationStyle = .fullScreen
//                self.present(ViewController, animated: true, completion: nil)
        
        

        //ボタンが押されたら戻る
        dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
    
    

}
