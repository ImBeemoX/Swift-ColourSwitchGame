//
//  GameScene.swift
//  ColourSwitch
//
//  Created by Beemo on 7/9/19.
//  Copyright © 2019 Wang Yichuan. All rights reserved.
//

import SpriteKit


enum PlayColours{
    static let colours = [
       UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
       UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
       UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
       UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchStates: Int{
    case red, yellow, green, blue
}

class GameScene: SKScene {
    
    var colourSwitch: SKSpriteNode!
    var switchState = SwitchStates.red
    var currentColorIndex: Int?
    
    var score = 0
    let scoreLabel = SKLabelNode(text: "0")
    
    override func didMove(to view: SKView) {
        layoutScene()
        setupPhysics()
    }
    
    func setupPhysics(){
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        colourSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colourSwitch.name = "Switch"
        colourSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colourSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colourSwitch.size.height)
        
        colourSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colourSwitch.size.height/2)
        colourSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colourSwitch.physicsBody?.isDynamic = false
        addChild(colourSwitch)
        
        //Score
        scoreLabel.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 60)
        scoreLabel.fontSize = 44
        
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    func spawnBall(){
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColours.colours[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        
        ball.size = CGSize(width: 30.0, height: 30.0)
        ball.position = CGPoint(x: frame.midX, y: frame.maxY - 30.0)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none

        addChild(ball)
    }
   
    
    func turnWheel(){
        if let newState = SwitchStates(rawValue: switchState.rawValue + 1){
            switchState = newState
        }else{
            switchState = .red
        }
        
        colourSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    func gameOver(){
        print("GameOver!")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
    
}



extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory{
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node
                as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode{
                if currentColorIndex == switchState.rawValue{
                    print("Correct!")
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                        ball.removeFromParent()
                        self.score += 1
                        self.scoreLabel.text = String(self.score)
                        self.spawnBall()
                    })
                }else{
                    gameOver()
                    self.spawnBall()
                }
            }
            
        }
        
        
    }
}
