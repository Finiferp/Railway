//
//  MyTrainsTableViewController.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 22/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyTrainsTableViewController: UITableViewController {

    var myTrains: [JSON] = []
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load(){
        let userId = self.defaults.integer(forKey: "userId")
        let token = self.defaults.string(forKey: "token")
        let url = "http://127.0.0.1:3000/player/trains"
        let parameters: [String: Any] = [
            "userId": userId
        ]
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let trainData = json["data"]
                    for (_, train ) in trainData {
                        self.myTrains.append(train)
                    }
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTrains.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myTrainsCell", for: indexPath) as? MyTrainsTableViewCell
        else {
            return UITableViewCell()
        }
        let trainJSON = myTrains[indexPath.row]
        cell.nameLabel.text = trainJSON["name"].stringValue
        cell.costLabel.text = trainJSON["cost"].stringValue
        cell.returningLabel.text = trainJSON["isReturning"].stringValue
        cell.staringIdLabel.text = trainJSON["idAsset_Starts_FK"].stringValue
        cell.destinationIdLabel.text = trainJSON["idAsset_Destines_FK"].stringValue
        cell.trainId = Int(trainJSON["id"].stringValue)!
        var goodsText = ""
        if(trainJSON["goodsTransported"] != JSON.null) {
            let goods = trainJSON["goodsTransported"]
            for(_, good) in goods {
                let idName = good["idname"].stringValue
                let quantity = good["amount"].stringValue
                let line = idName + " quantity:" + quantity + "\n"
                
                goodsText += line
            }
        }
        cell.goodLabel.text = goodsText
        return cell
    }
}
