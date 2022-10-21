//
//  DetailViewController.swift
//  ProjectDay74
//
//  Created by 曲奕帆 on 2022/10/21.
//

import UIKit

class DetailViewController: UIViewController,
                            UITextViewDelegate {
    // 本記事的index
    var index: Int!
    
    // 取得UserDefaults DB
    let defaults = UserDefaults.standard
    
    // 文字輸入方框
    @IBOutlet var textInputBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定文字方框的預設值
        setTextInputValue()
        
        /** textInputBox的delegate設定為本Class
         * textViewDidChanged()才會收到通知。
         */
        textInputBox.delegate = self
        
    }
        
    // 設定textIntput的預設值
    func setTextInputValue(){
        if let notesArray = defaults.stringArray(forKey: "notes") {
            textInputBox.text = notesArray[index]
        }
    }

    // 偵測當textView被編輯時，會觸發本function
    func textViewDidChange(_ textView: UITextView) {
        if let newText = textView.text {
            save(newText)
        }
    }
    
    // 將文字內容存入UserDefault中
    func save(_ newText: String){
        if let notesArray = defaults.stringArray(forKey: "notes") {
            var newArray = notesArray
            newArray[index] = newText
            
            // 存入UserDefault中
            defaults.set(newArray, forKey: "notes")
        }
    }

}
