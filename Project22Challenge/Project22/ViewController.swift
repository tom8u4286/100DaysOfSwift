//
//  ViewController.swift
//  Project22
//
//  Created by 曲奕帆 on 2022/10/21.
//

import CoreLocation
import UIKit

class ViewController: UIViewController,
                    CLLocationManagerDelegate{

    var penguin: UIImageView!
    
    var locationManager: CLLocationManager?
    
    /** App是否找到beacon。
     * 若狀態為far, near, immediate時，為true。
     * unknown時為false。
     *
     */
    var beaconFound = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        // 要求所有時間皆可取用User位置的權限
        locationManager?.requestAlwaysAuthorization()
        // 要求使用App時可以取用User位置的權限
//        locationManager?.requestWhenInUseAuthorization()
        
        view.backgroundColor = .gray
        
        addPenguin()
    }
    
    // 畫出原形
    func addPenguin(){
        penguin = UIImageView(image: UIImage(named:"penguin"))
        penguin.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(penguin)
        
        NSLayoutConstraint.activate([
            penguin.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            penguin.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
        ])
    }
    
    //
    /** 當User同意位置權限時，會觸發本function
     * 此處我們設計，當User同意我們使用位置權限為.authorizedAlways時，
     * 即開始進行iBeacon的掃描(startScanning())。
     */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 如果權限狀態為「永遠」
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
                // 檢查這隻手機是否可以判斷iBeacon與手機的距離
                if CLLocationManager.isRangingAvailable(){
                    startScanning(uuid: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, name: "iBeacon 1")
                    startScanning(uuid: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", major: 123, minor: 456, name: "iBeacon 2")
                }
            }
        }
    }
    
    /** 開始以我們定義的iBeacon編號進行搜尋
     *  iBeacon以三樣編號將其定義為Unique
     *  1.UUID
     *  2.Majon
     *  3.Minor
     */
    func startScanning(uuid: String, major: Int, minor: Int, name: String){
        let uuid = UUID(uuidString: uuid)!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: name)

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
        
    }
    
    /** 在蘋果的iBeacon架構中，定義出了四種不同的距離
     * 1. unknown  遠於50M
     * 2. far 約50M以內
     * 3. near 約2M以內
     * 4. immediate 約0.5M以內
     */
    func update(distance: CLProximity){
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.penguin.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.penguin.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.penguin.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
//                self.distanceReading.text = "RIGHT HERE"
            default:
                self.penguin.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.view.backgroundColor = .gray
//                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    /** 當收到beacon的距離時，觸發此function
     * App將更新畫面顏色及Label文字
     */
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        if let beacon = beacons.first {
            // 更新畫面背景顏色
            update(distance: beacon.proximity)
        }
    }


}

