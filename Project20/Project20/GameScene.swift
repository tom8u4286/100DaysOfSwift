//
//  GameScene.swift
//  Project20
//
//  Created by 曲奕帆 on 2022/10/27.
//

import SpriteKit

class GameScene: SKScene {
    
    // 遊戲每六秒會發射一次煙火
    var gameTimer: Timer?
    
    // 存放煙火的SKNode
    var fireworks = [SKNode]()
    
    // 設計煙火會發射的位置
    let leftEdge = -22
    let rightEdge = 1024 + 22
    let bottomEdge = -22
    
    // 遊戲得分
    var score = 0 {
        didSet{
//            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        // 設定背景圖片
        initBackground()
        
        // 每六秒發射一次火箭
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFirework), userInfo: nil, repeats: true)
        
    }
    
    // 設定背景圖片
    func initBackground(){
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    // 發射一組煙火
    @objc func launchFirework(){
        // 移動量，一個大於1024的數字
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3){
        case 0:
            // 五個煙火，垂直向上發射
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            // 五個煙火，扇形發射
            createFirework(xMovement: -200, x: 512, y: bottomEdge)
            createFirework(xMovement: -100, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 100, x: 512, y: bottomEdge)
            createFirework(xMovement: 200, x: 512, y: bottomEdge)
        case 2:
            // 五個煙火，從左到右發射
            createFirework(xMovement: movementAmount, x: leftEdge, y: 384-100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: 384-50)
            createFirework(xMovement: movementAmount, x: leftEdge, y: 384)
            createFirework(xMovement: movementAmount, x: leftEdge, y: 384+50)
            createFirework(xMovement: movementAmount, x: leftEdge, y: 384+100)
        case 3:
            // 五個煙火，從右到左發射
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
        default:
            break
        }
           
    }
    
    /** Create一個移動的煙火。
     * 1.xMovement為煙火移動的終點x座標，
     * ex.如果設為0，煙火會垂直向上移動。
     * 2.x與y為煙火的出現起點位置。
     */
    func createFirework(xMovement: CGFloat, x: Int, y: Int){
        // 1.Create一個SKNode作為煙火的容器
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        // 2.Create一個煙火SKSpriteNode
        let firework = SKSpriteNode(imageNamed: "rocket")
        /** colorBlendFactor為設定color與texture混合的方式，詳見document
         *  預設的背景色為白色，因此如果colorBlendFactor設為0.5
         *  .color設為紅色時，會是白色與紅色的中間色(約粉紅色)
         */
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        // 3.設定煙火的顏色
        if let color = [UIColor.cyan, UIColor.green, UIColor.red].randomElement(){
            firework.color = color
        }
        
        // 4.Create一個UIBezierPath表示煙火的路徑
        let path = UIBezierPath()
        path.move(to: .zero)
        // y設計為1000會使煙火都向上發射
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        // 5.Create一個SKAction，請node跟著path移動
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        // 6.Create一個煙火後面的SKEmitterNode
        if let emitter = SKEmitterNode(fileNamed: "fuse"){
            // 設計fuse在煙火node的下方(y為-22)
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        // 7.將本煙火node放入Array中，並加入Scene
        fireworks.append(node)
        addChild(node)
    }
    
    // 將點選到的煙火改為白色
    func checkTouches(_ touches: Set<UITouch>){
        guard let touch = touches.first else { return }
        // 取得被User觸及的位置
        let location = touch.location(in: self)
        
        /** 取得被點按到的node
         * 此處應注意，nodes(at)傳回來的是SKNode型態的陣列，
         * 我們要把它轉型為SKSpriteNode，才可以更改他的colorBlendFactor。
         */
        let nodesAtPoint = nodes(at: location)
        
        /** 注意！for case let為新的用法！2022.10.27
         */
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            /** 此處我們要檢查所有的firework，
             * 如果先前有其他的firework已經被點選過，
             * 檢查他的顏色是否與現在點選的一樣。
             * 如果不一樣，
             * 要將他們的顏色都改回來，並且取消"selected"的狀態，名稱改回"firework"。
             *
             * 此處我們稱呼為parent是因為當時設計一個煙火時，
             * 是由一個SKSpriteNode與SKEmitter所組成一個SKNode。
             */
            for parent in fireworks {
                // 確認煙火SKSpriteNode存在
                guard let firework = parent.children.first as? SKSpriteNode else { continue }
                
                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    
    // 每個frame檢查是否需要將firework從遊戲中移除
    override func update(_ currentTime: TimeInterval) {
        /** 此種寫法導致在fireworks還沒被產生前，
         * fireworks[0] 會 index out of range。
         */
//        guard let y = fireworks[0].children.first?.position.y , y > 900 else { return }
        
        /** 此處應注意，
         * 要將元素從array中刪除時，
         * 應從array的尾端逐一移除，而非前端。
         * 原因是，從前端移除時，後一元素會往前遞補。
         * 詳見教材:
         * https://www.hackingwithswift.com/read/20/3/swipe-to-select
         */
        for (index, node) in fireworks.enumerated().reversed(){
            // 確認煙火位置已經高於900
            if node.position.y > 900 {
                fireworks.remove(at: index)
                node.removeFromParent()
            }
        }
    }
    
}
