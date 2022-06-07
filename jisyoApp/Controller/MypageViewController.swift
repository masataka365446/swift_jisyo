//
//  MypageViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2022/01/17.
//

import UIKit
import Firebase
import FirebaseFirestore

class MypageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSets:[JisyoModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        
    }
    
    
    func loadData(){
        
        if let user = Auth.auth().currentUser{
            Firestore.firestore().collection("Jisyo").order(by: "postDate").addSnapshotListener { (snapShot,error) in
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
                        if let title = data["title"] as? String,let syousai = data["syousai"] as? String,let userName = data["userName"] as? String{
                            //JisyoModelに値を入れる
                            let jisyoModel = JisyoModel(title: title, syousai: syousai, userName: userName, docID: doc.documentID)
                            self.dataSets.append(jisyoModel)
                        }
                    }
                    self.dataSets.reverse()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSets.count
    }

    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        
        let UserName = cell.contentView.viewWithTag(1) as! UILabel
        UserName.numberOfLines = 0
        UserName.text = self.dataSets[indexPath.row].userName
        
        
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
        let mytangoVC = self.storyboard?.instantiateViewController(withIdentifier: "mytangoVC") as! MyTangoViewController
        mytangoVC.idString = dataSets[indexPath.row].docID
        mytangoVC.titleString = dataSets[indexPath.row].title
        
        self.navigationController?.pushViewController(mytangoVC, animated: true)
    }
    
    
    

}
