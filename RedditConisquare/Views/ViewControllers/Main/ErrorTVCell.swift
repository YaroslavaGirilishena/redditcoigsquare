//
//  ErrorTVCell.swift
//  RedditConisquare
//
//  Created by Yaroslava Girilishena on 2018-02-03.
//  Copyright © 2018 YG. All rights reserved.
//

import UIKit

protocol ErrorTVCellDelegate: class {
    func errorCellShouldReloadData(_ cell: ErrorTVCell)
}

class ErrorTVCell: UITableViewCell {

    //-----------------
    // MARK: - Veriables
    //-----------------
    
    weak var delegate: ErrorTVCellDelegate?
    
    @IBOutlet weak var reloadBtn: UIButton!
    
    //-----------------
    // MARK: - Mathods
    //-----------------
    
    @IBAction func reloadContent(_ sender: Any) {
        delegate?.errorCellShouldReloadData(self)
    }
}
