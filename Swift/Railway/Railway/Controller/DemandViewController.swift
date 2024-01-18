//
//  DemandViewController.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 11/01/2024.
//

import UIKit
import Alamofire
import SwiftyJSON


class DemandViewController: UIViewController {
    @IBOutlet var businessButton: UIButton!
    @IBOutlet var townButton: UIButton!
    @IBOutlet var goodButton: UIButton!
    @IBOutlet var amountlabel: UILabel!
   
    let defaults = UserDefaults.standard
    var businessesArr: [JSON] = []
    var townsArr: [JSON] = []
    var goodsArr:[JSON] = []

    var selectedBusiness:Int = -1
    var selectedTown:Int = -1
    var selectedGood:Int = -1
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        amountlabel.text = "\(Int(sender.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBusiness()
        loadTowns()
        loadGoods()
    }

    func loadBusiness(){
        let token = self.defaults.string(forKey: "token")
        let worldId = self.defaults.string(forKey: "idWorld")!
        let url = "http://127.0.0.1:3000/asset/world/\(worldId)"
        var dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let assets = json["data"]
                    for (_, asset) in assets {
                        let type = asset["type"].stringValue
                        if(type == "RURALBUSINESS"){
                            self.businessesArr.append(asset)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave();
            }
        dispatchGroup.notify(queue: .main) {
            self.buildBusiness()
        }
    }
    
    func loadTowns(){
        let token = self.defaults.string(forKey: "token")
        let userId = self.defaults.string(forKey: "userId")!
        let url = "http://127.0.0.1:3000/asset/player/\(userId)"
        var dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let assets = json["data"]
                    for (_, asset) in assets {
                        let type = asset["type"].stringValue
                        if(type == "TOWN"){
                            self.townsArr.append(asset)
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave();
            }
        dispatchGroup.notify(queue: .main) {
            self.buildTowns()
        }
    }
    
    func loadGoods(){
        let token = self.defaults.string(forKey: "token")
        let url = "http://127.0.0.1:3000/goods"
        var dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let goods = json["data"]
                    for (_, good) in goods {
                        self.goodsArr.append(good)
                    }
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave();
            }
        dispatchGroup.notify(queue: .main) {
            self.buildGoods()
        }
    }

    func buildBusiness(){
        var menuActions: [UIAction] = []
        for business in self.businessesArr {
           let name = business["name"].stringValue
            let id = Int(business["idAsset_PK"].stringValue)!
            let action = UIAction(title:name, image:nil){_ in
                self.selectedBusiness = id
            }
            menuActions.append(action)

            let menu = UIMenu(title: "Business name", children: menuActions)
            if #available(iOS 14.0, *) {
                self.businessButton.menu = menu
            }
        }
    }

    func buildTowns(){
        var menuActions: [UIAction] = []
        for town in self.townsArr {
            let name = town["name"].stringValue
            let id = Int(town["assetId"].stringValue)!
            let action = UIAction(title:name, image:nil){_ in
                self.selectedTown = id
            }
            menuActions.append(action)

            let menu = UIMenu(title: "Town name", children: menuActions)
            if #available(iOS 14.0, *) {
                townButton.menu = menu
            }
        }
    }

    func buildGoods(){
        var menuActions: [UIAction] = []
        for good in self.goodsArr {
            let name = good["name"].stringValue
            let id = Int(good["id"].stringValue)!
            let action = UIAction(title:name, image:nil){_ in
                self.selectedGood = id
            }
            menuActions.append(action)

            let menu = UIMenu(title: "Good name", children: menuActions)
            if #available(iOS 14.0, *) {
                goodButton.menu = menu
            }
        }
    }
    @IBAction func demandButton(_ sender: Any) {
        var railwaysArr:[JSON] = []
        let token = self.defaults.string(forKey: "token")
        let userId = self.defaults.string(forKey: "userId")!
        let url = "http://127.0.0.1:3000/player/railways"
        let parameters = [
            "userId": userId
        ] as [String : Any]
        var dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let railways = json["data"]
                    for(_, railway) in railways {
                        let railwaysJSON = railway["railways"]
                        railwaysArr.append(railwaysJSON)
                    }
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        dispatchGroup.notify(queue: .main) {
            var railwayId = -1
            for(railway) in railwaysArr {
                for(_, station) in railway {
                    let connectedStations = station["connected_stations"]
                    if(connectedStations.count == 2){
                        let station1Id = Int(connectedStations[0]["assetId"].stringValue)!
                        let station2Id = Int(connectedStations[1]["assetId"].stringValue)!
                        if ((station1Id == self.selectedTown || station1Id == self.selectedBusiness) &&
                            (station2Id == self.selectedTown || station2Id == self.selectedBusiness)) {
                            railwayId = Int(station["railway_id"].stringValue)!
                        }
                    }
                }
            }
            if(railwayId != -1){
                
                
            }
        }
    }
    
    
        func create(_ railwayId:Int){
        //print(selectedBusiness, selectedTown,selectedGood,Int(amountlabel.text!)!)
            let token = self.defaults.string(forKey: "token")
            let url = "http://127.0.0.1:3000/train/demand"
            let parameters = [
                "assetFromId": selectedBusiness,
                "assetToId": selectedTown,
                "railwayId": railwayId,
                "goodId": selectedGood,
                "amount": Int(amountlabel.text!)!
            ] as [String : Any]
            var dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
                .validate(statusCode: 200..<300)
                .responseJSON{response in
                    switch response.result{
                    case .success(let value):
                        let json = JSON(value)
                        print("Sucess")
                    case .failure(let error):
                        print(error)
                    }
                    dispatchGroup.leave()
                }
    }
    
    
    
}
