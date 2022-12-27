//
//  ViewController.swift
//  Project2
//
//  Created by 曲奕帆 on 2022/10/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    
    // 正確答案的位置(可能為0, 1, 2)
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 可能的國家
        countries += ["estonia","france","germany","ireland",
        "italy","monaco","nigeria","estonia","poland","russia",
        "spain","uk","us"]
        
        // 設定國旗圖片的邊框
        setBorder()
        
        // 拋出題目(遊戲開始)
        askQuestion()
    }
    
    
    // 設定國旗圖片的邊框
    func setBorder(){
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    /** 此處注意
     * 由於在UIAlertAction的handler要呼叫askQuestion，
     * 就必須要設計參數action: UIAlertAction。
     */
    func askQuestion(action: UIAlertAction! = nil){
        // 洗牌countries的順序
        countries.shuffle()
        
        // 設定本題正確答案的位置
        correctAnswer = Int.random(in: 0...2)
        
        // 將按鈕文字設定為空值
        button1.setTitle("", for: .normal)
        button2.setTitle("", for: .normal)
        button3.setTitle("", for: .normal)
        
        // 設定圖片
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        
        // 設定國家名稱作為標題，為本題題目
        title = countries[correctAnswer]
    }

    /** 玩家點選國旗後，顯示Alert提示是否答對，
     * 並顯示目前玩家得分。
     */
    @IBAction func buttonTapped(_ sender: UIButton) {
        var alertTitle: String
        
        if sender.tag == correctAnswer {
            alertTitle = "正確!"
            score += 1
        } else {
            alertTitle = "答錯了"
            score -= 1
        }
        
        let ac = UIAlertController(title: alertTitle, message: "目前得分:\(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: askQuestion))
        present(ac, animated: true)
        
    }
    
}

