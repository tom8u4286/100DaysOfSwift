//
//  ViewController.swift
//  Project28
//
//  Created by 曲奕帆 on 2022/11/1.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    // 在頁面上讓User打字的區域，準備進行加密
    @IBOutlet var secret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** 在身份驗證成功之前，title會顯示nothing to see，
         * 直到TouchID或FaceID驗證成功，才會顯示"Secret stuff"。
         */
        title = "Nothing to see here"
        
        // 建立center，通知我們鍵盤的狀態
        let notificationCenter = NotificationCenter.default
        
        // 監聽鍵盤準備隱藏時
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        // 監聽鍵盤準備出現時
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // 監聽app準備進入inactive狀態時(離開前景)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    // 調整TextInput的位置，讓文字不要被鍵盤擋住。
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

        // scrollIndicator(右側滑動桿)也同樣要上移
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }

    // 當點選按鈕時，進行touchID或faceID驗證
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        /** 檢驗User是否有開啟生物識別功能。
         * 即便手機支援TouchID或FaceID，User也必須在系統中Enable生物識別的使用。
         */
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself!"
            
            /** 執行TouchID或FaceID驗證。
             * 是否驗證成功會回傳給closure的success(bool)。
             */
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                /** 由於User在執行FaceID或是TouchID時會需要時間，
                 * 因此在驗證執行完後，要用DispatchQueue將後續的工作推回UI。
                 */
                DispatchQueue.main.async {
                    // 如果User FaceID 成功
                    if success {
                        // 解除鎖定
                        self?.unlockSecretMessage()
                    // 如果User驗證失敗
                    } else {
                        let ac = UIAlertController(title: "驗證失敗", message: "Authentication failed. Please try again!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        // 如果這個裝置沒有TouchID或FaceID
        } else {
            let ac = UIAlertController(title: "不支援生物識別", message: "你的裝置沒有FaceID或TouchID", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    /** 將明文轉為密文，存入Keychain中。
     * 此處我們使用MIT License 的開源專案KeychainWrapper，
     * 讓Keychain的操作可以如同使用UserDefault。
     */
    @objc func saveSecretMessage(){
        // 確認textField目前處於"顯示"狀態
        guard secret.isHidden == false else { return }
        
        // 將明文存入Keychain之中
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        
        /** 通知我們應該要離開focus的狀態(請系統離開編輯狀態)。
         * 教材說明：
         * https://www.hackingwithswift.com/read/28/3/writing-somewhere-safe-the-ios-keychain
         */
        secret.resignFirstResponder()
        // 隱藏textField
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
    // 解密先前儲存於Keychain中的內容
    func unlockSecretMessage(){
        // 顯示textField
        secret.isHidden = false
        title = "Secret stuff!"
        
        // 將文字用KeychainWrapper包裝
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
      
}

