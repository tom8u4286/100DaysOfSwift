//
//  ViewController.swift
//  Project8
//
//  Created by 曲奕帆 on 2022/6/23.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    // 所有被User點選到的答案
    var activatedButtons = [UIButton]()
    
    var solutions = [String]()
    
    // User當前的得分
    var score = 0
    // 遊戲難度
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        //
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "分數: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap the letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        // 設定submit按鈕要執行的function
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        // 設定clear按鈕點按後要執行的function
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        let width = 150
        let height = 80
        
        // 總共4個row
        for row in 0..<4 {
            // 每個row有5個column
            for column in 0..<5 {
                // 宣告一個UIButton
                let letterButton = UIButton(type: .system)
                // 設定字體大小
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                // 設定按鈕要觸發的function
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                // 宣告一個方形元件CGRect
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                // 把方形元件指定給Button
                letterButton.frame = frame
                
                // 將按鈕加入view中
                buttonsView.addSubview(letterButton)
                // 將按鈕加入letterButtons陣列中
                letterButtons.append(letterButton)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton){
        
    }
    
    @objc func submitTapped(_ sender: UIButton){
        
    }
    
    @objc func clearTapped(_ sender: UIButton){
        
    }
    
    func loadLevel(){
        // 本題的提示文字
        var clueString = ""
        // 說明:solutionsString將會包含每一個題目包含幾個字母
        // (我其實覺得他變數名稱取的怪怪的)
        var solutionsString = ""
        // 所有答案的片段，如HA, UNT, ED..等等
        var letterBits = [String]()
        
        // 載入題目檔案
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelFileURL){
                // 載入進來的每一行，以換行符號\n隔開
                // 因此一個字串可能為: HA|UNT|ED: Ghosts in residence
                // 此處就可以得到一個陣列，陣列每一個元素為檔案裡的一行字串
                var lines = levelContents.components(separatedBy: "\n")
                // 陣列洗牌
                lines.shuffled()
                
                // enumerated()會讓陣列內容皆搭配個index
                for (index, line) in lines.enumerated(){
                    // 將字串以": "隔開
                    let parts = line.components(separatedBy: ": ")
                    // answer可能為"HA|UNT|ED"
                    let answer = parts[0]
                    // clue可能為"Ghosts in residence"
                    let clue = parts[1]
                    
                    // 線索字串為"編號"加上"線索文字"並換行
                    clueString += "\(index+1). \(clue)\n"
                    
                    // 正確答案，將|換掉改為空字串
                    let solutionWord = answer.replacingOccurrences(of:"|", with: "")
                    // 將該題目答案有幾個字幕，存入solutionsString中
                    solutionsString += "\(solutionWord.count) letters\n"
                    // 將正確答案加到全域變數solutions陣列中
                    solutions.append(solutionWord)
                    
                    // answer可能為"HA|UNT|ED"，bits就為["HA", "UNT", "ED"]
                    let bits = answer.components(separatedBy: "|")
                    // 將答案片段加入letterBits陣列中
                    letterBits += bits
                }
            }
        }
    
        
        // 移除clueString中所有的空白與換行符號
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        // 移除答案answersLabel中所有的空白與換行符號
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 對letterButtons洗牌
        letterButtons.shuffle()
        
        // 目前在loadView中是設計20個按鈕，
        // 因此題目檔中(level1.txt)也必須設計成20個答案片段才可以。
        if letterButtons.count == letterBits.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
}

