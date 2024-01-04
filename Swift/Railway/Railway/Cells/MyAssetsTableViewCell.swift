//
//  MyAssetsTableViewCell.swift
//  Railway
//
//  Created by test on 20/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyAssetsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet var nameView: UIStackView!
    @IBOutlet var buttonView: UIStackView!
    let defaults = UserDefaults.standard
    var assetId: Int = 0
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

    @IBAction func buyStation(_ sender: Any) {
        if let viewController = self.getViewController() {
             let alert = UIAlertController(title: "Enter a name for your station!", message: nil, preferredStyle: .alert)
             alert.addTextField { (textField) in
                 textField.placeholder = "Your name"
             }
             alert.addAction(UIAlertAction(title: "Create!", style: .default, handler: { [weak alert] (_) in
                 guard let textField = alert?.textFields?.first, let userInput = textField.text else { return }
                 let token = self.defaults.string(forKey: "token")
                 let name = textField.text!
                 let parameters: [String: Any] = [
                     "name": name,
                     "assetId": self.assetId
                 ]
                 let url = "http://127.0.0.1:3000/station/create"
                 let dispatchGroup = DispatchGroup()
                 
                 AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json","Authorization": token!]))
                     .validate(statusCode: 200..<300)
                     .responseJSON { response in
                         switch response.result {
                         case .success(let value):
                             print("sucessfull")
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
}
