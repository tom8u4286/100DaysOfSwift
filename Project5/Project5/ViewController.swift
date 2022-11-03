//
//  ViewController.swift
//  Project5
//
//  Created by 曲奕帆 on 2022/6/18.
//

import UIKit

class ViewController: UITableViewController {
    
    // 題目文字
    var allWords = [String]()
    // 已經被User加入過的單字
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 右上方加號按鈕，讓User加入新答案
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // 從Bundle中載入題目
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy:"\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        // 開始遊戲
        startGame()
    }
    
    func startGame(){
        /** title為ViewController的標題
         * 我們將title設定為題目單字。
         */
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    
    /** User點選加號後，在AlertController中加入文字輸入欄，
     * 以供User填寫答案。
     */
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        /** 此處closure中的self以weak的方式傳入，
         * 原因在於，若這個ViewController在這個closure執行前就死了，
         * 會導致iOS認為有人在參考這個ViewController(self)，
         * 而不會釋放ViewController的記憶體空間，
         * 導致reference cycle問題。
         * 因此要用weak，才不會新增ViewController的reference count。
         */
        let submitAction = UIAlertAction(title:"Submit", style: .default){ [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    /** User提交答案後，對這個答案進行檢驗，
     * 判定是否是一個正確答案。
     */
    func submit(_ answer: String){
        let lowerAnswer = answer.lowercased()

        let errorTitle: String
        let errorMessage: String

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)

                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)

                    return
                } else {
                    errorTitle = "這不是一個英文字"
                    errorMessage = "請不要亂拼！"
                }
            } else {
                errorTitle = "已經用過"
                errorMessage = "這個字已經被打過，請發揮想像力!"
            }
        } else {
            errorTitle = "無法組成"
            errorMessage = "這個字無法由\(title!) 的字母所組成"
        }

        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    // 檢驗User當前輸入的文字是否可被標題文字所組成
    // 例如: 標題文字為"agencies"，User輸入"cease"，此function將會回傳true。
    func isPossible(word: String) -> Bool {
        // 將當前標題文字轉為小寫
        guard var tempWord = title?.lowercased() else {return false}

        for letter in word {
            // 取得array中第一個符合條件的位置(index)
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            } else {
                // 如果title的字裡，完全找不到本字母
                return false
            }
        }
        // 如果可以被標題文字組成，回傳true
        return true
    }

    // 檢查這個自是否已經打過
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    // 檢驗User輸入的單字是否是一個真實文字，而非亂打
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en"
        )

        return misspelledRange.location == NSNotFound
    }
}



