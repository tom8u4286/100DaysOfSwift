//
//  ViewController.swift
//  ProjectDay50
//
//  Created by 曲奕帆 on 2022/10/15.
//

import UIKit

class ViewController: UITableViewController {

    // User挑選照片後，照片的名稱會被加入進此陣列
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // 新增左上方加號按鈕
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
        
    }
    
    // 加入新照片
    @objc func addNewPicture(){
        let picker = UIImagePickerController()
        
        // 設定picker為相機
        picker.sourceType = .camera
        
        present(picker, animated: true)
        
    }
    
    // 數兩設定為pictures的內容數量
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // 設定每一個Cell的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        cell.textLabel?.text = pictures[indexPath.row]
        
        return cell
    }
    
    // 當點選某一Cell時的動作
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }


}

