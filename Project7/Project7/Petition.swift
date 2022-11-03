//
//  Petition.swift
//  Project7
//
//  Created by 曲奕帆 on 2022/6/22.
//

import Foundation

/** 遵循Codable這個Protocol，
 * 可以讓這個struct與JSON自由轉換。
 *  教材說明：
 *  https://www.hackingwithswift.com/read/7/3/parsing-json-using-the-codable-protocol
 */
struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
