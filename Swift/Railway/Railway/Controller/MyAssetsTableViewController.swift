//
//  MyAssetsTableViewController.swift
//  Railway
//
//  Created by test on 20/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyAssetsTableViewController: UITableViewController {
    
    var myAssets: [JSON] = []
    var stations: [Int:Bool] = [:]
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load(){
        let userId = self.defaults.integer(forKey: "userId")
        let token = self.defaults.string(forKey: "token")
        let url = "http://127.0.0.1:3000/asset/player/\(userId)"
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let assetsData = json["data"]
                    for (i, asset ) in assetsData {
                        self.myAssets.append(asset)
                    }
                    print(self.myAssets)
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    func getAssetsStation(_ assetId: Int, completion: @escaping (JSON) -> Void) {
        let token = self.defaults.string(forKey: "token")
        let parameters: [String: Any] = [
            "assetId": assetId
        ]
        let url = "http://127.0.0.1:3000/asset/station"
        let dispatchGroup = DispatchGroup()
        var data: JSON = JSON.null
        dispatchGroup.enter()
        AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    data = json["data"]
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        dispatchGroup.notify(queue: .main) {
            completion(data)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAssets.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myAssetsCell", for: indexPath) as? MyAssetsTableViewCell
        else {
            return UITableViewCell()
        }
        let asset = myAssets[indexPath.row]
        
        cell.nameLabel.text = asset["name"].stringValue
        cell.typeLabel.text = asset["type"].stringValue
        cell.levelLabel.text = asset["level"].stringValue
        cell.populationLabel.text = asset["population"].stringValue
        
        let assetId = Int(asset["assetId"].stringValue)
        
        getAssetsStation(assetId!) { data in
            if(data != JSON.null) {
                //print(data)
                cell.stationLabel.text = "Station present!"
                cell.buttonView.isHidden = true
                cell.nameView.isHidden = false
            } else {
                cell.assetId = assetId!
                cell.nameView.isHidden = true
                cell.buttonView.isHidden = false
            }
        }
        
        return cell
    }
    
    

    
}
