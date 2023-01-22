//
//  TableViewCell.swift
//  Realm-UsefulConnections
//
//  Created by Raman Kozar on 10/01/2023.
//

import UIKit
import RealmSwift

class TableViewCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var emailCell: UILabel!
    @IBOutlet weak var descriptionCell: UILabel!
    @IBOutlet weak var ratingCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func insertDataIntoCell(dataInfo: ConnectionsModel) {
    
        emailCell.text = dataInfo.userEmail
        descriptionCell.text = dataInfo.userDescription
        ratingCell.text = dataInfo.userRating
        
    }

}
