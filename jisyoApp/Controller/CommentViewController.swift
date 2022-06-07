//
//  CommentViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2022/01/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class CommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var idString = String()
    var commentIdString = String()
    
    var userName = String()
    
    var dataSets:[CommentModel] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var screenSize = UIScreen.main.bounds.size

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tabBarController?.tabBar.isHidden = true
        
        tableView.estimatedRowHeight = 5
        tableView.rowHeight = UITableView.automaticDimension
        

        // Do any additional setup after loading the view.
        
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        
        
        
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
//    @objc func keyboardWillShow(_ notification:NSNotification){
//
//        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
//
//        inputTextField.frame.origin.y = screenSize.height - keyboardHeight - inputTextField.frame.height
//
//        addButton.frame.origin.y = screenSize.height - keyboardHeight - addButton.frame.height
//
//
//     }
//
//
//
//
//
//     @objc func keyboardWillHide(_ notification:NSNotification){
//
//         // 0.5秒止める
////         Thread.sleep(forTimeInterval: 0.5)
//
//         inputTextField.frame.origin.y = screenSize.height - inputTextField.frame.height
//
//         addButton.frame.origin.y = screenSize.height - addButton.frame.height
//
//
//
//         guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
//
//            UIView.animate(withDuration: duration) {
//
//                let transform = CGAffineTransform(translationX: 0, y: 0)
//                self.view.transform = transform
//
//            }
//
//
//         }
    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        
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
    
    
    func loadData(){
            
        Firestore.firestore().collection("Jisyo").document(idString).collection("Tango").document(commentIdString).collection("Comment").order(by: "postDate").addSnapshotListener { (snapShot,error) in
            self.dataSets = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    //これら全てに値が入っているのであれば
                    if let userName = data["userName"] as? String,let comment = data["comment"] as? String,let postDate = data["postDate"] as? Double{
                        let tangoModel = CommentModel(userName: userName, comment: comment, postDate: postDate, docID: doc.documentID)
                        self.dataSets.append(tangoModel)
                    }
                }
                self.dataSets.reverse()
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight = 50
        
        return UITableView.automaticDimension
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSets.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell",for:indexPath)
        
        
//        let userName = cell.contentView.viewWithTag(1) as! UILabel
//        userName.numberOfLines = 0
//        userName.text = self.dataSets[indexPath.row].userName
        
        let userNameLabel = cell.contentView.viewWithTag(1) as! UILabel
        userNameLabel.numberOfLines = 0
        userNameLabel.text = ("ユーザー: \(self.dataSets[indexPath.row].userName)")
        
        
        
        let tangoLabel = cell.contentView.viewWithTag(2) as! UILabel
        tangoLabel.numberOfLines = 0
        tangoLabel.text = self.dataSets[indexPath.row].comment
        
        

        
        
        
        return cell
        
        
    }
    
    
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CommentAddViewController
        vc.idString = idString
        vc.commentIdString = commentIdString
    }
        

        
    


}
