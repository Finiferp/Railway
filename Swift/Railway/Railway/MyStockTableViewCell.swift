//
//  MyStockTableViewCell.swift
//  Railway
//
//  Created by Daniel Do Canto Batista on 21/12/2023.
//

import UIKit

class MyStockTableViewCell: UITableViewCell {

    @IBOutlet var stockView: UIStackView!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
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


}
