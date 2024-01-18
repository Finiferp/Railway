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
    var railways: [JSON] = []
    var connectedStationsNames: [Any] = []
    @IBOutlet var statoinsButton: UIButton!
    @IBOutlet var railwayButton: UIButton!
    @IBOutlet var returnWithItem: UISwitch!
    @IBOutlet var trainsName: UITextField!
    var selectedRailwayId: String = ""
    var destinationName: String = ""
    var startName: String = ""
    var connectedStationNames: [String] = []
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRailways()
       
    }
    
    func loadRailways(){
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
                    let railwayData = json["data"]
                    for (_, railway ) in railwayData {
                        self.railways.append(railway)
                    }
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                self.buildRailways()
            }
    }
    
    func loadstations(){
        var menuActions: [UIAction] = []
        for stationName in connectedStationNames {
            let action = UIAction(title:stationName, image: nil){_ in
                self.destinationName = stationName
            }
            menuActions.append(action)
        }
        
        let menu = UIMenu(title: "Select a Station", children: menuActions)
        if #available(iOS 14.0, *) {
            railwayButton.menu = menu
        }
    }
    
    func buildRailways() {
        var menuActions: [UIAction] = []
        for railway in railways {
            self.connectedStationNames = []
            let stationName = railway["station_name"].stringValue
            let action = UIAction(title: stationName, image: nil) { _ in
                self.startName = stationName
                let stationId = railway["station_id"]
                let stations = railway["railways"]
                for (_, station) in stations {
                    self.selectedRailwayId = station["railway_id"].stringValue
                    let connectedStations = station["connected_stations"]
                    for(_, connectedStation) in connectedStations {
                        let destination = connectedStation["connected_station_id"]
                        if( destination != stationId){
                            let stationName = connectedStation["connected_station_name"].stringValue
                            if !self.connectedStationNames.contains(stationName) {
                                self.connectedStationNames.append(stationName)
                            }
                        }
                    }
                }
                self.loadstations()
            }

            menuActions.append(action)
        }
        

        let menu = UIMenu(title: "Select a Station", children: menuActions)
        if #available(iOS 14.0, *) {
            statoinsButton.menu = menu
        }

    }
    
    var station1Id:Int = -1
    var station2Id:Int = -1
    
    @IBAction func createTrain(_ sender: Any) {
        var token = self.defaults.string(forKey: "token")
        var url = "http://127.0.0.1:3000/station/name"
        var parameters: [String: Any] = [
            "station_name": startName
        ]
        var dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let station = json["data"]
                    self.station1Id = Int(station["idAsset_FK"].stringValue)!
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave();
            }
        dispatchGroup.notify(queue: .main) {
            self.getSecondStation()
        }
    }
    
    
    
    
    func getSecondStation(){
        var token = self.defaults.string(forKey: "token")
        var url = "http://127.0.0.1:3000/station/name"
        var parameters: [String: Any] = [
            "station_name": destinationName
        ]
        var dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let station = json["data"]
                    print(station)
                    self.station2Id = Int(station["idAsset_FK"].stringValue)!
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
        dispatchGroup.notify(queue: .main) {
            self.finalCreate()
        }
        
    }
    
    func finalCreate(){
        let willReturnWithGoods: Bool = self.returnWithItem.isOn
        var token = self.defaults.string(forKey: "token")
        let url = "http://127.0.0.1:3000/train/create"
        let parameters = [
            "name": trainsName.text!,
            "idRailway": Int(selectedRailwayId)!,
            "idAsset_Starts": station1Id,
            "idAsset_Destines": station2Id,
            "willReturnWithGoods": willReturnWithGoods
        ] as [String : Any]
        var dispatchGroup = DispatchGroup()
        print(parameters)
        dispatchGroup.enter()
       AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let station = json["data"]
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
    }
}
