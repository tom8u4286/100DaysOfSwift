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

    // 顯示iBeacon的距離狀態標籤
    @IBOutlet var distanceReading: UILabel!
    
    // 顯示iBeacon的UUID
    @IBOutlet var uuidLabel: UILabel!
    
    
    
    var locationManager: CLLocationManager?
    
    //
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
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
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
            
            // unknown 我們假設視為未找到
            if beacon.proximity == .unknown {
                beaconFound = false
                uuidLabel.text = "UUID"
            } else {
                // beacon被發現，改變我們設計的搜尋狀態為真
                if !beaconFound {
                    beaconFound = true

                    // 發現iBeacon的Alert提示
                    let ac = UIAlertController(title: "找到iBeacon", message: "發現鄰近的iBeacon", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
                
                let uuid = beacon.uuid.uuidString
                uuidLabel.text = uuid
                
            }
        }
    }


}

