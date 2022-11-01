//
//  ViewController.swift
//  Project28
//
//  Created by 曲奕帆 on 2022/11/1.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var secret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 建立center，通知我們鍵盤的狀態
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        // 若keyboard準備要隱藏時
        if notification.name == UIResponder.keyboardWillHideNotification{
            // 將TextInput設定回原本位置
            secret.contentInset = .zero
        } else {
            /** 將TextInput升高至鍵盤的位置。
             * 說明：keyboardViewEndFrame.height會包含非safeArea(home indicator)的高度，
             * 因此要將homeIndicator的高度扣掉。
             */
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            
        }
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        
    }
    
}

