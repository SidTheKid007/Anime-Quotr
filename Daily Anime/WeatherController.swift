//
//  WeatherController.swift
//  AlderNews
//
//  Created by Siddhesvar Kannan on 8/23/20.
//  Copyright © 2020 Siddhesvar Kannan. All rights reserved.
//

import UIKit
import CoreLocation
import FLAnimatedImage

class WeatherController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherPic: FLAnimatedImageView!
    @IBOutlet weak var feelLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    
    
    var locFlag = false
    
    override func viewDidLoad() {
        self.locFlag = false
        super.viewDidLoad()
        getUserLocation()
        //loadWeather()
        weatherPic.layer.cornerRadius = 15.0
        weatherPic.clipsToBounds = true
        weatherPic.layer.borderWidth = 1.5
    }
    
    func getUserLocation() {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            let locale = Locale.current
            let state = (locale.regionCode ?? "Arcadia,CA")
            loadWeather(query: state)
            self.locFlag = true
            
            //replace with bottom to update weather (and add objc)
            //weatherTimer = Timer.scheduledTimer(timeInterval: 5*60, target: self, selector: #selector(loadWeather(query: state)), userInfo: nil, repeats: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            // add logic to ensure not too many hits
            if (!self.locFlag) {
                let query = latitude + "," + longitude
                loadWeather(query: query)
                //replace with bottom to update weather (and add objc)
                //weatherTimer = Timer.scheduledTimer(timeInterval: 5*60, target: self, selector: #selector(loadWeather(query: query)), userInfo: nil, repeats: true)
                self.locFlag = true
            }
        }
    }
    
    func loadWeather(query: String) {
        print(query)
        let weather_key = "bed55017d991460898d00621202408" //ProcessInfo.processInfo.environment["weather_key"]!
        guard let url = URL( string: "https://api.weatherapi.com/v1/current.json?key=" + weather_key + "&q=" + query  ) else {
            //print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.cityLabel.text = decodedResponse.location.name
                        self.climateLabel.text = decodedResponse.current.condition.text
                        self.tempLabel.text = String(Int(decodedResponse.current.temp_f)) + "°F"
                        self.setWeatherPic(temp: Int(decodedResponse.current.temp_f))
                        self.feelLabel.text = String(Int(decodedResponse.current.feelslike_f)) + "°F"
                        self.windLabel.text = String(decodedResponse.current.wind_mph) + " mph"
                        self.humidLabel.text = String(decodedResponse.current.humidity) + "%"
                    }
                    return
                }
            }
            print("Fetch Failed: \(error?.localizedDescription ?? "Unknown Error")")
        }.resume()
    }
    
    func setWeatherPic(temp: Int) {
        if temp < 65 {
            loadGif(urlString: "https://i.pinimg.com/originals/6b/da/0b/6bda0b4d70897bd22ff9a3bb5723e00b.gif")
        } else if (temp < 80) {
            loadGif(urlString: "https://data.whicdn.com/images/242601565/original.gif")
        } else if (temp < 90) {
            loadGif(urlString: "https://data.whicdn.com/images/252873293/original.gif")
        } else {
            loadGif(urlString: "https://media1.tenor.com/images/9e4bfac2041444b9291138b29319796f/tenor.gif?itemid=5315874")
        }
    }
    
    func loadGif(urlString: String) {
        let url = URL(string: urlString)!
        let imageData = try? Data(contentsOf: url)
        let imageData3 = FLAnimatedImage(animatedGIFData: imageData)
        weatherPic.animatedImage = imageData3
    }

}
