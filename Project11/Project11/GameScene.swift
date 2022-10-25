//
//  GameScene.swift
//  Project11
//
//  Created by 曲奕帆 on 2022/10/25.
//

import SpriteKit


/** 利用SpriteKit設計一個遊戲，再畫面中點選時，會有紅色的彈珠掉落，
 * 觸碰到綠色區域時，會得分。
 */
class GameScene: SKScene,
                SKPhysicsContactDelegate{
    
    // 顯示分數的Label
    var scoreLabel: SKLabelNode!
    // 當前分數
    var score = 0 {
        // 當score被改變時，scoreLabel的文字也會被改變
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    // 設計一個讓User可以點選，點選後可以編輯遊戲的按鈕
    var editLabel: SKLabelNode!
    // 遊戲是否正處於編輯模式
    var editingMode = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            }else{
                editLabel.text = "Edit"
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        
        /** Blend modes determine how a node is drawn, and SpriteKit gives you many options.
         *  The .replace option means "just draw it, ignoring any alpha values," which makes it fast for things without gaps such as our background.
         */
        background.blendMode = .replace
        // 設定background為最底層畫面
        background.zPosition = -1
        // 將Node加入Scene中
        addChild(background)
        
        /** 設定scoreLabel
         */
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        /** 設定editLabel
         */
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.horizontalAlignmentMode = .left
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        
        // 設計整個頁面為一個PhysicsBody
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        /** 說明:
         * 先被繪製的物體，會被放在畫面下層(會被後繪製的物體遮蓋)，
         * 後被繪製的物體，會在畫面的上層。
         */
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        // 抓出被點選的位置
        let location = touch.location(in: self)
        
        // 確認當前被點選的物件
        let objects = nodes(at: location)
        
        /** 如果被點選的位置，是editLabel，
         * 將editLabel改變狀態(Edit <-> Done)。
         * 如果在Edit模式中，點選他處時要畫出長條形。
         * 如果在遊戲模式中(Done)，點選他處時要畫出彈珠。
         */
        if objects.contains(editLabel){
            // toggle(): true false互換
            editingMode.toggle()
        } else{
            // 如果在編輯模式下，畫出長方形
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let rect = SKSpriteNode(color:UIColor(red: CGFloat.random(in: 0...1),
                                                    green: CGFloat.random(in: 0...1),
                                                    blue: CGFloat.random(in: 0...1),
                                                      alpha: 1.0), size: size)
                // 隨機旋轉
                rect.zRotation = CGFloat.random(in: 0...3)
                // 設定繪出位置
                rect.position = location
                // 設定實體
                rect.physicsBody = SKPhysicsBody(rectangleOf: size)
                // 設定此rect不會移動
                rect.physicsBody?.isDynamic = false
                // 加入此rect
                addChild(rect)
                
            // 如果不在編輯模式下，畫出彈珠
            } else{
                // 以圖片ballRed產生一個SKSpriteNode
                let ball = SKSpriteNode(imageNamed: "ballRed")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0 )
                // 設定ball的彈性，1
                ball.physicsBody?.restitution = 0.4
                
                /** 本行可參閱詳細說明：
                 * https://www.hackingwithswift.com/read/11/5/collision-detection-skphysicscontactdelegate
                 * contactTestBitMask負責設定「要通知我們的碰撞」，預設為無。
                 * collisionBitMask負責設定「要碰撞的物品」，預設為所有物件。
                 * 因此將兩個屬性相等，即表示所有碰撞皆會通知我們(delegate)。
                 */
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                // 設定ball的位置
                ball.position = location
                // 設定ball的名稱
                ball.name = "ball"
                addChild(ball)
            }
        }
        
        
    }
    
    // 在畫面畫出bouncer
    func makeBouncer(at position: CGPoint){
        /** 在遊戲畫面中加入bouncer。
         * 此處應注意，SKSpriteNode參數有filename或imageName。
         */
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        // 設定bouncer不能在畫面上移動
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    // 遊戲洞口，分為好洞口(ex:得分)與壞洞口(ex:扣分)
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        // 建立slotBase物理實體
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        // 固定slotBase，讓slotBase在畫面上不會移動
        slotBase.physicsBody?.isDynamic = false
        
        // 加入畫面中
        addChild(slotBase)
        addChild(slotGlow)
        
        // 讓光環圖片旋轉
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    /** 說明:
     * SKNode是SKSPrite的母Class。
     */
    func collision(between ball: SKNode, object: SKNode){
        if object.name == "good"{
            destory(ball: ball)
            score += 1
        } else if object.name == "bad"{
            destory(ball: ball)
            score -= 1
        }
    }
    
    // 顯示彈珠爆炸，並將ball從畫面中移除
    func destory(ball: SKNode){
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"){
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    /** 此為兩物體發生碰撞時，會被通知的function。
     * 注意：
     * 當兩物體碰撞時，iOS會通知我們兩次(是為兩個事件)
     * 1.A撞到B了
     * 2.B撞到A了
     * 由於我們設計ball碰到slot時，ball會消失，
     * 會導致第二個事件在force unwrap時會Crash。
     * 因此要特別使用guard確定兩個物件都存在。
     */
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
                
        // 確定碰撞的bodyA與bodyB何者為ball
        if nodeA.name == "ball"{
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball"{
            collision(between: nodeB, object: nodeA)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
