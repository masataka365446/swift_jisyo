//
//  ShareJisyoViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2022/01/19.
//

import UIKit
import Firebase
import FirebaseFirestore

class ShareJisyoViewController: UIViewController {
    
    var userName = String()
    let db1 = Firestore.firestore()
    
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーボードを表示
        self.textField.becomeFirstResponder()

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
    
    
    
    
    
    
    
    
    
    @IBAction func addButton(_ sender: Any) {
        
        db1.collection("Jisyo").document().setData(["title":textField.text as Any,"syousai":textView.text as Any,"userName":userName,"postDate":Date().timeIntervalSince1970])
        
        //テキストを空にする
        textField.text = ""
        textView.text = ""
        //ボタンが押されたら戻る
        dismiss(animated: true, completion: nil)
        
    }

    

    
    
    
    
}
