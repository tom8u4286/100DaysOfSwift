//
//  ViewController.swift
//  ProjectDay74
//
//  Created by 曲奕帆 on 2022/10/21.
//

import UIKit

class ViewController: UITableViewController {

    // 儲存記事的陣列
    var notes = [String]()
    
    // 取得UserDefault DB
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 在右上方新增加號按鈕
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newNote))
        
        // 檢查UserDefault中是否有記事資料
        checkUserDefaultValue()
    }
    
    /** 檢查UserDefault中有沒有記事的資料，
     * 如果沒有，暫時存入["one", "two", "three"]
     * 如果有，將資料從DB中取出，放入notes陣列中。
     */
    func checkUserDefaultValue(){
        if let notesArray = defaults.stringArray(forKey: "notes"){
            print("✅ 發現UserDefault中已經有值，存入notes變數")
            notes = notesArray
        } else {
            print("⚠️ 發現UserDefault中沒有值，存入[one, two, three]")
            defaults.setValue(["one", "two", "three"], forKey: "notes")
            notes = ["one", "two", "three"]
        }
    }
    
    // 新增一個新的記事
    @objc func newNote(){
        // 在storyboard中找到DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 設定Cell的數量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // Cell要顯示的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row]
        return cell
    }
    
    /** User點選Cell時觸發，進入DetailView
     * 在DetailView中顯示先前的記事內容。
     * 傳入點選的index，讓DetailViewController可以從UserDefault中取得先前的記事內容。
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.index = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    


}

