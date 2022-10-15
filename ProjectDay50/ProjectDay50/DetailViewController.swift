//
//  DetailViewController.swift
//  ProjectDay50
//
//  Created by 曲奕帆 on 2022/10/15.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    
    // 將會傳入檔案名稱
    var imageCaption: String?
    var filename: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 標題為User設定的照片名稱
        title = imageCaption
        
        
        let path = getDocumentsDirectory()
        let filepath = path + filename!
        
        if let url = URL(string: filepath){
            if let data = try? Data(contentsOf: url), let loaded = UIImage(data: data) {
                imageView.image = loaded
            } else {
                imageView.image = nil
            }
        }
        
        
    }
    
    /** 取得本app的documentDirectory
     *  FileManager說明
     *  .documentDirectory: asks for the documents directory,
     *  .userDomainMask: the path to be relative to the user's home directory.
     */
    func getDocumentsDirectory() -> String {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0].absoluteString
    }

}
