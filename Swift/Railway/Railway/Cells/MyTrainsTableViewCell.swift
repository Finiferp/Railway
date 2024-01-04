//
//  MyTrainsTableViewCell.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 22/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyTrainsTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var returningLabel: UILabel!
    @IBOutlet var staringIdLabel: UILabel!
    @IBOutlet var destinationIdLabel: UILabel!
    @IBOutlet var willReturnLabel: UILabel!
    @IBOutlet var goodLabel: UILabel!
    let defaults = UserDefaults.standard
    var trainId = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
    }
    @IBAction func deleteTrain(_ sender: Any) {
        let userId = self.defaults.integer(forKey: "userId")
        let token = self.defaults.string(forKey: "token")
        let url = "http://127.0.0.1:3000/train/delete"
        let parameters: [String: Any] = [
            "userId": userId,
            "trainId":self.trainId
        ]
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        AF.request(url, method: .delete,parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    print("sucess")
                case .failure(let error):
                    print(error)
                }
                dispatchGroup.leave()
            }
    }
    
    
}
