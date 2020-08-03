//
//  ViewController.swift
//  Daily Quote
//
//  Created by Siddhesvar Kannan on 8/2/20.
//  Copyright © 2020 Siddhesvar Kannan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var quoteText: UILabel!
    @IBOutlet weak var authorText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the date
        let date = Date()
        let calendar = Calendar.current
        let year = String(calendar.component(.year, from: date))
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        dateText.text = month + "/" + day + "/" + year
        
        //set the quote and author
        loadQuote()
        
    }
    
    
    func loadQuote() {
        guard let url = URL(string: "https://quotes.rest/qod?language=en") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Root.self, from: data) {
                    DispatchQueue.main.async {
                        let jsonQuote = decodedResponse.contents.quotes[0].quote
                        let jsonAuthor = decodedResponse.contents.quotes[0].author
                        self.quoteText.text = jsonQuote
                        self.authorText.text = jsonAuthor
                    }
                    return
                }
            }
            print("Fetch Failed: \(error?.localizedDescription ?? "Unknown Error")")
        }.resume()
        
    }
    
    struct Root : Decodable {
        private enum CodingKeys : String, CodingKey { case contents = "contents" }
        let contents : contents
    }
    
    struct contents : Decodable {
        private enum CodingKeys : String, CodingKey { case quotes = "quotes" }
        let quotes : [Quote]
    }
    
    struct Quote: Codable {
        var quote: String
        var author: String
    }
 
}

