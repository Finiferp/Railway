//
//  RegisterViewController.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 19/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {
    
    @IBOutlet var usernameLabel: UITextField!
    @IBOutlet var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func register(_ sender: Any) {
        let url = "http://127.0.0.1:3000/register"
        let parameters: [String: Any] = [
            "username": usernameLabel.text!,
            "input_password": passwordLabel.text!
        ]
     
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json"]))
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let message = json["message"].stringValue
                    let data = json["user"]
                    self.performSegue(withIdentifier: "toLoginSegue", sender: (Any).self)
                case .failure(let error):
                    let alert = UIAlertController(title: "Something went wrong!", message: "The user is already taken or one field is empty!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
    }
}

