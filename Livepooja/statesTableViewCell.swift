//
//  statesTableViewCell.swift
//  
//
//  Created by Harish Singh on 07/02/23.
//

import UIKit

class statesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statelabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
