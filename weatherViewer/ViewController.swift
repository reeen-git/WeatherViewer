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
        view.backgroundColor = UIColor(#colorLiteral(red: 0.2685144057, green: 0.4098663574, blue: 0.5113705851, alpha: 1))
        
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
                case "01n":
                    self.conditionImageView.image = UIImage(systemName: "moon")
                case "02d":
                    self.conditionImageView.image = UIImage(systemName: "cloud.sun")
                case "02n":
                    self.conditionImageView.image = UIImage(systemName: "cloud.moon")
                case "03d":
                    self.conditionImageView.image = UIImage(systemName: "cloud")
                case "03n":
                    self.conditionImageView.image = UIImage(systemName: "cloud.fill")
                case "04d":
                    self.conditionImageView.image = UIImage(systemName: "smoke")
                case "04n":
                    self.conditionImageView.image = UIImage(systemName: "smoke.fill")
                case "05d":
                    self.conditionImageView.image = UIImage(systemName: "smoke")
                case "05n":
                    self.conditionImageView.image = UIImage(systemName: "smoke.fill")
                case "06d":
                    self.conditionImageView.image = UIImage(systemName: "smoke")
                case "06n":
                    self.conditionImageView.image = UIImage(systemName: "smoke.fill")
                case "07d":
                    self.conditionImageView.image = UIImage(systemName: "smoke")
                case "07n":
                    self.conditionImageView.image = UIImage(systemName: "smoke.fill")
                case "08d":
                    self.conditionImageView.image = UIImage(systemName: "smoke")
                case "08n":
                    self.conditionImageView.image = UIImage(systemName: "smoke.fill")
                case "09d":
                    self.conditionImageView.image = UIImage(systemName: "cloud.rain")
                case "09n":
                    self.conditionImageView.image = UIImage(systemName: "cloud.rain.fill")
                case "10d":
                    self.conditionImageView.image = UIImage(systemName: "cloud.sun.rain")
                case "10n":
                    self.conditionImageView.image = UIImage(systemName: "cloud.moon.rain")
                case "11d":
                    self.conditionImageView.image = UIImage(systemName: "cloud.bolt.rain")
                case "11n":
                    self.conditionImageView.image = UIImage(systemName: "cloud.moon.rain")
                case "13d":
                    self.conditionImageView.image = UIImage(systemName: "snowflake")
                case "13n":
                    self.conditionImageView.image = UIImage(systemName: "snowflake")
                case "50d":
                    self.conditionImageView.image = UIImage(systemName: "tornado")
                case "50n":
                    self.conditionImageView.image = UIImage(systemName: "tornado")
                default:
                    self.conditionImageView.image = UIImage(systemName: "exclamationmark.circle")
                }
                self.conditionImageView.tintColor = .white
                self.locationLabel.text = jsonResponse["name"].stringValue
                self.conditionLabel.text = jsonWeather["description"].string
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue))) ℃"
                
            }
        }
    }
    
}

