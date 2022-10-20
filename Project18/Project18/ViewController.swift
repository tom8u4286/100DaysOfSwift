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
        // Do any additional setup after loading the view.
        
        
        assert( 1 == 1, "assert passsed: this will not be printed.")
//        assert( 1 == 2, "assert failed.")
        
        for i in 1...50{
            print("line1: the i is \(i)")
            print("line2")
            print("line3")
        }
        
        
    }


}

