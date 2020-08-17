//
//  ViewController.swift
//  Daily Quote
//
//  Created by Siddhesvar Kannan on 8/2/20.
//  Copyright © 2020 Siddhesvar Kannan. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    
    @IBOutlet weak var quoteText: UILabel!
    @IBOutlet weak var authorText: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    
    var author = ""
    var biography = ""
    var image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the date
        let today = Date()
        /*
         let calendar = Calendar.current
        let year = String(calendar.component(.year, from: today))
        let month = String(calendar.component(.month, from: today))
        let day = String(calendar.component(.day, from: today))
        dateText.text = month + "/" + day + "/" + year
        */
        
        authorImage.layer.cornerRadius = 15.0
        authorImage.clipsToBounds = true
        authorImage.layer.borderWidth = 1.5
        
        let startDateString = "2020-07-27"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: startDateString)!
        let dateDiff = String(daysBetween(start:startDate, end:today))
        
        if (author == "") {
            scheduleLocal()
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
            loadDefaults()
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(QuoteResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.author = decodedResponse.Author
                        self.biography = decodedResponse.Summary
                        self.image = decodedResponse.Image
                        self.setImage(from: decodedResponse.Image)
                        self.quoteText.text = decodedResponse.Quote
                        self.authorText.text = decodedResponse.Author
                    }
                    return
                }
            }
            print("Fetch Failed: \(error?.localizedDescription ?? "Unknown Error")")
            self.loadDefaults()
        }.resume()
        
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.authorImage.image = image
            }
        }
    }
    
    func loadDefaults() {
        self.author = "Mahatma Gandhi"
        self.biography = "Mohandas Karamchand Gandhi was an Indian lawyer, anti-colonial nationalist, and political ethicist, who employed nonviolent resistance to lead the successful campaign for India's independence from British Rule, and in turn inspired movements for civil rights and freedom across the world."
        DispatchQueue.main.async {
            self.quoteText.text = "In a gentle way, you can shake the world"
            self.authorText.text = "Mahatma Gandhi"
            self.authorImage.image = #imageLiteral(resourceName: "Mahatma-Gandhi-Insta")
        }
    }
    
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Good Morning!"
        content.body = "New Day. New Quote. Tap on me to find out more."
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 45
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
 
}

