//
//  ViewController.swift
//  Project1
//
//  Created by 曲奕帆 on 2022/10/14.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 以FileManager 取出App中的檔案名稱
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        print(pictures)
    }

    // numberOfRowsInSection 一個Section有多少Cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // cellForRowAt Cell要顯示什麼內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    // didSelectRowAt 當點選到某一個Cell時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /** 此處有三處可能失敗
         *  1.storyboard可能不存在，因此要使用storyboard?
         *  2.可能沒有id為"Detail"的view
         *  3.可能無法轉換為DetailViewController
         */
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}

