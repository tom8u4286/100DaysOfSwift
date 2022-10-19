//
//  Capital.swift
//  Project16
//
//  Created by 曲奕帆 on 2022/10/19.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    
    var title: String?
    // 座標
    var coordinate: CLLocationCoordinate2D
    // 資訊
    var info: String
    // wiki網址
    var wiki: URL?
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D, info: String, wiki: URL? = nil) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.wiki = wiki
    }
    
}
