//
//  ItemTableViewCell.swift
//  to do list
//
//  Created by Marwan Osama on 1/19/21.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(item: Item) {
        textLabel?.text = item.name
        textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor!, isFlat: true)
        tintColor = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor!, isFlat: true)
        accessoryType = item.isDone ? .checkmark : .none
        
        
    }
    
}
