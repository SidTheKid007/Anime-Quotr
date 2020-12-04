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

struct WeatherResponse: Codable {
    var location: Location
    var current: Current
}

struct Location: Codable {
    var name: String
    var region: String
}

struct Current: Codable {
    var temp_f: Double
    var temp_c: Double
    var condition: Condition
    var wind_mph: Double
    var humidity: Int
    var feelslike_c: Double
    var feelslike_f: Double
}

struct Condition: Codable {
    var text: String
    var icon: String
}
