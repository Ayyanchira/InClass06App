//
//  noteCustomTableViewCell.swift
//  InClass06App
//
//  Created by Ayyanchira, Akshay Murari on 10/21/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit

class NoteCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
    }
}
