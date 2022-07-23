//
//  TangoAddViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2021/11/14.
//

import UIKit
import Firebase
import FirebaseFirestore

class TangoAddViewController: UIViewController {

    var idString = String()
    var myidString = String()
    
    var userName = String()
    
    let db1 = Firestore.firestore()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーボードを表示
        self.textView.becomeFirstResponder()
        
        print("こんにちは",idString)
        
        if UserDefaults.standard.object(forKey: "userName") != nil{
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        // Do any additional setup after loading the view.
    }
    
        
    @IBAction func sendAction(_ sender: Any) {
        
        
        if let user = Auth.auth().currentUser{
            Firestore.firestore().collection("users/\(user.uid)/todos").document(idString).collection("Tango").document().setData(["title":textField.text as Any,"syousai":textView.text as Any, "postDate":Date().timeIntervalSince1970])
        }
        
        
        
//        db1.collection("Jisyo").document(idString).collection("Tango").document().setData(["userName":userName as Any,"tango":textField.text! as Any,"setumei":textView.text! as Any,"postDate":Date().timeIntervalSince1970])
        
        //テキストを空にする
        textField.text = ""
        textView.text = ""
        
        //ボタンが押されたら戻る
        dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
