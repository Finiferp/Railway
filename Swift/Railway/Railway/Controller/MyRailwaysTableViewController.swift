//
//  MyRailwaysTableViewController.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 21/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyRailwaysTableViewController: UITableViewController {

    var myRailways: [JSON] = []
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
                    let stockData = json["data"]
                    for (_, need ) in stockData {
                        self.myRailways.append(need)
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
        return myRailways.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myRailwaysCell", for: indexPath) as? MyRailwaysTableViewCell
        else {
            return UITableViewCell()
        }
        let railwayJSON = myRailways[indexPath.row]
        let railwaysJSON = railwayJSON["railways"]
        cell.nameLabel.text = railwayJSON["station_name"].stringValue
        cell.lengthLabel.text = railwaysJSON["distance"].stringValue
        cell.station1Id = railwayJSON["station_id"].stringValue
        for (_, railway ) in railwaysJSON {
            if(railway["connected_stations"] != JSON.null){
                let stations = railway["connected_stations"]
                for (_, station ) in stations {
                    let stationStackView = createStationStackView(with: station)
                    cell.stationsStackView.addArrangedSubview(stationStackView)
                }
            }
        }
        return cell
    }
    
    func createStationStackView(with station: JSON) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.backgroundColor = UIColor.lightGray
        
        let stationNameLabel = UILabel()
        stationNameLabel.text = "Connects Station: \(station["connected_station_name"].stringValue)"
        stackView.addArrangedSubview(stationNameLabel)
        
        return stackView
    }
}
