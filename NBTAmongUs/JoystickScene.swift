//
//  JoystickScene.swift
//  BgdIOS
//
//  Created by leeokmin on 2019/11/22.
//  Copyright © 2019 mosaicfac. All rights reserved.
//

import SpriteKit

protocol JoystickSceneDelegate: NSObject {
    func joystickMoved(velocity: CGPoint, angle: CGFloat)
    func joystickEnded()
}

class JoystickScene: SKScene {
    let joystick = TLAnalogJoystick(withDiameter: 75)

    weak var joystickSceneDelegate: JoystickSceneDelegate?

    override init(size: CGSize) {
        super.init(size: size)

        self.backgroundColor = .clear
        setJoystick()
        handleJoystick()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setJoystick() {
        joystick.name = "joystick"

//        joystick.handleImage = UIImage(named: "joystick")!
        joystick.handle.diameter = 35
//        joystick.baseImage = UIImage(named: "joystickBase")!
        joystick.base.diameter = 89.7
        
        joystick.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        addChild(joystick)
    }

    func handleJoystick() {
        joystick.on(TLAnalogJoystickEventType.move) { (stick) in
            self.joystickSceneDelegate?.joystickMoved(velocity: stick.velocity, angle: stick.angular)
        }

        joystick.on(.end) { (_) in
            self.joystickSceneDelegate?.joystickEnded()
        }
    }

}
