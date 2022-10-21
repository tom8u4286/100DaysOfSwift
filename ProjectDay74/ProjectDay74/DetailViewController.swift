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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        
    }
    
    // 刪除本記事
    @objc func deleteNote(){
        if let notesArray = defaults.stringArray(forKey: "notes") {
            var newArray = notesArray
            newArray.remove(at: index)
            
            // 存入UserDefault中
            defaults.set(newArray, forKey: "notes")
        }
        
        // 回到上一頁
        navigationController?.popViewController(animated: true)
    }
        
    // 設定textIntput的預設值
    func setTextInputValue(){
        if let notesArray = defaults.stringArray(forKey: "notes") {
            /** 如果index的值就是notesArray的長度，視為新的記事
             * 否則為先前的記事，將記事內容載入textInputView中
             */
            if index < notesArray.count {
                textInputBox.text = notesArray[index]
            }
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
            // 若array內的長度為母頁面傳進來的index，表示此篇記事尚未被存檔過
            if notesArray.count == index {
                newArray.append(newText)
            } else {
                newArray[index] = newText
            }
            
            // 存入UserDefault中
            defaults.set(newArray, forKey: "notes")
        }
    }

}
