//
//  MyRailwaysTableViewCell.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 21/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyRailwaysTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var stationsStackView: UIStackView!
    @IBOutlet var lengthLabel: UILabel!
    let defaults = UserDefaults.standard
    var station1Id = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
    }
  
    @IBAction func buy(_ sender: Any) {
        if let viewController = self.getViewController() {
             let alert = UIAlertController(title: "Enter a name for your destination station!", message: nil, preferredStyle: .alert)
             alert.addTextField { (textField) in
                 textField.placeholder = "Station name"
             }
             alert.addAction(UIAlertAction(title: "Create!", style: .default, handler: { [weak alert] (_) in
                 guard let textField = alert?.textFields?.first, let userInput = textField.text else { return }
                 let token = self.defaults.string(forKey: "token")
                 let name = textField.text!
                 let parameters: [String: Any] = [
                     "station_name": name,
                 ]
                 print(parameters)
                 let url = "http://127.0.0.1:3000/station/name"
                 let dispatchGroup = DispatchGroup()
                 
                 AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json","Authorization": token!]))
                     .validate(statusCode: 200..<300)
                     .responseJSON { response in
                         switch response.result {
                         case .success(let value):
                             let json = JSON(value)
                             let data = json["data"]
                             let station2Id = Int(data["id"].stringValue)!
                             let parameters: [String: Any] = [
                                 "station2Id": station2Id,
                                 "station1Id": self.station1Id
                             ]
                             print(parameters)
                             let url = "http://127.0.0.1:3000/railway/create"
                             AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json","Authorization": token!]))
                                 .validate(statusCode: 200..<300)
                                 .responseJSON { response in
                                     switch response.result {
                                     case .success(let value):
                                         let json = JSON(value)
                                         let data = json["data"]
                                         print(data)
                                     case .failure(let error):
                                         print(error)
                                     }
                                 }
                             
                         case .failure(let error):
                             print(error)
                         }
                     }
             }))

             viewController.present(alert, animated: true, completion: nil)
         }
    }
    
    func getViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


}
