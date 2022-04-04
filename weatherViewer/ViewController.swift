//
//  ViewController.swift
//  weatherViewer
//
//  Created by 高橋蓮 on 2022/03/12.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    //MARK: -Setting Views
    let dateLabel: UILabel = {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd  HH:mm"
        let dateStr = formatter.string(from: now as Date)
        
        let view = UILabel.init()
        view.text = "Date:  \(dateStr)"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect(x:100, y: 80, width: 200, height: 200))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.tintColor = .white
        return imageView
    }()

    let conditionLabel: UILabel = {
        let label = UILabel.init()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel.init()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let windSpeedLabel: UILabel = {
        let label = UILabel.init()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel.init()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel.init()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // user location
    let locationManager = CLLocationManager()
    let gradient = CAGradientLayer()
    var lat = 26.8205
    var lon = 30.8024
    
//MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            view.addSubview(dateLabel)
            view.addSubview(imageView)
            view.addSubview(conditionLabel)
            view.addSubview(temperatureLabel)
            view.addSubview(locationLabel)
            view.addSubview(windSpeedLabel)
            view.addSubview(humidityLabel)
            
            dateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28.0, weight: .medium)
            conditionLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28.0, weight: .medium)
            temperatureLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28.0, weight: .medium)
            locationLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28.0, weight: .medium)
            windSpeedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28.0, weight: .medium)
            humidityLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28.0, weight: .medium)

            NSLayoutConstraint.activate([
                conditionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 80),
                conditionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
                dateLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 40),
                dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
                temperatureLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 40),
                temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
                humidityLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 40),
                humidityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
                locationLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 40),
                locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
                windSpeedLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 40),
                windSpeedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            ])
        }
    }
    
    //MARK: -Setting Backgrounds
    func dayColorGradient() {
        gradient.frame = view.bounds
        let topColor = UIColor(#colorLiteral(red: 0.05936148018, green: 0.5335171223, blue: 0.9719132781, alpha: 1)).cgColor
        let bottopColor = UIColor(#colorLiteral(red: 0.831840694, green: 0.9067348838, blue: 1, alpha: 1)).cgColor
        let gradientColors: [CGColor] = [topColor, bottopColor]
        gradient.colors = gradientColors
        self.view.layer.insertSublayer(gradient,at:0)
    }
    
    func nightColorGradient() {
        gradient.frame = view.bounds
        let topColor = UIColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).cgColor
        let bottopColor = UIColor(#colorLiteral(red: 0.4114098549, green: 0.4468902946, blue: 0.4945960641, alpha: 1)).cgColor
        let gradientColors: [CGColor] = [topColor, bottopColor]
        gradient.colors = gradientColors
        self.view.layer.insertSublayer(gradient,at:0)
        
        dateLabel.textColor = .systemGray6
        locationLabel.textColor = .systemGray6
        temperatureLabel.textColor = .systemGray6
        conditionLabel.textColor = .systemGray6
    }
    
//MARK: -Get info & set value
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
        AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&lang=ja&appid=e314c7e4533ae54e9740790e14b56ac3&units=metric").response { response in
            if let responseStr = response.value {

                let jsonResponse = JSON(responseStr!)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let wind = jsonResponse["wind"]
                let iconName = jsonWeather["icon"].stringValue

                switch iconName {
                case "01d":
                    self.imageView.image = UIImage(systemName: "sun.max")
                    self.dayColorGradient()
                case "01n":
                    self.imageView.image = UIImage(systemName: "moon")
                    self.nightColorGradient()
                case "02d":
                    self.imageView.image = UIImage(systemName: "cloud.sun")
                    self.dayColorGradient()
                case "02n":
                    self.imageView.image = UIImage(systemName: "cloud.moon")
                    self.nightColorGradient()
                case "03d":
                    self.imageView.image = UIImage(systemName: "cloud")
                    self.dayColorGradient()
                case "03n":
                    self.imageView.image = UIImage(systemName: "cloud.moon.fill")
                    self.nightColorGradient()
                case "04d":
                    self.imageView.image = UIImage(systemName: "smoke")
                    self.dayColorGradient()
                case "04n":
                    self.imageView.image = UIImage(systemName: "smoke.fill")
                    self.nightColorGradient()
                case "09d":
                    self.imageView.image = UIImage(systemName: "cloud.drizzle")
                    self.dayColorGradient()
                case "09n":
                    self.imageView.image = UIImage(systemName: "cloud.drizzle.fill")
                    self.nightColorGradient()
                case "10d":
                    self.imageView.image = UIImage(systemName: "cloud.heavyrain")
                    self.dayColorGradient()
                case "10n":
                    self.imageView.image = UIImage(systemName: "cloud.heavyrain.fill")
                    self.nightColorGradient()
                case "11d":
                    self.imageView.image = UIImage(systemName: "cloud.bolt")
                    self.dayColorGradient()
                case "11n":
                    self.imageView.image = UIImage(systemName: "cloud.bolt.fill")
                    self.nightColorGradient()
                case "13d":
                    self.imageView.image = UIImage(systemName: "snowflake")
                    self.dayColorGradient()
                case "13n":
                    self.imageView.image = UIImage(systemName: "snowflake")
                    self.nightColorGradient()
                case "50d":
                    self.imageView.image = UIImage(systemName: "cloud.fog")
                    self.dayColorGradient()
                case "50n":
                    self.imageView.image = UIImage(systemName: "cloud.fog.fill")
                    self.nightColorGradient()
                default:
                    self.imageView.image = UIImage(systemName: "exclamationmark.circle")
                    self.conditionLabel.text = "天気: その他(天気に警戒してください。）"
                    self.view.backgroundColor = .blue
                }
                self.locationLabel.text = "現在地:  \(jsonResponse["name"].stringValue)"
                self.conditionLabel.text = "天気:  \(jsonWeather["description"].stringValue)"
                self.windSpeedLabel.text = "風速:  \(wind["speed"].stringValue) / sec"
                self.temperatureLabel.text = "温度:  \(Int(round(jsonTemp["temp"].doubleValue)))度"
                self.humidityLabel.text = "湿度:  \(jsonTemp["humidity"].stringValue) %"
            }
        }
    }
}
