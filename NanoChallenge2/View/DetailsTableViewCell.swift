//
//  DetailsTableViewCell.swift
//  NanoChallenge2
//
//  Created by aurelia  natasha on 19/09/19.
//  Copyright © 2019 aurelia  natasha. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dataTxtFields: UITextField!
    
//    lazy var dataTxtField: UITextField = {
//        let dataTxtField = UITextField()
//
//
//        return dataTxtField
//    }()
    
    lazy var dispEditData: UILabel = {
        let dispEditData = UILabel()
        dispEditData.translatesAutoresizingMaskIntoConstraints = false
        dispEditData.text = "data"
        
        return dispEditData
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        dataTxtFields.text = "\(data.weight!)"
        dataTxtFields.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dataTxtFields.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        addSubview(dispEditData)
        dispEditData.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dispEditData.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
