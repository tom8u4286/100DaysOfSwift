//
//  Picture.swift
//  ProjectDay50
//
//  Created by 曲奕帆 on 2022/10/15.
//

import UIKit

class Picture: NSObject, Codable {
    // 照片檔案名稱
    var filename: String
    // 小標題
    var caption: String
    
    init(filename: String, caption: String){
        self.filename = filename
        self.caption = caption
    }
    
}
