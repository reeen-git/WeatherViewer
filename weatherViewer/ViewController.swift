//
//  ViewController.swift
//  weatherViewer
//
//  Created by 高橋蓮 on 2022/03/12.
//
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let apiKey = "e314c7e4533ae54e9740790e14b56ac3"
    var lat = 26.8205
    var lon = 30.8024
    // loading
    var activityIndicator: NVActivityIndicatorView!
    // user location
    let locationManager = CLLocationManager()
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(
            x: (view.frame.width-indicatorSize)/2,
            y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        
        activityIndicator = NVActivityIndicatorView(
            frame: indicatorFrame,
            type: .lineScale, color: UIColor.white,
            padding: 20.0)
        
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
                
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd  HH:mm"
        let dateStr = formatter.string(from: now as Date)
        self.dayLabel.text = dateStr
        
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
        let topColor = UIColor(#colorLiteral(red: 0.03905873373, green: 0.1720667481, blue: 0.3135736883, alpha: 1)).cgColor
        // グラデーション終了色
        let bottopColor = UIColor(#colorLiteral(red: 0.6376335025, green: 0.5615429282, blue: 0.02414633147, alpha: 1)).cgColor
        let gradientColors: [CGColor] = [topColor, bottopColor]
        gradient.colors = gradientColors
        // ビューにグラデーションレイヤーを追加
        self.view.layer.insertSublayer(gradient,at:0)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        print(location)
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
        AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON { response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.value {
                
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                switch iconName {
                case "01d":
                    self.conditionImageView.image = UIImage(systemName: "sun.max")
                    self.conditionLabel.text = "快晴"
                    self.dayColorGradient()
                case "01n":
                    self.conditionImageView.image = UIImage(systemName: "moon")
                    self.conditionLabel.text = "快晴"
                    self.nightColorGradient()
                case "02d":
                    self.conditionImageView.image = UIImage(systemName: "cloud.sun")
                    self.conditionLabel.text = "晴れ / (0-24%)"
                    self.dayColorGradient()
                case "02n":
                    self.conditionImageView.image = UIImage(systemName: "cloud.moon")
                    self.conditionLabel.text = "晴れ / (0-24%)"
                    self.nightColorGradient()
                case "03d":
                    self.conditionImageView.image = UIImage(systemName: "cloud")
                    self.conditionLabel.text = "薄曇り / (25-50%)"
                    self.dayColorGradient()
                case "03n":
                    self.conditionImageView.image = UIImage(systemName: "cloud.fill")
                    self.conditionLabel.text = "薄曇り / (25-50%)"
                    self.nightColorGradient()
                case "04d":
                    self.conditionImageView.image = UIImage(systemName: "smoke")
                    self.conditionLabel.text = "曇り / (51-84%)"
                    self.dayColorGradient()
                case "04n":
                    self.conditionImageView.image = UIImage(systemName: "smoke.fill")
                    self.conditionLabel.text = "曇り / (51-84%)"
                    self.nightColorGradient()
                case "05d":
                    self.conditionImageView.image = UIImage(systemName: "smoke")
                    self.conditionLabel.text = "曇り / (85-100%)"
                    self.dayColorGradient()
                case "05n":
                    self.conditionImageView.image = UIImage(systemName: "smoke.fill")
                    self.conditionLabel.text = "曇り / (85-100%)"
                    self.nightColorGradient()
                case "09d":
                    self.conditionImageView.image = UIImage(systemName: "cloud.rain")
                    self.conditionLabel.text = "雨"
                    self.dayColorGradient()
                case "09n":
                    self.conditionImageView.image = UIImage(systemName: "cloud.rain.fill")
                    self.conditionLabel.text = "雨"
                    self.nightColorGradient()
                case "10d":
                    self.conditionImageView.image = UIImage(systemName: "cloud.sun.rain")
                    self.conditionLabel.text = "天気雨"
                    self.dayColorGradient()
                case "10n":
                    self.conditionImageView.image = UIImage(systemName: "cloud.moon.rain")
                    self.conditionLabel.text = "天気雨"
                    self.nightColorGradient()
                case "11d":
                    self.conditionImageView.image = UIImage(systemName: "cloud.bolt.rain")
                    self.conditionLabel.text = "雷雨"
                    self.dayColorGradient()
                case "11n":
                    self.conditionImageView.image = UIImage(systemName: "cloud.moon.rain")
                    self.conditionLabel.text = "雷雨"
                    self.nightColorGradient()
                case "13d":
                    self.conditionImageView.image = UIImage(systemName: "snowflake")
                    self.conditionLabel.text = "雪"
                    self.dayColorGradient()
                case "13n":
                    self.conditionImageView.image = UIImage(systemName: "snowflake")
                    self.conditionLabel.text = "雪"
                    self.nightColorGradient()
                case "50d":
                    self.conditionImageView.image = UIImage(systemName: "tornado")
                    self.conditionLabel.text = "嵐"
                    self.dayColorGradient()
                case "50n":
                    self.conditionImageView.image = UIImage(systemName: "tornado")
                    self.conditionLabel.text = "嵐"
                    self.nightColorGradient()
                default:
                    self.conditionImageView.image = UIImage(systemName: "exclamationmark.circle")
                    self.conditionLabel.text = "その他(天気に警戒してください。）"
                    self.view.backgroundColor = .blue
                }
                self.conditionImageView.tintColor = .white
                self.locationLabel.text = jsonResponse["name"].stringValue
//                self.conditionLabel.text = jsonWeather["description"].string
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue))) ℃"
                
            }
        }
    }
    
}

