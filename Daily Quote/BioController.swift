//
//  BioController.swift
//  Daily Quote
//
//  Created by Siddhesvar Kannan on 8/3/20.
//  Copyright © 2020 Siddhesvar Kannan. All rights reserved.
//

import UIKit

class BioController: UIViewController {

    @IBOutlet weak var authorText: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorBio: UILabel!
    
    var author = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorText.text = author
        let newAuthor = author.replacingOccurrences(of: " ", with: "%20")
        loadQuote(topic: newAuthor)
    }
    
    
    func loadQuote(topic: String) {
        let stringUrl = "https://api.duckduckgo.com/?q=" + topic + "&format=json"
        guard let url = URL(string: stringUrl) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Biography.self, from: data) {
                    DispatchQueue.main.async {
                        self.authorBio.text = decodedResponse.AbstractText
                        self.setImage(from: decodedResponse.Image ?? "https://miro.medium.com/max/978/1*pUEZd8z__1p-7ICIO1NZFA.png")
                    }
                    return
                }
            }
            print("Fetch Failed: \(error?.localizedDescription ?? "Unknown Error")")
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
    
    struct Biography: Codable {
        var AbstractText: String?
        var Image: String?
    }
 
}

