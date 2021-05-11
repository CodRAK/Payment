//
//  Utilities.swift
//  PaymentHistoryUI
//
//  Created by aseem kapoor on 08/05/21.
//

import Foundation

enum CellIds: Int {
    case sender = 1
    case receiver
    
    func getRawValue() -> String {
        var retVal = ""
        switch self {
        case .sender:
            retVal = "senderCell"
        default:
            retVal = "receiverCell"
        }
        return retVal
    }
}

enum TransactionStatus: Int {
    case Pending = 1, Confirmed, Expired, Reject, Cancel
}

enum TransactionDirection: Int {
    case Sent = 1, Received
}
