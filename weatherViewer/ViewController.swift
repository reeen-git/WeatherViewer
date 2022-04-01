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

    //SettingViews
    let dateLabel: UILabel = {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd  HH:mm"
        let dateStr = formatter.string(from: now as Date)
        
        let view = UILabel.init()
        view.text = "Date: \(dateStr)"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect(x:100, y: 50, width: 200, height: 200))
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
            dateLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
            conditionLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
            temperatureLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
            locationLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
           
            NSLayoutConstraint.activate([
                conditionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
                conditionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
                dateLabel.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 30),
                dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
                temperatureLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30),
                temperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
                locationLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 30),
                locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
            ])
        }
    }
    
    func dayColorGradient() {
        gradient.frame = view.bounds
        // グラデーション開始色
        let topColor = UIColor(#colorLiteral(red: 0.05936148018, green: 0.5335171223, blue: 0.9719132781, alpha: 1)).cgColor
        // グラデーション終了色
        let bottopColor = UIColor(#colorLiteral(red: 0.831840694, green: 0.9067348838, blue: 1, alpha: 1)).cgColor
        let gradientColors: [CGColor] = [topColor, bottopColor]
        gradient.colors = gradientColors
        // ビューにグラデーションレイヤーを追加
        self.view.layer.insertSublayer(gradient,at:0)
    }
    
    func nightColorGradient() {
        gradient.frame = view.bounds
        // グラデーション開始色
        let topColor = UIColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).cgColor
        // グラデーション終了色
        let bottopColor = UIColor(#colorLiteral(red: 0.2263697088, green: 0.3509760201, blue: 0.4403417706, alpha: 1)).cgColor
        let bottopColor2 = UIColor(#colorLiteral(red: 0.8932324052, green: 0.898203671, blue: 0.8938085437, alpha: 1)).cgColor

        let gradientColors: [CGColor] = [topColor, bottopColor, bottopColor2]
        gradient.colors = gradientColors
        // ビューにグラデーションレイヤーを追加
        self.view.layer.insertSublayer(gradient,at:0)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        print(location)
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude

        AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=e314c7e4533ae54e9740790e14b56ac3&units=metric").responseJSON { response in
            if let responseStr = response.value {

                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue

                switch iconName {
                case "01d":
                    self.imageView.image = UIImage(systemName: "sun.max")
                    self.conditionLabel.text = "Condition: 快晴"
                    self.dayColorGradient()
                case "01n":
                    self.imageView.image = UIImage(systemName: "moon")
                    self.conditionLabel.text = "Condition: 快晴"
                    self.nightColorGradient()
                case "02d":
                    self.imageView.image = UIImage(systemName: "cloud.sun")
                    self.conditionLabel.text = "Condition: 晴れ / (0-24%)"
                    self.dayColorGradient()
                case "02n":
                    self.imageView.image = UIImage(systemName: "cloud.moon")
                    self.conditionLabel.text = "Condition: 晴れ / (0-24%)"
                    self.nightColorGradient()
                case "03d":
                    self.imageView.image = UIImage(systemName: "cloud")
                    self.conditionLabel.text = "Condition: 薄曇り / (25-50%)"
                    self.dayColorGradient()
                case "03n":
                    self.imageView.image = UIImage(systemName: "cloud.fill")
                    self.conditionLabel.text = "Condition: 薄曇り / (25-50%)"
                    self.nightColorGradient()
                case "04d":
                    self.imageView.image = UIImage(systemName: "smoke")
                    self.conditionLabel.text = "Condition: 曇り / (51-84%)"
                    self.dayColorGradient()
                case "04n":
                    self.imageView.image = UIImage(systemName: "smoke.fill")
                    self.conditionLabel.text = "Condition: 曇り / (51-84%)"
                    self.nightColorGradient()
                case "05d":
                    self.imageView.image = UIImage(systemName: "smoke")
                    self.conditionLabel.text = "Condition: 曇り / (85-100%)"
                    self.dayColorGradient()
                case "05n":
                    self.imageView.image = UIImage(systemName: "smoke.fill")
                    self.conditionLabel.text = "Condition: 曇り / (85-100%)"
                    self.nightColorGradient()
                case "09d":
                    self.imageView.image = UIImage(systemName: "cloud.rain")
                    self.conditionLabel.text = "Condition: 雨"
                    self.dayColorGradient()
                case "09n":
                    self.imageView.image = UIImage(systemName: "cloud.rain.fill")
                    self.conditionLabel.text = "Condition: 雨"
                    self.nightColorGradient()
                case "10d":
                    self.imageView.image = UIImage(systemName: "cloud.sun.rain")
                    self.conditionLabel.text = "Condition: 天気雨"
                    self.dayColorGradient()
                case "10n":
                    self.imageView.image = UIImage(systemName: "cloud.moon.rain")
                    self.conditionLabel.text = "Condition: 天気雨"
                    self.nightColorGradient()
                case "11d":
                    self.imageView.image = UIImage(systemName: "cloud.bolt.rain")
                    self.conditionLabel.text = "Condition: 雷雨"
                    self.dayColorGradient()
                case "11n":
                    self.imageView.image = UIImage(systemName: "cloud.moon.rain")
                    self.conditionLabel.text = "Condition: 雷雨"
                    self.nightColorGradient()
                case "13d":
                    self.imageView.image = UIImage(systemName: "snowflake")
                    self.conditionLabel.text = "Condition: 雪"
                    self.dayColorGradient()
                case "13n":
                    self.imageView.image = UIImage(systemName: "snowflake")
                    self.conditionLabel.text = "Condition: 雪"
                    self.nightColorGradient()
                case "50d":
                    self.imageView.image = UIImage(systemName: "tornado")
                    self.conditionLabel.text = "Condition: 嵐"
                    self.dayColorGradient()
                case "50n":
                    self.imageView.image = UIImage(systemName: "tornado")
                    self.conditionLabel.text = "Condition: 嵐"
                    self.nightColorGradient()
                default:
                    self.imageView.image = UIImage(systemName: "exclamationmark.circle")
                    self.conditionLabel.text = "Condition: その他(天気に警戒してください。）"
                    self.view.backgroundColor = .blue
                }
                self.locationLabel.text = jsonResponse["name"].stringValue
                //self.conditionLabel.text = jsonWeather["description"].string
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue))) ℃"
            }
        }
    }
}
