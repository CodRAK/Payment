//
//  TransactionCell.swift
//  PaymentHistoryUI
//
//  Created by aseem kapoor on 08/05/21.
//

import UIKit

class TransactionCell: UICollectionViewCell {
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var tranactionId: UILabel!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var actionView: UIView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    func configure(amount: Double, status: TransactionStatus, direction: TransactionDirection, transaction: Int) {
        self.amount.text = String(amount)
        self.status.text = direction == .Sent ? "You paid" : "You received"
        tranactionId.text = String(transaction)
        
        if direction == .Sent {
            if status == .Pending {
                self.status.text = "You requested"
            }
        } else {
            if status == .Pending {
                self.status.text = "Request received"
            }
        }
        
        if self.status.text == "You requested" || self.status.text == "Request received" {
            labelView.isHidden = true
            actionView.isHidden = false
        } else {
            labelView.isHidden = false
            actionView.isHidden = true
        }
        
        checkImageView.image = actionView.isHidden ? UIImage(systemName: "checkmark") : UIImage(systemName: "link")
        
    }
}
