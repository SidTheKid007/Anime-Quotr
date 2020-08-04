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
    var author = ""
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondController = segue.destination as! BioController
        secondController.author = self.author
    }
    
    func loadQuote() {
        guard let url = URL(string: "https://quot-r.herokuapp.com/api/quote/quote") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(QuoteResponse.self, from: data) {
                    DispatchQueue.main.async {
                        let jsonQuote = decodedResponse.Quote
                        let jsonAuthor = decodedResponse.Author
                        self.author = jsonAuthor
                        self.quoteText.text = jsonQuote
                        self.authorText.text = jsonAuthor
                    }
                    return
                }
            }
            print("Fetch Failed: \(error?.localizedDescription ?? "Unknown Error")")
        }.resume()
        
    }
    
    struct QuoteResponse: Codable {
        var Quote: String
        var Author: String
    }
 
}

