//
//  ViewController.swift
//  Project16
//
//  Created by 曲奕帆 on 2022/10/19.
//

import MapKit
import UIKit

class ViewController: UIViewController,
                      MKMapViewDelegate {
    
    // 地圖畫面實體
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 倫敦
        let london = Capital(
            title: "London",
            coordinate: CLLocationCoordinate2D(latitude: 51.50, longitude: -0.1275),
            info: "Home to the 2012 Summer Olympics.",
            wiki: URL(string: "https://en.wikipedia.org/wiki/London")
        )
        
        // 奧斯陸
        let oslo = Capital(
            title: "Oslo",
            coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75),
            info: "Founded over a thousand years ago.",
            wiki: URL(string: "https://en.wikipedia.org/wiki/Oslo")
        )
        
        // 巴黎
        let paris = Capital(
            title: "Paris",
            coordinate: CLLocationCoordinate2D(latitude: 48.85, longitude: 2.35),
            info: "Often called the City of Light.",
            wiki: URL(string: "https://en.wikipedia.org/wiki/Paris")
        )
        
        // 羅馬
        let rome = Capital(
            title: "Rome",
            coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5),
            info: "Has a whole country inside it.",
            wiki: URL(string: "https://en.wikipedia.org/wiki/Rome")
        )
        
        // DC
        let washington = Capital(
            title: "Washington DC",
            coordinate: CLLocationCoordinate2D(latitude: 38.89, longitude: -77.03),
            info: "Name after George himself.",
            wiki: URL(string: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        )
        
        let taipei = Capital(
            title: "Taipei",
            coordinate: CLLocationCoordinate2D(latitude: 25.04, longitude:  121.52),
            info: "The largest city in Taiwan",
            wiki: URL(string: "https://en.wikipedia.org/wiki/Taipei")
        )
        
        // 在地圖中加入annotation
        mapView.addAnnotations([london, oslo, paris, rome, washington, taipei])
        
        // 右上方加入更改地圖樣式的按鈕
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showMapSheet))
        
    }
    
    // 更改地圖樣式
    @objc func showMapSheet(){
        let ac = UIAlertController(title: "更改地圖樣式", message: "testing message", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "standard", style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: "satellite", style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: "hybrid", style: .default, handler: changeMapType))
        ac.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(ac, animated: true)
    }
    
    // 更改地圖樣式
    func changeMapType(action: UIAlertAction){
        if let title = action.title {
            switch title {
            case "standard":
                mapView.mapType = .standard
            case "satellite":
                mapView.mapType = .satellite
            case "hybrid":
                mapView.mapType = .hybrid
            default:
                mapView.mapType = .standard
            }
        }
        
    }
    
    /** 每當iOS要顯示一個annotation時，會呼叫viewFor函式。
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        /** iOS使用annotation的方式類似TableView的Cell，
         * 會以dequeueReusable的方式重複使用annotation。
         * 但如果發現annotation為空，則要重新產生一個新的AnnotationView。
         */
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        /** 在地圖第一次要開始標記annotation上地圖時(如開啟地圖時)，
         * iOS會發現dequeueReusableAnnotationView會為空nil，
         * 此時我們就要新開一個MKPinAnnotationView物件實體。
         */
        if annotationView == nil {
            // PinAnnotationView是常見的紅色大頭針
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            // annotation是否可以點選彈出資訊泡泡(此泡泡稱為Callout)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            // 設定CallOut泡泡右側的按鈕
            annotationView?.rightCalloutAccessoryView = btn
            
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.pinTintColor = .green
        
        return annotationView
    }
    
    // CallOut泡泡的元件在被點選時，會觸發此function(calloutAccessoryControlTapped)
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        
        let vc = DetailViewController()
        vc.url = capital.wiki
        vc.placeName = capital.title
        navigationController?.pushViewController(vc, animated: true)
        
        
        
        
//        let placeName = capital.title
//        let info = capital.info
//
//        let ac = UIAlertController(title: placeName, message: info, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
    }

    
    

}

