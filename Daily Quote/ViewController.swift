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
    var biography = ""
    var image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the date
        let today = Date()
        let calendar = Calendar.current
        let year = String(calendar.component(.year, from: today))
        let month = String(calendar.component(.month, from: today))
        let day = String(calendar.component(.day, from: today))
        dateText.text = month + "/" + day + "/" + year
        
        let startDateString = "2020-08-02"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: startDateString)!
        let dateDiff = String(daysBetween(start:startDate, end:today))
        
        if (author == "") {
            loadQuote(index: dateDiff)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondController = segue.destination as! BioController
        secondController.author = self.author
        secondController.biography = self.biography
        secondController.image = self.image
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func loadQuote(index: String) {
        guard let url = URL(string: "https://senpai-hold-me.herokuapp.com/api/quote/" + index) else {
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
                        let jsonBiography = decodedResponse.Summary
                        let jsonImage = decodedResponse.Image
                        self.author = jsonAuthor
                        self.biography = jsonBiography
                        self.image = jsonImage
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
        var Summary: String
        var Image: String
    }
 
}

