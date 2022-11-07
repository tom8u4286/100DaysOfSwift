//
//  WhackSlot.swift
//  Project14
//
//  Created by 曲奕帆 on 2022/10/26.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    // 企鵝是否出現
    // "am I currently visible to be whacked by the player?"
    var isVisible = false
    // 這個slot是否被User敲擊
    var isHit = false
    
    // 儲存企鵝圖片的node(character)
    var charNode: SKSpriteNode!
    
    /** 初始設定本Slot。
     *  此處我們沒有使用swift 的init是因為，
     *  我們會額外需要設計很多swift對init函式的要求。
     *  因此不採用init。
     *  可參考教材：
     *  https://www.hackingwithswift.com/read/14/2/getting-up-and-running-skcropnode
     */
    func configure(at position: CGPoint){
        /** 由於本Class就是一個SKNode，
         * 因此可直接設定self.position來設定位置。
         */
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        /** SKCropNode是一個可以在畫面中遮蔽其他Node的Node。
         * SKCropNode的透明之處會隱藏其背後的內容，有色之處會顯示。
         * (SKCropNode uses an image as a cropping mask: anything in the colored part will be visible, anything in the transparent part will be invisible.)
         */
        let cropNode = SKCropNode()
        // 將cropNode設定在洞口圖片的上方
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        // 將企鵝圖片設定在洞口圖片的下方
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        // 注意！此處是在cropNode的裡面，加入charNode(企鵝)
        cropNode.addChild(charNode)
        // 再將cropNode加入WhackSlot裏
        addChild(cropNode)
    }
    
    // 企鵝彈出
    func show(hideTime: Double){
        if isVisible { return }
        
        // 由於User打到正確的企鵝時，有設計企鵝會縮小
        // 每次顯示企鵝時，復原大小
        charNode.xScale = 1
        charNode.yScale = 1
        
        // 企鵝執行SKAction
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        
        // 設定本slot的狀態
        isVisible = true
        isHit = false
        
        /** 說明：
         * 1.用Int.random(in: 0..2) == 0來表示有1/3的機率會觸發if的內容。
         * 因此有1/3的機率會是好企鵝。
         * 2.我們在顯示好企鵝與壞企鵝時，不需要額外產生兩種SpriteNode，
         *  只需要改變.texture屬性即可更換圖片。
         */
        if Int.random(in: 0...2) == 0{
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        }else{
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)){ [weak self] in
            self?.hide()
        }
    }
    
    // 企鵝收起
    func hide(){
        // 確認目前企鵝是在出現的狀態
        if !isVisible { return }
        
        // 企鵝向下移動，躲進洞口裡
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    // User打到企鵝
    func hit(){
        isHit = true
        
        /** 設計好三個行為後，
         * 請charNode執行此三個動作。
         */
        // wait為一個等待一小段時間的行為
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run{ [weak self] in
            self?.isVisible = false
        }
        // 設計序列動畫
        let sequence = SKAction.sequence([delay, hide, notVisible])
        // 執行此序列動畫
        charNode.run(sequence)   
    }
}
