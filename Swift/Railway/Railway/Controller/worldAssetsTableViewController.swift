//
//  worldAssetsTableViewController.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 20/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class worldAssetsTableViewController: UITableViewController {
    var assets: [JSON] = []
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        load()
    }
    
    func load(){
        let idWorld = self.defaults.integer(forKey: "idWorld")
        let token = self.defaults.string(forKey: "token")
        let url = "http://127.0.0.1:3000/asset/world/\(idWorld)"
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
                        self.assets.append(asset)
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
    
    func getOwnerName(_ ownerId: Int, completion: @escaping (String) -> Void) {
        let token = self.defaults.string(forKey: "token")
        let userId = self.defaults.integer(forKey: "userId")
        let url = "http://127.0.0.1:3000/player/\(userId)"
        let dispatchGroup = DispatchGroup()
        var username = ""
        dispatchGroup.enter()
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let data = json["data"]
                    username = data["username"].stringValue
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        dispatchGroup.notify(queue: .main) {
            completion(username)
        }
    }


  /*  override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssetsCell", for: indexPath) as? WorldAssetsTableViewCell
        else {
            return UITableViewCell()
        }
        let asset = assets[indexPath.row]
        
        cell.nameLabel.text = asset["name"].stringValue
        cell.typeLabel.text = asset["type"].stringValue
        let position = asset["position"]
        let x = position["x"].stringValue
        let y = position["y"].stringValue
        cell.positionLabel.text = "X:\(x); Y:\(y)"
        cell.populationLabel.text = asset["population"].stringValue
        cell.levelLabel.text = asset["level"].stringValue
        let goods = asset["goods"]
        var goodsAsText = ""
        if goods == JSON.null {
            cell.goodsLabel.text=""
        } else {
            for (_, good ) in goods {
                goodsAsText += good["name"].stringValue+";"
            }
            cell.goodsLabel.text = goodsAsText
        }
        let owner = asset["idOwner_FK"]
       
        if owner != JSON.null {
            let ownerId = Int(asset["idOwner_FK"].stringValue)
            getOwnerName(ownerId!) { username in
                cell.ownerLabel.text = username
                cell.buttonView.isHidden = true
                cell.nameView.isHidden = false
            }
        } else {
            cell.assetId = Int(asset["idAsset_PK"].stringValue)!
            cell.nameView.isHidden = true
            cell.buttonView.isHidden = false
        }
        return cell
    }
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
