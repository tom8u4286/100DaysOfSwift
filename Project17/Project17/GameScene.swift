//
//  GameScene.swift
//  Project17
//
//  Created by 曲奕帆 on 2022/10/26.
//

import SpriteKit

class GameScene: SKScene,
                SKPhysicsContactDelegate // 可接收Scene中物體碰撞事件
{
    // 星空背景
    var starfield: SKEmitterNode!
    
    // 玩家
    var player: SKSpriteNode!
    
    // 得分標籤
    var scoreLabel: SKLabelNode!
    
    // 遊戲中可能的太空物品
    var possibleEnemies = ["ball", "hammer", "tv"]
    
    // 設計可定期送出特空垃圾的timer
    var gameTimer: Timer?
    
    // 遊戲是否已結束
    var isGameOver = false
    
    // 得分
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // SKScene的起始(類似UIKit的ViewDidLoad)
    override func didMove(to view: SKView) {
        // 設定星空背景
        initStarfield()
        
        // 設定玩家的飛船
        initPlayer()
        
        // 設定得分標籤
        initScoreLabel()
        
        // 設定無重力，physics物體才不會向下掉
        physicsWorld.gravity = .zero
        // 設定碰撞的Delegate為自己，碰撞發生時通知self
        physicsWorld.contactDelegate = self
        
        // 設定Timer，固定時間會新增太空垃圾
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    // 初始設定背景星空
    func initStarfield(){
        // 背景為黑
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")
        // 設定在畫面的正右方
        starfield.position = CGPoint(x: 1024, y: 384)
        /** 由於我們不希望遊戲開始時，背景一開始都沒有星星，
         * 我們需要直接顯示數秒之前的星空背景動畫，
         * 好像玩家在遊戲開始時，就看到整個畫面的星空。
         * 我們使用advanceSimulationTime()達到。
         * 教材說明：
         * https://www.hackingwithswift.com/read/17/2/space-the-final-frontier
         */
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -1
        addChild(starfield)
    }
    
    // 初始設定Player
    func initPlayer(){
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        // 此處應再仔細研究contactTestBitMask
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
    }
    
    // 初始設定得分標籤
    func initScoreLabel(){
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
    }
    
    // 創造一個新的太空垃圾
    @objc func createEnemy(){
        // 隨機取得陣列中的一個物品
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        
        // 設定本物品移動的速度(x設定為負，表示往左移動)
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        // 設定本物品的自轉速度
        sprite.physicsBody?.angularVelocity = 5
        // 設定本物品在受到撞擊時，停下來的速度。設定為0表示不會停下來。
        sprite.physicsBody?.linearDamping = 0
        // 設定本物品在受到撞擊時，自轉停下來的速度。設定為0表示不會停下來。
        sprite.physicsBody?.angularDamping = 0
        
        addChild(sprite)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // 當太空垃圾的位置離開畫面時，將其移除
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        // 如果遊戲還未結束，分數上加
        if !isGameOver{
            score += 1
        }
    }
    
    /** 當User觸碰螢幕時觸發此function
     * 注意！touchesMoved與touchesBegin不同！
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        // 取得這個touch在本GameScene的觸碰的位置
        var location = touch.location(in: self)
        
        // 設計玩家不可以低於ScoreLabel，以及最上方100點
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        // 將玩家的飛船移動到觸碰的位置
        player.position = location
    }
    
    /** 由於self是SKPhysicsContactDelegate，
     * 碰撞發生時會觸發本function。
     */
    func didBegin(_ contact: SKPhysicsContact) {
        // 設計在碰撞的地方，顯示爆炸動畫
        guard let explosion = SKEmitterNode(fileNamed: "explosion") else { return }
        explosion.position = player.position
        addChild(explosion)
        
        // 從Scene中移除玩家的飛船
        player.removeFromParent()
        
        // 遊戲結束
        isGameOver = true
    }
}
