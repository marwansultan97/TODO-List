//
//  CategoryTableViewCell.swift
//  to do list
//
//  Created by Marwan Osama on 1/18/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(category: Category) {
        
        textLabel?.text = category.name
        backgroundColor = UIColor(hexString: category.color!)
        textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor!, isFlat: true)
        
        
        let image = UIImage(systemName: "arrow.right.circle")
        let accessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height))
        accessoryView.image = image
        accessoryView.tintColor = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor!, isFlat: true)
        self.accessoryView = accessoryView
    }
    
}
