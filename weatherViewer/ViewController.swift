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
    @IBOutlet var backgroundView: UIView!
    
    let apiKey = "e314c7e4533ae54e9740790e14b56ac3"
    var lat = 26.8205
    var lon = 30.8024
    // loading
    var activityIndicator: NVActivityIndicatorView!
    // user location
    let locationManager = CLLocationManager()
    let gradinetLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        backgroundView.layer.addSublayer(gradinetLayer)

        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        view.backgroundColor = UIColor(#colorLiteral(red: 0.2685144057, green: 0.4098663574, blue: 0.5113705851, alpha: 1))
        
        // use popup to check and get location
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        setbackgroundLayer()
//    }
    
    
//    func setbackgroundLayer() {
//        let firstColor = UIColor(red: 12.5/255.0, green: 23.6/255.0, blue: 246.0/255.0, alpha: 1.0).cgColor
//        let secondColor = UIColor(red: 39.7/255.0, green: 190.0/255.0, blue: 10.7/255.0, alpha: 1.0).cgColor
//        gradinetLayer.frame = view.bounds
//        gradinetLayer.colors = [firstColor, secondColor]
//
//    }
    
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
                
                self.locationLabel.text = jsonResponse["name"].stringValue
                self.conditionImageView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue))) ℃"
                
            }
        }
    }
}

