//
//  GameScene.swift
//  Project23
//
//  Created by 曲奕帆 on 2022/10/28.
//

import AVFoundation
import SpriteKit

/** 某一個enemy出現時，它是炸彈的機率
 * never，一定是企鵝
 * always，一定是炸彈
 */
enum ForceBomb{
    case never, always, random
}

/** 一組enemy出現可能的樣式
 * oneNoBomb：一隻企鵝，沒有炸彈
 * twoWithOneBomb：兩隻企鵝，一個炸彈
 */
enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

class GameScene: SKScene {
    
    // 得分標籤
    var gameScore: SKLabelNode!
    
    // 得分
    var score = 0{
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }

    // 剩餘命數的圖片Array
    var livesImages = [SKSpriteNode]()
    
    // 玩家本局遊戲還有幾命
    var lives = 3
    
    
    /** 在玩家畫過一刀時，
     * 設計兩道畫筆，讓路徑看起來有光刀的感覺。
     */
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    
    // 紀錄玩家手劃過的路徑點
    var activeSlicePoints = [CGPoint]()
    
    // 是否正在播放劃刀音效
    var isSwooshSoundActive = false
    
    // 在畫面中的Enemy
    var activeEnemies = [SKSpriteNode]()
    
    // 炸彈音效
    var bombSoundEffect: AVAudioPlayer?
    
    // 在場上沒有物品後，準備擲出下一輪物品的時間
    var popupTime = 0.9
    
    /** 遊戲每一輪擲出物品，我們設計成幾種固定的型態，
     * 一輪稱為一個sequence。
     * 設計在enum SequenceType: CaseIterable中。
     * 而此處我們設計成Array，遊戲會根據這個Array的排序，一輪一輪擲出物品。
     */
    var sequence = [SequenceType]()
    // 目前遊戲進行到的輪數
    var sequencePosition = 0
    // 當擲出型態為chain時，每個物品被擲出的時間間隔
    var chainDelay = 3.0
    //
    var nextSequenceQueued = true
    
    /** 遊戲是否已結束。
     *  遊戲中紙條件:
     *  1. 玩家三命已經用完
     *  2. 玩家切到炸彈
     */
    var isGameEnded = false
    
    /** didMove()類似UIKit的ViewDidLoad()
     *
     */
    override func didMove(to view: SKView) {
        // 設定背景圖片
        createBackground()
        
        // 設定重力場，物品才會向下掉落
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        //
        physicsWorld.speed = 0.85
        
        // 設定得分Label
        createScore()
        
        // 設定表示命數的叉叉
        createLives()
        
        //
        createSlices()
        
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0...1000{
            if let nextSequence = SequenceType.allCases.randomElement(){
                sequence.append(nextSequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){[weak self] in
            self?.tossEnemies()
        }
    }
    
    // 設定背景圖片
    func createBackground(){
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    // 設定得分Label
    func createScore(){
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.fontSize = 48
        // 放置於畫面左下角
        gameScore.horizontalAlignmentMode = .left
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
        
        addChild(gameScore)
    }
    
    // 設定表示命數的叉叉
    func createLives(){
        for i in 0...2{
            let live = SKSpriteNode(imageNamed: "sliceLife")
            live.position = CGPoint(x: 1024 - 40 - i * 70, y: 720)
            addChild(live)
            
            livesImages.append(live)
        }
    }
    
    // 設定玩家劃過的筆觸物件
    func createSlices(){
        // 下方黃色路徑畫筆
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        addChild(activeSliceBG)
        
        // 上方紅色路徑畫筆
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        activeSliceFG.strokeColor = UIColor.red
        activeSliceFG.lineWidth = 5
        addChild(activeSliceFG)
    }
    
    
    /** 說明
     * 在User用手劃下一刀時，動作分為三個部分。
     * 1.touchesBegan，
     * 點擊開始，為開始滑動的第一瞬間，系統回報該瞬間的位置點，只有一個點。
     * 2.touchesMoved，
     * 正在滑動，為開始滑動的過程，系統將大量回報位置點，將回報數十數百點。
     * 3.touchesEnded，點節結束
     * 點節結束，為User手離開螢幕的時間點，系統回報該瞬間的位置點，只有一個點。
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        activeSlicePoints.append(location)
        
        // 重新依照新的路徑點陣列([CGPoint])繪製筆刀
        redrawActiveSlice()
        
        /** 由於可能發生activeSliceFG與activeSliceBG正在執行Action時，
         * 玩家就開始劃了第二刀。
         * 因此此處設計每次開始時，都移除Actions。
         */
        activeSliceFG.removeAllActions()
        activeSliceBG.removeAllActions()
        
        activeSliceFG.alpha = 1
        activeSliceBG.alpha = 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameEnded == false else { return }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        // 重新繪製路徑
        redrawActiveSlice()
        
        // 如果目前沒有在播放炸彈音效，播放炸彈音效
        if !isSwooshSoundActive{
            playSwooshSound()
        }
        
        // 取得所有在路徑上的node
        let nodesAtPoint = nodes(at: location)
        
        /** for迴圈搭配case let的用法說明:
         *  只有在符合條件時才會執行本圈。
         *  此處為，若node是一個SKSpriteNode才會執行。
         */
        for case let node as SKSpriteNode in nodesAtPoint{
            
            // 碰到的是企鵝，執行消除企鵝
            if node.name == "enemy"{
                // 在觸碰到企鵝的點，顯示sliceHitEnemy動畫
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy"){
                    emitter.position = node.position
                    addChild(emitter)
                }
                
                // 移除這個node的名稱，這個node就不可以再被劃第二次
                node.name = ""
                // 設定企鵝不可因碰撞移動
                node.physicsBody?.isDynamic = false
                
                // 企鵝執行消失動畫
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.sequence([scaleOut, fadeOut])
                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)
                
                // 得分
                score += 1
                
                if let index = activeEnemies.firstIndex(of: node){
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
               
            // 觸碰到的事炸彈，引爆炸彈
            } else if node.name == "bomb" {
               
                guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                
                // 在觸碰到炸彈的點，顯示sliceHitBomb動畫
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb"){
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                
                // 移除這個node的名稱，這個node就不可以再被劃第二次
                node.name = ""
                //
                bombContainer.physicsBody?.isDynamic = false
                
                // 執行縮小消失動畫
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.sequence([scaleOut, fadeOut])
                let seq = SKAction.sequence([group, .removeFromParent()])
                
                bombContainer.run(seq)
                
                // 將炸彈從activeEnemies移除
                if let index = activeEnemies.firstIndex(of: bombContainer){
                    activeEnemies.remove(at: index)
                }
                
                // 播放音效
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                // 劃到炸彈，遊戲結束
                endGame(triggeredByBomb: true)
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 玩家在手指離開螢幕時，0.25秒內動畫fadeout
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    
    /** 遊戲結束。
     * 傳入是否因為User切到炸彈而結束遊戲
     *
     */
    func endGame(triggeredByBomb: Bool){
        // 確認遊戲尚未被設定為結束
        guard isGameEnded == false else { return }
        isGameEnded = true
        
        // 物體速度皆改為0
//        physicsWorld.speed = 0
        // 玩家無法再繼續操作畫面
        isUserInteractionEnabled = false
        
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        // 若是畫到炸彈導致遊戲結束，將叉叉全部改為紅叉叉
        if triggeredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        
    }
    
    // 播放畫刀音效
    func playSwooshSound(){
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        // 播放音效，於播放結束後isSwooshSoundActive改回false
        run(swooshSound){ [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    
    
    // 繪製玩家劃過的路徑
    func redrawActiveSlice(){
        // 如果小於兩個點，將無法繪製一條線
        if activeSlicePoints.count < 2 {
            activeSliceFG.path = nil
            activeSliceBG.path = nil
            return
        }
        
        // 設計只繪出User滑動到的最後12個點
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        // 建立畫筆路徑
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceFG.path = path.cgPath
        activeSliceBG.path = path.cgPath
    }
    
    // create單一Enemy
    func createEnemy(forceBomb: ForceBomb = .random){
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...6)
        
        if forceBomb == .never{
            enemyType = 1
        } else if forceBomb == .always{
            enemyType = 0
        }
        
        if enemyType == 0 {
            // 產生炸彈
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            // 每次在播放前，都確認前一個音效已經播放完畢
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            
            /** 播放炸彈引線的音效。
             * 由於SKAction.run無法「停止播放」音效，因此此處使用AVAudioPlayer。
             */
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf"){
                if let sound = try? AVAudioPlayer(contentsOf: path){
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            
            // 加入炸彈的火花
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse"){
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
            
        } else {
            // 產生企鵝
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
        }
        
        // 設定產生enemy的位置
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition
        
        // 角速度
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        // 水平速度(X)
        let randomXVelocity: Int
        /** 此處設計若物品被初始的位置，
         * 在畫面的左半側，它就會被往右邊投擲。
         * 在畫面的右半側，他就會被往左邊投擲。
         * 才不會造成物體從左邊出現右往左邊丟，玩家根本沒機會切的問題。
         */
        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...15)
        }
        
        // 垂直速度(Y)
        let randomYVelocity = Int.random(in: 24...32)
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        // 移動速度
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        // 自旋角速度
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        // 設定不會與其他物品相撞
        enemy.physicsBody?.collisionBitMask = 0
        
        // 遊戲畫面中加入此enemy
        addChild(enemy)

        /** 將此enemy加入「還在場上的Enemies」陣列
         *  enemy將會在它離開畫面或是被玩家切除時，從陣列中被移除。
         */
        activeEnemies.append(enemy)
    }
    
    // 玩家減一命
    func subtractLife(){
        lives -= 1
        
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        
        var life: SKSpriteNode
        
        // 本次減命後，剩下兩命
        if lives == 2 {
            life = livesImages[0]
        // 本次減命後，剩下一命
        } else if lives == 1 {
            life = livesImages[1]
        // 本次減命後，沒命了
        } else {
            life = livesImages[2]
            // 遊戲結束，並非炸彈觸發
            endGame(triggeredByBomb: false)
        }
        // 設定為減命圖片(紅叉叉)
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        
        // 設計一個叉叉的動畫，讓減命的行為比較明顯
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
    }
    
    // update會在每一個frame更新時被呼叫
    // 檢查是否仍有炸彈在畫面中，如果沒有，停止音效的播放。
    override func update(_ currentTime: TimeInterval) {
        // 檢查是否有enemy已經離開遊戲視線範圍，應移除
        if activeEnemies.count > 0 {
            /** 移除node應從array的後端移除
             * 注意！在操作for迴圈[index, 元素]時，
             * array先呼叫.enumerated()與先呼叫.reversed()，
             * 會有不同的結果。應小心使用。
             */
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeFromParent()
                    
                    // 如果沒有劃到企鵝，少一命
                    if node.name == "enemy" {
                        node.name = ""
                        subtractLife()
                    
                    // 如果沒有畫到炸彈，將炸彈移除
                    } else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                    }
                    
                    // 將該Enemy從「在場上的enemies」陣列中移除
                    activeEnemies.remove(at: index)
                }
            }
        // 如果場上已經沒有enemy，準備送出下一輪enemy
        } else {
            if !nextSequenceQueued{
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime){ [weak self] in
                    self?.tossEnemies()
                }
                nextSequenceQueued = true
            }
        }
        
        // 目前炸彈數量
        var bombCount = 0
        // 若「在場上的enemies」有包含炸彈，break
        for node in activeEnemies {
            if node.name == "bombContainer"{
                bombCount += 1
                break
            }
        }
        
        // 當畫面中沒有炸彈時，停止音效播放
        if bombCount == 0 {
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
    }
    
    // 投擲一輪
    func tossEnemies() {
        guard isGameEnded == false else { return }
        
        popupTime *= 0.991
        chainDelay *= 0.99
        // 遊戲每輪的物理速度會加快，增加遊戲難度
        physicsWorld.speed *= 1.02
        
        // 取得本輪要投擲enemy的樣式
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
        case .one:
            createEnemy()
        case .twoWithOneBomb:
            createEnemy(forceBomb: .always)
            createEnemy(forceBomb: .never)
        case .two:
            createEnemy()
            createEnemy()
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
        case .chain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)){ [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)){ [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)){ [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)){ [weak self] in
                self?.createEnemy()
            }
        case .fastChain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)){ [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)){ [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)){ [weak self] in
                self?.createEnemy()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)){ [weak self] in
                self?.createEnemy()
            }
        }
        
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
}
