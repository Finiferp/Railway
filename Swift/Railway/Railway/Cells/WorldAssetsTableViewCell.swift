//
//  WorldAssetsTableViewCell.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 20/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class WorldAssetsTableViewCell: UITableViewCell {

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var goodsLabel: UILabel!
    @IBOutlet var ownerLabel: UILabel!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var buttonView: UIStackView!
    @IBOutlet var nameView: UIStackView!
    let defaults = UserDefaults.standard
    var assetId:Int = 0
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
    

      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
      }

    @IBAction func buyAsset(_ sender: Any) {
        let token = self.defaults.string(forKey: "token")
        let userId = self.defaults.integer(forKey: "userId")
        let parameters: [String: Any] = [
            "userId": userId,
            "assetId": self.assetId
        ]        
        let url = "http://127.0.0.1:3000/asset/buy"
        let dispatchGroup = DispatchGroup()
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    /*let alert = UIAlertController(title: "Something went wrong!", message: "Sucessflly bought the asset!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)*/
                    print("sucessfull")
                case .failure(let error):
                   /* let alert = UIAlertController(title: "Something went wrong!", message: "Couldnt buy the asset, try again later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)*/
                    print(error)
                }
            }
        
    }
}
