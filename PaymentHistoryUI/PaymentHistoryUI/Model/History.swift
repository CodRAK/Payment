//
//  History.swift
//  PaymentHistoryUI
//
//  Created by aseem kapoor on 08/05/21.
//

import Foundation

struct History: Decodable {
    var userId: Int
    var transactionId: Int
    var transactionDate: Date
    var amount: Double
    var status: Int
    var type: Int
    var direction: Int
}
