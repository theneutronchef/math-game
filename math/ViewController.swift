//
//  ViewController.swift
//  math
//
//  Created by Gabriel Tan on 1/21/15.
//  Copyright (c) 2015 Gabriel Tan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var scoreVal: Int!
    var topVal: Int!
    var botVal: Int!
    var rightVal: Int!
    var leftVal: Int!
    var prevCondition: Int!
    var condition: Int!
    var alive: Bool!
    var running: Bool!
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var top: UILabel!
    @IBOutlet weak var bottom: UILabel!
    @IBOutlet weak var right: UILabel!
    @IBOutlet weak var left: UILabel!
    @IBOutlet weak var condLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    func initScene() {
        scoreVal = 0
        alive = true
        running = true
        update()
    }
    
    func update() {
        // 0: Odd, 1: Even, 2: Square, 3: Prime, 4: Divisible by 3, 5: Divisible by 7, 6: Divisible by 11, 7: Divisble by 13, 8: Divisible by 17, 9: Divisible by 19
        if running == true {
            condition = Int(arc4random_uniform(3))
            topVal = Int(arc4random_uniform(10))
            botVal = Int(arc4random_uniform(10))
            rightVal = Int(arc4random_uniform(10))
            leftVal = Int(arc4random_uniform(10))
            top.text = "\(topVal)"
            bottom.text = "\(botVal)"
            right.text = "\(rightVal)"
            left.text = "\(leftVal)"
            score.text = "\(scoreVal)"
            switch(condition) {
            case 1:
                condLabel.text = "Even"
            case 2:
                condLabel.text = "Square"
            default:
                condLabel.text = "Odd"
            }
            
            if alive == false {
                stateLabel.text = "You are dead"
                running = false
            } else {
                stateLabel.text = ""
            }
        }
        

    }
    
    func checkStatus() {
        switch(condition) {
        case 1:
            if scoreVal % 2 != 0 {alive = false}
        case 2:
            if Int(sqrt(Float(scoreVal))) * Int(sqrt(Float(scoreVal))) != scoreVal {alive = false}
        default:
            if scoreVal % 2 != 1 {alive = false}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initScene()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipeUp(sender: UISwipeGestureRecognizer) {
        scoreVal = scoreVal + topVal
        checkStatus()
        update()

    }
    @IBAction func swipeDown(sender: UISwipeGestureRecognizer) {
        scoreVal = scoreVal + botVal
        checkStatus()
        update()

    }
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        scoreVal = scoreVal + rightVal
        checkStatus()
        update()

    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        scoreVal = scoreVal + leftVal
        checkStatus()
        update()

    }

    @IBAction func Restart(sender: UIButton) {
        initScene()
    }

}

