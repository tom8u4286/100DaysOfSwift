//
//  ViewController.swift
//  Project21
//
//  Created by 曲奕帆 on 2022/10/20.
//


import UserNotifications
import UIKit

/** Project21為通知中心練習。
 *  1.先向User請求NotificationCenter的權限，內容要包含通知的內容，如: .alert, .badge. sound等等
 *  2.對通知中心註冊我們App支援的通知類別(NotificationCateGories)，類別的名稱String可由我們自由定義。如: "alarm"
 */

class ViewController: UIViewController,
                    UNUserNotificationCenterDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 左側設計「註冊按鈕」
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        // 右側設計「開始通知定時器」
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
        
        // 將"alarm"類別的通知註冊給通知中心
        registerCategories()
    }
    
    @objc func registerLocal() {
        // 回傳App使用的通知中心
        let center = UNUserNotificationCenter.current()
        
        // 請求User讓我們發送通知的權限(.badge為通知欄左側的Icon)
        center.requestAuthorization(options: [.alert, .badge, .sound]){ (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    
    /** 將我們設計好的Notification，加給通知中心UserNotificationCenter
     */
    @objc func scheduleLocal(){
        // 回傳App使用的通知中心
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        /** 可編輯的「通知內容」，設定此通知
         */
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        
        /** 當App可能產生各式的通知時，就會給定每一個通知一個「類別category」，
         * 此處我們將這個通知歸類為"alarm"
         */
        content.categoryIdentifier = "alarm"
        
        // userInfo 可以設計我們自己需要的key-value
        content.userInfo = ["customData": "fizzbuzz"]
        // 通知要發出的聲音
        content.sound = .default
        
        // 設定時間變數
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        
        // 設定某一個時間點觸發的trigger
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // 設定時間間隔觸發的trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // 產生一個通知請求物件，並加入通知中心
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    
    // 向通知中心註冊"alarm"類別的通知
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        /** 設定User左滑通知後，點選「檢視View」後的選項
         * .foreground表示直接於前景開啟App
         * .destructive將清除本通知
         */
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let show2 = UNNotificationAction(identifier: "show2", title: "Second option", options: .destructive)
        // 產生通知類別物件
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [], options: [])
        let category2 = UNNotificationCategory(identifier: "alarm", actions: [show2], intentIdentifiers: [], options: [])
        
        // 對通知中心註冊我們App支援的通知類別(NotificationCateGories)
        center.setNotificationCategories([category, category2])
    }
    
    
    /** 此為UNUserNotificationCenterDelegate來的function
     *  當User對通知做出反應時，會被觸發。
     *
     */
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        /** 可以取得先前設定UNMutableNotificationContent()時的內容，如：
         * userInfo為"["customData": "fizzbuzz"]"
         * actionIdentifier為"alarm"
         * title為"Late wake up call"
         * body為"The early bird catches the worm, but the second mouse gets the cheese."
         */
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier{
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
            case "show":
                print("Show more information!")
            default:
                break
            }
        }
        
        completionHandler()
    }


}

