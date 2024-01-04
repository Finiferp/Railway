//
//  profileViewController.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 20/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class profileViewController: UIViewController {

    @IBOutlet var profileLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var fundsLabel: UILabel!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load() {
        let userId = self.defaults.integer(forKey: "userId")
        let token = self.defaults.string(forKey: "token")
        let username = self.defaults.string(forKey: "username")
        
        let url = "http://127.0.0.1:3000/player/\(userId)"
        AF.request(url, method: .get,encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let data = json["data"]
                    let funds = Int(data["funds"].stringValue)
                    self.usernameLabel.text = username
                    self.fundsLabel.text = "Funds : \(funds ?? 0) $"
                case .failure(let error):
                    print(error)
                }
            }
    }


}
