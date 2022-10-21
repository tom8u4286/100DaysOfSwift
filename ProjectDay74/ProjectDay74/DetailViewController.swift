//
//  DetailViewController.swift
//  ProjectDay74
//
//  Created by 曲奕帆 on 2022/10/21.
//

import UIKit

class DetailViewController: UIViewController,
                            UITextViewDelegate {
    
    // 本記事的內容
    var content: String!
    
    // 本記事的index
    var index: Int!
    
    // 取得UserDefaults DB
    let defaults = UserDefaults.standard
    
    @IBOutlet var textInputBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** textInputBox的delegate設定為本Class
         * textViewDidChanged()才會收到通知。
         */
        textInputBox.delegate = self
        
        
        // 取得記事內容
//        getContent()
        
    }
    
    // 從UserDefault取得本記事的內容
    func getContent(){
        
        
        /** 此處應注意，
         * defaults.object讀出來的型態為Any，要記得as?轉換為 Data型態
         */
        if let savedNotes = defaults.object(forKey: "notes") as? [String]{
            print("savedNotes:\(savedNotes)")
        }
    }

    // 偵測當textView被編輯時，會觸發本function
    func textViewDidChange(_ textView: UITextView) {
        if let newText = textView.text {
            save()
        }
    }
    
    // 將文字內容存入UserDefault中
    func save(){
        let notes = defaults.stringArray(forKey: "notes")
        print(index)
        print(notes)
    }

}
