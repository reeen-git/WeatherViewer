//
//  ViewController.swift
//  weatherViewer
//
//  Created by 高橋蓮 on 2022/03/12.
//


import UIKit
import Alamofire
import CoreLocation
import NVActivityIndicatorView
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var WeatherImage: UIImageView!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var templabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    let gradientLayer = CAGradientLayer()
    let apikey = "e314c7e4533ae54e9740790e14b56ac3"
    var lat = 11.34553
    var lon = 10.3344
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        view.layer.addSublayer(gradientLayer)
        let indicateSize: CGFloat = 70
        let indicateFrame = CGRect(x: (view.frame.width-indicateSize) / 2, y: (view.frame.height-indicateSize) / 2, width: indicateSize, height: indicateSize)
        activityIndicator = NVActivityIndicatorView(frame: indicateFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        view.addSubview(activityIndicator)
        locationManager.requestWhenInUseAuthorization()
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        blueGragiantBockGround()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        AF.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appaid=\(apikey)&units=metric").responseJSON { response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
            }
        }
    }
    
    func blueGragiantBockGround() {
        let topColor = UIColor(red: 95.0/255.0, green: 100.0/255.0, blue: 0.5, alpha: 1.0).cgColor
        let ButtonColor = UIColor(red: 20.0/255.0, green: 114.0/255.0, blue: 211.1/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, ButtonColor]
    }
}

//https://www.youtube.com/watch?v=WHRntPeAOo4
