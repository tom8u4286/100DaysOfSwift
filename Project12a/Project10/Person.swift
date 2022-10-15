//
//  Person.swift
//  Project10
//
//  Created by 曲奕帆 on 2022/10/7.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String){
        self.name = name
        self.image = image
    }
    
    /** 此處我們預計將Person物件存入UesrDefault(App的基本DB)中，
     * 而存入此DB必須follow NSCoding的protocol。
     * 在準備存入此筆資料時，使用encoder，
     * 要讀取此筆資料時，再用decoder解碼。
     */
    required init?(coder aDecoder: NSCoder){
//        let test = aDecoder.decodeObject(forKey: <#T##String#>)
        /** 由於decodeObject轉換出來的格式為Any?，
         * 轉換回String資料格式。
         * 我們使用decodeObject是因為目前沒有decodeString的function
         */
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }
    
}
