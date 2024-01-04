//
//  loginViewController.swift
//  Railway
//
//  Created by test on 19/12/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

class loginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func login(_ sender: Any) {
        let url = "http://127.0.0.1:3000/login"
        let parameters: [String: Any] = [
            "username": username.text!,
            "input_password": password.text!
        ]
        
     
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json"]))
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let message = json["message"].stringValue
                    let user = json["user"]
                    let username = user["username"].stringValue
                    let idWorld = Int(user["idWorld"].stringValue)
                    let token = json["token"].stringValue
                    let userId = Int(user["id"].stringValue)
                    self.defaults.setValue(username, forKey: "username")
                    self.defaults.set(idWorld, forKey: "idWorld")
                    self.defaults.setValue(token, forKey: "token")
                    self.defaults.setValue(userId, forKey: "userId")
                    
                    
                    self.performSegue(withIdentifier: "toMainSegue", sender: (Any).self)
                case .failure(let error):
                    let alert = UIAlertController(title: "Something went wrong!", message: "The user credentials are wrong!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
    }
    

}
