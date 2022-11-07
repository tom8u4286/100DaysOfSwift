//
//  ViewController.swift
//  Project16
//
//  Created by 曲奕帆 on 2022/10/19.
//

import MapKit
import UIKit

class ViewController: UIViewController,
                      MKMapViewDelegate // 可以接收地圖相關事件
{
    // 地圖畫面實體
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 倫敦
        let london = Capital(
            title: "London",
            coordinate: CLLocationCoordinate2D(latitude: 51.50, longitude: -0.1275),
            info: "Home to the 2012 Summer Olympics.")
        
        // 奧斯陸
        let oslo = Capital(
            title: "Oslo",
            coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75),
            info: "Founded over a thousand years ago.")
        
        // 巴黎
        let paris = Capital(
            title:"Paris",
            coordinate: CLLocationCoordinate2D(latitude: 48.85, longitude: 2.35),
            info: "Often called the City of Light.")
        
        // 羅馬
        let rome = Capital(
            title:"Rome",
            coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5),
            info: "Has a whole country inside it.")
        
        // DC
        let washington = Capital(
            title: "Washington DC",
            coordinate: CLLocationCoordinate2D(latitude: 38.89, longitude: -77.03),
            info:  "Name after George himself.")
        
        // 在地圖中加入annotation
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }
    
    
    /** 每當iOS要顯示一個annotation時，會呼叫viewFor函式。
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 利用is判斷是否為Capital類別
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        /** iOS使用annotation的方式類似TableView的Cell，
         * 會以dequeueReusable的方式重複使用annotation。
         * 但如果發現annotation為空，則要重新產生一個新的AnnotationView。
         */
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
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
        return annotationView
    }
    
    // CallOut泡泡的元件在被點選時，會觸發此function(calloutAccessoryControlTapped)
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        /** 此處將傳入「被點選的物件」，如大頭針view<
         * 此view是一個MKAnnotationView物件，而我們設計的Capital也是一個遵循MKAnnotationView協定的物件，
         * 因此可以轉換。
         */
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let info = capital.info
        
        let ac = UIAlertController(title: placeName, message: info, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    
    

}

