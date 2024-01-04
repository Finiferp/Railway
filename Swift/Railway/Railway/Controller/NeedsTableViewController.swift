//
//  NeedsTableViewController.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 21/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class NeedsTableViewController: UITableViewController {

    var myNeeds: [JSON] = []
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load(){
        let userId = self.defaults.integer(forKey: "userId")
        let token = self.defaults.string(forKey: "token")
        let url = "http://127.0.0.1:3000/player/needs"
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
                    let needsData = json["data"]
                    for (_, need ) in needsData {
                        self.myNeeds.append(need)
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
        return myNeeds.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myNeedsCell", for: indexPath) as? NeedsTableViewCell
        else {
            return UITableViewCell()
        }
        let needsJSON = myNeeds[indexPath.row]
        cell.nameLabel.text = needsJSON["asset_name"].stringValue
        cell.idLabel.text = needsJSON["asset_id"].stringValue
        if(needsJSON["needs"] != JSON.null){
            let needs = needsJSON["needs"]
            for (_, need ) in needs {
                 let needStackView = createNeedStackView(with: need)
                 cell.needsStack.addArrangedSubview(needStackView)
            }
        }
        print(needsJSON)
        return cell
    }
    
    func createNeedStackView(with need: JSON) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.backgroundColor = UIColor.lightGray

        let needNameLabel = UILabel()
        needNameLabel.text = "Good Name: \(need["good_name"].stringValue)"
        stackView.addArrangedSubview(needNameLabel)

        let consumptionLabel = UILabel()
        consumptionLabel.text = "Consumption: \(need["consumption"].stringValue)"
        stackView.addArrangedSubview(consumptionLabel)

        return stackView
    }

    
}
