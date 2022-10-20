//
//  ViewController.swift
//  Project2
//
//  Created by 曲奕帆 on 2022/10/18.
//

import UserNotifications
import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    
    // 正確答案的位置(可能為0, 1, 2)
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 請求User讓我們發送通知的權限
        registerLocal()
        
        countries += ["estonia","france","germany","ireland",
        "italy","monaco","nigeria","estonia","poland","russia",
        "spain","uk","us"]
        
        // 設定國旗的邊框
        setBorder()
        
        // 送出題目
        askQuestion()
        
    }
    
    // 請求User讓我們發送通知的權限
    func registerLocal() {
        // 回傳App使用的通知中心
        let center = UNUserNotificationCenter.current()
        
        // 請求User讓我們發送通知的權限(.badge為通知欄左側的Icon)
        center.requestAuthorization(options: [.alert, .badge, .sound]){ [ weak self ] granted, error in
            if granted {
                print("✅ User同意我們發送通知")
                self?.scheduleLocal()
            } else {
                print("⛔️ User不同意")
            }
        }
    }
    
    // 對通知中心登記發送通知的時機
    func scheduleLocal(){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "請回來玩玩"
        content.body = "你好久沒有回來玩玩了，快來玩玩！"
        
        // 如果要repeat的話，至少要60秒
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: "remind", content: content, trigger: trigger)
        center.add(request)
    }
    
    
    // 設定國旗圖片的邊框
    func setBorder(){
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    
    /** 此處注意
     * 由於在UIAlertAction的handler要呼叫askQuestion，
     * 就必須要設計參數action: UIAlertAction。
     */
    func askQuestion(action: UIAlertAction! = nil){
        // 洗牌countries的順序
        countries.shuffle()
        
        // 設定本題正確答案的位置
        correctAnswer = Int.random(in: 0...2)
        
        // 設定圖片
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer]
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var alertTitle: String
        
        if sender.tag == correctAnswer {
            alertTitle = "正確!"
            score += 1
        } else {
            alertTitle = "答錯了"
            score -= 1
        }
        
        let ac = UIAlertController(title: alertTitle, message: "目前得分:\(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: askQuestion))
        present(ac, animated: true)
        
    }
    
}

