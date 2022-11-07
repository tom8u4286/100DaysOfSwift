//
//  ViewController.swift
//  Project15
//
//  Created by 曲奕帆 on 2022/10/17.
//

import UIKit

class ViewController: UIViewController {
    
    // 企鵝圖片
    var imageView: UIImageView!
    
    /** 目前執行的動畫型態
     * 共七種，每執行一種型態後，會執行下一種型態。
     */
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
//        UIView.animate(withDuration: 1, delay: 0,options: [], animations:{
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations:{
            switch self.currentAnimation {
            case 0:
                // 大小縮放
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                break
            case 1:
                // 回到圖片原本狀態
                self.imageView.transform = .identity
            case 2:
                // 位移
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
            case 3:
                self.imageView.transform = .identity
            case 4:
                // 旋轉(徑度量)
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                // 改變顏色
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
            default:
                break
            }
        }){ finished in
            sender.isHidden = false
        }
        
        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    
}

