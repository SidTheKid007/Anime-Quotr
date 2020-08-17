//
//  QuoteResponse.swift
//  Daily Quote
//
//  Created by Siddhesvar Kannan on 8/16/20.
//  Copyright © 2020 Siddhesvar Kannan. All rights reserved.
//

import Foundation

struct QuoteResponse: Codable {
    var Quote: String
    var Author: String
    var Summary: String
    var Image: String
}
