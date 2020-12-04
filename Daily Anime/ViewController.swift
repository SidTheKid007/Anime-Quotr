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
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorImage.layer.cornerRadius = 15.0
        authorImage.clipsToBounds = true
        authorImage.layer.borderWidth = 1.5
        
        /*
        let calendar = Calendar.current
        let year = String(calendar.component(.year, from: today))
        let month = String(calendar.component(.month, from: today))
        let day = String(calendar.component(.day, from: today))
        dateText.text = month + "/" + day + "/" + year
        */
        let today = Date()
        let startDateString = "2020-09-06 00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let startDate = dateFormatter.date(from: startDateString)!
        let dateDiff = String(daysBetween(start:startDate, end:today)%93)
        
        let pushStartDateString = "2020-09-05 9:00"
        let pushStartDate = dateFormatter.date(from: pushStartDateString)!
        let pushDateDiff = String(daysBetween(start:pushStartDate, end:today)%93)
        
        if (defaults.object(forKey: "index") == nil) {
            registerLocal()
            loadQuote(index: pushDateDiff, type:"push")
            loadQuote(index: dateDiff, type:"default")
        } else if (String(describing: defaults.object(forKey: "index")) != dateDiff) {
            loadQuote(index: pushDateDiff, type:"push")
            loadQuote(index: dateDiff, type:"default")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondController = segue.destination as! BioController
        secondController.author = self.author
        secondController.biography = self.biography
    }
    
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    
    func loadQuote(index: String, type: String) {
        guard let url = URL(string: "https://senpai-hold-me.herokuapp.com/api/anime/" + index) else {
            //print("Invalid URL")
            loadDefaults()
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(QuoteResponse.self, from: data) {
                    DispatchQueue.main.async {
                        if (type == "default") {
                            self.storeQuoteData(author: decodedResponse.Author, summary: decodedResponse.Summary, image: decodedResponse.Image, quote: decodedResponse.Quote, index: index)
                        }
                        if (type == "push") {
                            self.scheduleLocal(pushAuthor: decodedResponse.Author)
                        }
                    }
                    return
                }
            }
            print("Fetch Failed: \(error?.localizedDescription ?? "Unknown Error")")
            self.loadDefaults()
        }.resume()
    }
    
    
    func storeQuoteData(author: String, summary: String, image: String, quote: String, index:String) {
        self.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
        self.biography = summary.replacingOccurrences(of: "_", with: "", options: NSString.CompareOptions.literal, range:nil).replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        //print(summary)
        self.setImage(url: image)
        self.quoteText.text = quote.trimmingCharacters(in: .whitespacesAndNewlines)
        self.authorText.text = author.trimmingCharacters(in: .whitespacesAndNewlines)
        
        defaults.set(index, forKey: "index")
        //defaults.set(author, forKey: "author")
        //defaults.set(summary, forKey: "summary")
        //defaults.set(image, forKey: "image")
        //defaults.set(quote, forKey: "quote")
    }
    
    
    func setImage(url: String) {
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
    
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yes")
            } else {
                print("No")
            }
        }
    }
    
    
    @objc func scheduleLocal(pushAuthor: String) {
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        let special_sauce = ["(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧", "(づ｡◕‿‿◕｡)づ", "v(=∩_∩=)ﾌ", "♨(⋆‿⋆)♨", "ᕙ(⇀‸↼‶)ᕗ", "( ͡° ͜ʖ ͡°)"]

        let content = UNMutableNotificationContent()
        content.title = "Good Morning!"
        content.body = "Today's special quote is from " + pushAuthor + ". \n " + special_sauce.randomElement()!
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
 
}

