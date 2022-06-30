//
//  ViewController.swift
//  Project2
//
//  Created by 曲奕帆 on 2021/4/19.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        countries += ["estonia","france", "germany", "ireland", "italy","monaco","nigeria","poland","russia","spain","uk","us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(scoreTapped))
        
        askQuestion(action: nil)
        
    }

    func askQuestion(action: UIAlertAction!){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + " Current Score: \(score)"
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer{
            title = "Correct!"
            score += 1
        }else{
            title = "Wrong! This is \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        questionCount += 1
        
        if questionCount < 10{
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }else{
            let ac = UIAlertController(title: "Game Over", message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
        
    }
    
    @objc func scoreTapped() {
        let ac = UIAlertController(title: "Current Score", message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in }))
        present(ac, animated: true)
    }
    
    
}

