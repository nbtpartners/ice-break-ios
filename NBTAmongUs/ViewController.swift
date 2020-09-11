//
//  ViewController.swift
//  NBTAmongUs
//
//  Created by okmin lee on 2020/09/11.
//  Copyright © 2020 okmin lee. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var playgroundView: SKView!
    @IBOutlet weak var joystickView: SKView!
    
    private var ref: DatabaseReference!
    var user = User(uid: .ios, x: 0, y: 0, color: "#0000FF")
//    private var user:[String : Any] = ["uid":"ios", "x":0, "y":0, "color": "#0000FF"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
//        let user = User(uid: "ios", x: 0, y: 0, color: "#0000FF")
        
        ref.child("playground/\(user.uid)").setValue(user.makeUpdatingJSON())
        
        let playgroundScene = PlaygroundScene(size: CGSize(width: 1000, height: 1000))
        playgroundView.presentScene(playgroundScene)
        
        let scene = JoystickScene(size: self.joystickView.frame.size)
        scene.joystickSceneDelegate = self
        joystickView.presentScene(scene)
        let refHandle = ref.child("playground").observe(DataEventType.childChanged, with: { (snapshot) in
            guard let postDict = snapshot.value else { return }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: postDict, options: []) else { return }
            guard let changedUser = User.decoder(with: jsonData) else { return }
            guard let scene = self.playgroundView.scene as? PlaygroundScene else { return }
            switch changedUser.uid {
            case .ios: ()
//                scene.player.position = CGPoint(x: changedUser.x, y: changedUser.y)
            default :
                scene.handleOtherPlayers(changedUser)
            }
            
            print(changedUser)
        })


    }
}


extension ViewController: JoystickSceneDelegate {
    func joystickMoved(velocity: CGPoint, angle: CGFloat) {
        guard let scene = self.playgroundView.scene as? PlaygroundScene else { return }
        scene.movePlayer(velocity: velocity, angle: angle)
        user.x = Double(scene.player.position.x)
        user.y = Double(1000 - scene.player.position.y)
        ref.child("playground/\(user.uid)").setValue(user.makeUpdatingJSON())
    }
    
    func joystickEnded() {
        print("ended")
    }
}

