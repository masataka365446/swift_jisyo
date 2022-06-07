//
//  CommentAddViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2022/01/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class CommentAddViewController: UIViewController {
    
    var idString = String()
    var commentIdString = String()
    
    var userName = String()
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //キーボードを表示
        self.textView.becomeFirstResponder()
        

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

    
    
    
    
    //前の画面に戻る
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //コメント投稿ボタン
    @IBAction func commentAddButton(_ sender: Any) {
        
        
        //キーボードを閉じる
        textView.resignFirstResponder()


        if textView.text?.isEmpty == true{

            return

        }


        Firestore.firestore().collection("Jisyo").document(idString).collection("Tango").document(commentIdString).collection("Comment").document().setData(["comment":textView.text as Any,"userName":userName as Any, "postDate":Date().timeIntervalSince1970])


        //テキストを空にする
        textView.text = ""
        
        //ボタンが押されたら戻る
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    

}
