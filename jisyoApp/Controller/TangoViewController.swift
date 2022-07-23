//
//  TangoViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2021/11/13.
//

import UIKit
import Firebase
import FirebaseFirestore


class TangoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dataSets:[MyTangoModel] = []
    
    var myidString = String()
    var idString = String()
    var titleString = String()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("おはよう",idString)

        tableView.delegate = self
        tableView.dataSource = self
        
        titleLabel.text = titleString
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myloadData()
    }
    
    
    func myloadData(){
        
        if let user = Auth.auth().currentUser{
            
            Firestore.firestore().collection("users/\(user.uid)/todos").document(idString).collection("Tango").order(by: "postDate").addSnapshotListener { (snapShot,error) in
                self.dataSets = []
                if error != nil{
                    return
                }
                if let snapShotDoc = snapShot?.documents{
                    for doc in snapShotDoc{
                        let data = doc.data()
                        //これら全てに値が入っているのであれば
                        if let tango = data["title"] as? String,let setumei = data["syousai"] as? String,let postDate = data["postDate"] as? Double{
                            let mytangoModel = MyTangoModel(tango: tango, setumei: setumei, postDate: postDate, docID: doc.documentID)
                            self.dataSets.append(mytangoModel)
                        }
                    }
                    self.dataSets.reverse()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    
    
    
    
//    func loadData(){
//        db.collection("Jisyo").document(idString).collection("Tango").order(by: "postDate").addSnapshotListener { (snapShot,error) in
//            self.dataSets = []
//            if error != nil{
//                return
//            }
//            if let snapShotDoc = snapShot?.documents{
//                for doc in snapShotDoc{
//                    let data = doc.data()
//                    //これら全てに値が入っているのであれば
//                    if let userName = data["userName"] as? String,let tango = data["tango"] as? String,let setumei = data["setumei"] as? String,let postDate = data["postDate"] as? Double{
//                        let tangoModel = TangoModel(userName: userName, tango: tango, setumei: setumei, postDate: postDate)
//                        self.dataSets.append(tangoModel)
//                    }
//                }
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 470
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSets.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for:indexPath)
        
        
//        let userNameLabel = cell.contentView.viewWithTag(1) as! UILabel
//        userNameLabel.numberOfLines = 0
//        userNameLabel.text = self.dataSets[indexPath.row].userName
        
        
        let tangoLabel = cell.contentView.viewWithTag(2) as! UILabel
        tangoLabel.numberOfLines = 0
        tangoLabel.text = self.dataSets[indexPath.row].tango
        
        
        let setumeiLabel = cell.contentView.viewWithTag(3) as! UILabel
        setumeiLabel.numberOfLines = 0
        setumeiLabel.text = self.dataSets[indexPath.row].setumei
        
        return cell
        
    }
    
    
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TangoAddViewController
        vc.idString = idString
        vc.myidString = myidString
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

            Firestore.firestore().collection("users/\(user.uid)/todos").document(idString).collection("Tango").document(spot.docID).delete() { err in
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
