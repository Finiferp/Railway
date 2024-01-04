//
//  IndustriesTableViewCell.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 21/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class IndustriesTableViewCell: UITableViewCell {
    
    @IBOutlet var typeButton: UIButton!
    @IBOutlet var assetName: UILabel!
    @IBOutlet var industriesStack: UIStackView!
    @IBOutlet var industryName: UITextField!
    @IBOutlet var industryType: UIButton!
    @IBOutlet var stackView: UIStackView!
    let defaults = UserDefaults.standard
    var assetId: Int = 0
    var currentType: String = "";
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func menuAction(_ sender: Any) {
        if let button = sender as? UICommand {
            currentType=button.title
            typeButton.setTitle(button.title, for: .normal)
        }
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
    
    @IBAction func buyIndustry(_ sender: Any) {
        let token = self.defaults.string(forKey: "token")
        let url = "http://127.0.0.1:3000/industry/create"
        let parameters: [String: Any] = [
            "idAsset": assetId,
            "name": industryName.text!,
            "type": currentType
        ]
        print(parameters)
        AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type":"application/json","Authorization": token!]))
            .validate(statusCode: 200..<300)
            .responseJSON{response in
                switch response.result{
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}
