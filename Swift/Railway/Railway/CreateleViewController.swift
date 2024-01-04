//
//  CreateleViewController.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 22/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class CreateleViewController: UIViewController {
    @IBAction func stations(_ sender: Any) {
    }
    
    @IBAction func railways(_ sender: Any) {
    }
    
    @IBAction func returnWithValue(_ sender: Any) {
    }
    var railways: [Any] = []
    var connectedStationNames: [Any] = []
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load(){
        let userId = self.defaults.integer(forKey: "userId")
        let token = self.defaults.string(forKey: "token")
        let url = "http://127.0.0.1:3000/player/railways"
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
                        self.railways.append(train)
                    }
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
    }
    
    
}
