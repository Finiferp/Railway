//
//  IndustriesTableViewController.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 21/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class IndustriesTableViewController: UITableViewController {
    
    var myIndustries: [JSON] = []
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load(){
        let userId = self.defaults.integer(forKey: "userId")
        let token = self.defaults.string(forKey: "token")
        let url = "http://127.0.0.1:3000/player/industries/"
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
                    let industriesData = json["data"]
                    for (_, industry ) in industriesData {
                        self.myIndustries.append(industry)
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
        return myIndustries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myIndustryCell", for: indexPath) as? IndustriesTableViewCell
        else {
            return UITableViewCell()
        }
        let industryJSON = myIndustries[indexPath.row]
        cell.assetName.text = industryJSON["asset_id"].stringValue
        if(industryJSON["industries"] != JSON.null){
            let industries = industryJSON["industries"]
            for (_, industry ) in industries {
                 let industryStackView = createIndustryStackView(with: industry)
                 cell.industriesStack.addArrangedSubview(industryStackView)
            }
        }
        cell.assetId = Int(industryJSON["asset_id"].stringValue)!
        
        return cell
    }
    
    func createIndustryStackView(with industry: JSON) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.backgroundColor = UIColor.lightGray

        let industryNameLabel = UILabel()
        industryNameLabel.text = "Industry Name: \(industry["industry_name"].stringValue)"
        stackView.addArrangedSubview(industryNameLabel)

        let industryTypeLabel = UILabel()
        industryTypeLabel.text = "Industry Type: \(industry["industry_type"].stringValue)"
        stackView.addArrangedSubview(industryTypeLabel)

        let producedGoodNameLabel = UILabel()
        producedGoodNameLabel.text = "Produced Good Name: \(industry["produced_good_name"].stringValue)"
        stackView.addArrangedSubview(producedGoodNameLabel)

        let warehouseCapacityLabel = UILabel()
        warehouseCapacityLabel.text = "Warehouse Capacity: \(industry["warehouse_capacity"].stringValue)"
        stackView.addArrangedSubview(warehouseCapacityLabel)

        return stackView
    }
    
    
}
