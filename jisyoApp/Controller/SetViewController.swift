//
//  SetViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2021/11/14.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class SetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
        
        
        // ①ログイン済みかどうかを確認
        if Auth.auth().currentUser != nil {
            // ②ログアウトの処理
            do {
                try Auth.auth().signOut()
                print("ログアウト完了")
                // ③成功した場合はログイン画面へ遷移
                let storyboard: UIStoryboard = self.storyboard!
                let next = storyboard.instantiateViewController(withIdentifier: "loginVC")
                
                
                
                
                self.present(next, animated: true, completion: nil)
            } catch let error as NSError {
                print("ログアウト失敗: " + error.localizedDescription)
                // ②が失敗した場合
                let dialog = UIAlertController(title: "ログアウト失敗", message: error.localizedDescription, preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(dialog, animated: true, completion: nil)
            }
        }
        
        
        
        
        
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let error as NSError {
//            print("エラー",error)
//        }
        
        //ボタンが押されたら戻る
//        dismiss(animated: true, completion: nil)
        
        
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
