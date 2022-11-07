//
//  ViewController.swift
//  Project18
//
//  Created by 曲奕帆 on 2022/10/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** 撰寫asset，程式若未通過此條件，app會crash。
         * 在正式上架置App store時，asset會被自動移除。
         */
        assert( 1 == 1, "assert passsed: this will not be printed.")
//        assert( 1 == 2, "assert failed.")
        
        // print的內容會被separator連接
        print(1, 2, 3, 4, 5, separator: "-")
        
        // 可設定terminator，會被自動接在字串後面()
        print("Some message", terminator: "\n")
        
        /** 以Xcode的Breakpoint進行debug。
         * 可在breakpoint的標籤上點選右鍵，設定停止的Condition。
         */
        for i in 1...50{
            print("line1: the i is \(i)")
            print("line2")
            print("line3")
        }
    }


}

