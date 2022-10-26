//
//  GameScene.swift
//  Project14
//
//  Created by 曲奕帆 on 2022/10/26.
//

import SpriteKit

class GameScene: SKScene {
    // 洞口的array
    var slots = [WhackSlot]()
    // 遊戲的得分Label
    var gameScore: SKLabelNode!
    // 得分
    var score = 0 {
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }
    
    // 企鵝出現的時間長度
    var popupTime = 0.85
    
    /** 遊戲輪數
     *  每輪企鵝出現的速度都會加快。
     */
    var numRounds = 0
    
    override func didMove(to view: SKView) {
        // 初始背景圖片
        initBackground()
        
        // 初始得分標籤gameScore
        initGameScoreLabel()
        
        // 初始遊戲畫面中的洞口
        initSlots()
        
        // 遊戲開始1秒後，開始createEnemy
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
            self?.createEnemy()
        }
    }
    
    /** 初始背景圖片
     */
    func initBackground(){
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    /** 初始得分標籤
     */
    func initGameScoreLabel(){
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: \(score)"
        gameScore.position = CGPoint(x: 10, y: 10)
        gameScore.horizontalAlignmentMode = .left
        addChild(gameScore)
    }
    
    /** 初始畫面上的slots
     */
    func initSlots(){
        for i in 0..<5{createSlot(at: CGPoint(x: 100 + (170 * i), y: 410))}
        for i in 0..<4{createSlot(at: CGPoint(x: 180 + (170 * i), y: 320))}
        for i in 0..<5{createSlot(at: CGPoint(x: 100 + (170 * i), y: 230))}
        for i in 0..<4{createSlot(at: CGPoint(x: 180 + (170 * i), y: 140))}
    }
    
    // 當畫面任一處被點按時，觸發本function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            /** 說明：
             * 因為被打中的是「企鵝」(charNode)。
             * 當時設計時，charNode是被包在cropNode中，
             * 而cropNode背包在WhackNode中。
             */
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            
            // 目前是否有企鵝出現，沒有的話就跳過
            if !whackSlot.isVisible { continue }
            // 企鵝是否已經被打過，已經被打過的話就跳過
            if whackSlot.isHit { continue }
            
            whackSlot.hit()
            
            // User不該打好企鵝
            if node.name == "charFriend"{
                // 打錯企鵝，扣5分
                score -= 5
                // 播放打錯的音效
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                
            // User應該打餓壞企鵝
            } else if node.name == "charEnemy" {
                // 打對企鵝，加1分
                score += 1
                // 企鵝縮小
                // 下次顯示企鵝時，要將大小復原
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                // 播放打對的音效
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
    }
    
    /** 新增一個會出現企鵝的洞口
     */
    func createSlot(at position: CGPoint){
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    /** 開始一輪遊戲，企鵝開始從洞口出現。
     *
     */
    func createEnemy(){
        // 遊戲輪數加一
        numRounds += 1
        
        // 設計遊戲只有30輪
        if numRounds > 30 {
            // 遊戲結束
            
            // 讓所有企鵝消失
            for slot in slots { slot.hide() }
            
            // 顯示GameOver的標題
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            // 遊戲結束，不在繼續執行
            return
        }
        
        // 每輪企鵝出現的時間會越來越短
        popupTime *= 0.991
        
        /** 洗牌slot的位置，並設計前五個slot元素依照不同的機率，以該輪的popupTime出現企鵝。
         */
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)}
        
        // 設計下一輪要延遲多少時間才會開始
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        // 短暫時間後再次呼叫createEnemy
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){ [weak self] in
            self?.createEnemy()
        }
    }
    
}
