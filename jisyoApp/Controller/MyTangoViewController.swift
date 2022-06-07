//
//  MyTangoViewController.swift
//  jisyoApp
//
//  Created by 福原雅隆 on 2022/01/17.
//

import UIKit
import Firebase
import FirebaseFirestore

class MyTangoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    
    
    
    var dataSets:[TangoModel] = []
    
    
    var idString = String()
    var commentIdString = String()
    var titleString = String()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        titleTextLabel.text = titleString

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    
    
    func loadData(){
            
        Firestore.firestore().collection("Jisyo").document(idString).collection("Tango").order(by: "postDate").addSnapshotListener { (snapShot,error) in
            self.dataSets = []
            if error != nil{
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc{
                    let data = doc.data()
                    //これら全てに値が入っているのであれば
                    if let userName = data["userName"] as? String,let tango = data["tango"] as? String,let setumei = data["setumei"] as? String,let postDate = data["postDate"] as? Double{
                        let tangoModel = TangoModel(userName: userName, tango: tango, setumei: setumei, postDate: postDate, docID: doc.documentID)
                        self.dataSets.append(tangoModel)
                    }
                }
                self.dataSets.reverse()
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 470
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSets.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for:indexPath)
        
        
        let userName = cell.contentView.viewWithTag(1) as! UILabel
        userName.numberOfLines = 0
        userName.text = self.dataSets[indexPath.row].userName
        
        
        let tangoLabel = cell.contentView.viewWithTag(2) as! UILabel
        tangoLabel.numberOfLines = 0
        tangoLabel.text = self.dataSets[indexPath.row].tango
        
        
        let setumeiLabel = cell.contentView.viewWithTag(3) as! UILabel
        setumeiLabel.numberOfLines = 0
        setumeiLabel.text = self.dataSets[indexPath.row].setumei
        
        return cell
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ShareTangoViewController
        vc.idString = idString
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移
        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! CommentViewController
        commentVC.commentIdString = dataSets[indexPath.row].docID
        commentVC.idString = idString
        
        commentVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    

}
