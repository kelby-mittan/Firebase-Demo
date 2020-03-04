//
//  ItemCell.swift
//  Firebase-Demo
//
//  Created by Kelby Mittan on 3/4/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet var itemImageView: DesignableImageView!
    
    @IBOutlet var itemNameLabel: UILabel!
    
    @IBOutlet var sellerNameLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var itemPriceLabel: UILabel!
    
    public func configureCell(for item: Item) {
        itemNameLabel.text = item.itemName
        sellerNameLabel.text = "@\(item.sellerName)"
        dateLabel.text = item.listedDate.description
        let price = String(format: "%.2f", item.price)
        itemPriceLabel.text = "$\(price)"
    }
    
    
}
