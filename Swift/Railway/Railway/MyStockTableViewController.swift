//
//  MyStockTableViewController.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 21/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyStockTableViewController: UITableViewController {
    
    var myStocks: [JSON] = []
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load(){
        let userId = self.defaults.integer(forKey: "userId")
        let token = self.defaults.string(forKey: "token")
        let url = "http://127.0.0.1:3000/player/stockpile"
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
                    let stockData = json["data"]
                    for (_, need ) in stockData {
                        self.myStocks.append(need)
                    }
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
        print(self.myStocks)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStocks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myStockCell", for: indexPath) as? MyStockTableViewCell
        else {
            return UITableViewCell()
        }
        let stockJSON = myStocks[indexPath.row]
        
        cell.nameLabel.text = stockJSON["asset_name"].stringValue
        cell.idLabel.text = stockJSON["asset_id"].stringValue
        if(stockJSON["goods"] != JSON.null){
            let stocks = stockJSON["goods"]
            for (_, stock ) in stocks {
                let stockStackView = createNeedStackView(with: stock)
                cell.stockView.addArrangedSubview(stockStackView)
            }
        }
        return cell
    }
    
    func createNeedStackView(with stock: JSON) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.backgroundColor = UIColor.lightGray
        
        let stockNameLabel = UILabel()
        stockNameLabel.text = "Good Name: \(stock["good_name"].stringValue)"
        stackView.addArrangedSubview(stockNameLabel)
        
        let quantityLabel = UILabel()
        quantityLabel.text = "Quantity: \(stock["quantity"].stringValue)"
        stackView.addArrangedSubview(quantityLabel)
        
        return stackView
    }
}
