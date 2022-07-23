//
//  ViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2021/11/11.
//

import UIKit
import Firebase
import FirebaseFirestore
import Foundation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UILabel!
    
    var userName = String()
    
    var dataSets:[MyJisyoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if UserDefaults.standard.object(forKey: "userName") != nil{
//            userName = UserDefaults.standard.object(forKey: "userName") as! String
//        }
//
//        textLabel.text = "　 ようこそ！\(userName)さん"
        
        
//        backView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        backView.layer.shadowColor = UIColor.black.cgColor
//        backView.layer.shadowOpacity = 0.6
//        backView.layer.shadowRadius = 4
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
        
        if let user = Auth.auth().currentUser{
            //ログインしているユーザー名の取得
            Firestore.firestore().collection("users").document(user.uid).getDocument(completion: {(snapShot,error) in
                
                if let snap = snapShot{
                    if let data = snap.data(){
                        self.textLabel.text = data["name"] as? String
                    }
                }else if let error = error{
                    print("ユーザー名取得失敗:" + error.localizedDescription)
                }
            })
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func loadData(){
        
        if let user = Auth.auth().currentUser{
            Firestore.firestore().collection("users/\(user.uid)/todos").order(by: "postDate").addSnapshotListener { (snapShot,error) in
                self.dataSets = []
                //エラーならプログラムを止める
                if error != nil{
                    return
                }
                //documentsが空でなかったら
                if let snapShotDoc = snapShot?.documents{
                    for doc in snapShotDoc{
                        //docのデータにアクセス
                        let data = doc.data()
                        //dataのanswerとuserNameが空でない場合
                        if let title = data["title"] as? String,let syousai = data["syousai"] as? String{
                            //JisyoModelに値を入れる
                            let myjisyoModel = MyJisyoModel(title: title, syousai: syousai, docID: doc.documentID)
                            self.dataSets.append(myjisyoModel)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
   
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 80
        
        return UITableView.automaticDimension
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSets.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        
        
        
        let Title = cell.contentView.viewWithTag(2) as! UILabel
        Title.numberOfLines = 0
        Title.text = self.dataSets[indexPath.row].title
        
        
        let Syousai = cell.contentView.viewWithTag(3) as! UILabel
        Syousai.numberOfLines = 0
        Syousai.text = self.dataSets[indexPath.row].syousai
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移
        let tangoVC = self.storyboard?.instantiateViewController(withIdentifier: "tangoVC") as! TangoViewController
        tangoVC.idString = dataSets[indexPath.row].docID
        tangoVC.titleString = dataSets[indexPath.row].title
        
        self.navigationController?.pushViewController(tangoVC, animated: true)
    }
    
    
    
    
    
    
    
    
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        //デリートボタンを追加
        if editingStyle == .delete {
            //選択されたCellのNSIndexPathを渡し、データをFirebase上から削除するためのメソッド
            self.delete(deleteIndexPath: indexPath)
            //TableView上から削除
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }

    }

    func delete(deleteIndexPath indexPath: IndexPath) {
        
        let spot = self.dataSets[indexPath.row]

        //データベースを削除
        if let user = Auth.auth().currentUser{

            Firestore.firestore().collection("users/\(user.uid)/todos").document(spot.docID).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }



        dataSets.remove(at: indexPath.row)
    }
    
    
    
    
    
             


        
             
}

