//
//  RequestsCell.swift
//  StudentRides
//
//  Created by Chiraag Nadig on 6/11/22.
//

import UIKit

class RequestsCell: UITableViewCell {
    
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var addLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
