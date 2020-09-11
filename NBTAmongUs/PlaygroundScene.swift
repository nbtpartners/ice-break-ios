//
//  PlaygroundScene.swift
//  NBTAmongUs
//
//  Created by okmin lee on 2020/09/11.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import SpriteKit

class PlaygroundScene: SKScene {
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0

    let player = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 40))
    override init(size: CGSize) {
        super.init(size: size)

        self.backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        player.speed = 5
        addChild(player)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
    }
    
    func movePlayer(velocity: CGPoint, angle: CGFloat) {
        let prePlayerPosition = player.position
        moveSprite(player, velocity: velocity)
    }
    
    func moveSprite(_ sprite: SKNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt)*player.speed, y: velocity.y * CGFloat(dt)*player.speed)
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }
    
    func amountToMove(velocity: CGPoint) -> CGPoint {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt)*player.speed, y: velocity.y * CGFloat(dt)*player.speed)
        return CGPoint(x: player.position.x + amountToMove.x, y: player.position.y + amountToMove.y)
    }
    
    func handleOtherPlayers(_ user: User) {
        for child in children {
            if child.name == user.uid.rawValue {
                child.position.x = CGFloat(user.x)
                child.position.y = CGFloat(user.y)
                return
            }
        }
        
        let otherPlayer = SKSpriteNode(color: .black, size: CGSize(width: 40, height: 40))
        otherPlayer.name = user.uid.rawValue
        otherPlayer.position.x = CGFloat(user.x)
        otherPlayer.position.y = CGFloat(user.y)
        addChild(otherPlayer)
    }
}
