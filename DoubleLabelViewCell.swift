//
//  DoubleLabelViewCell.swift
//  Investing Simulator
//
//  Created by Bryan Lysander on 10/27/22.
//

import UIKit

class DoubleLabelViewCell: UITableViewCell {
    
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
