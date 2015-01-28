//
//  ViewController.swift
//  math
//
//  Created by Gabriel Tan on 1/21/15.
//  Copyright (c) 2015 Gabriel Tan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let numberOfConditions: UInt32 = 4
    
    var scoreVal: Int!
    var topVal: Int!
    var botVal: Int!
    var rightVal: Int!
    var leftVal: Int!
    var vals: [Int]!
    var answerPos: Int!
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
        vals = [0, 0, 0, 0]
        alive = true
        running = true
        update()
    }
    
    func update() {
        // 0: Odd, 1: Even, 2: Square, 3: Prime, 4: Divisible by 3, 5: Divisible by 7, 6: Divisible by 11, 7: Divisble by 13, 8: Divisible by 17, 9: Divisible by 19
        if running == true {
            condition = Int(arc4random_uniform(numberOfConditions))
            answerPos = Int(arc4random_uniform(3))
            
            for pos in 0...3 {
                vals[Int(pos)] = Int(arc4random_uniform(10))
            }

            switch(condition) {
            case 1:
                condLabel.text = "Even"
                if !isEvenNumber(vals[answerPos] + scoreVal) {
                    vals[answerPos] = vals[answerPos] + 1
                }
            case 2:
                condLabel.text = "Square"
                vals[answerPos] = nextSquare(scoreVal) - scoreVal
            case 3:
                condLabel.text = "Prime"
                vals[answerPos] = nextPrimeNumber(scoreVal) - scoreVal
            default:
                condLabel.text = "Odd"
                if !isOddNumber(vals[answerPos] + scoreVal) {
                    vals[answerPos] = vals[answerPos] + 1
                }
            }

            top.text = "\(vals[0])"
            bottom.text = "\(vals[1])"
            right.text = "\(vals[2])"
            left.text = "\(vals[3])"
            score.text = "\(scoreVal)"
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
            if !isEvenNumber(scoreVal) {alive = false}
        case 2:
            if !isSquareNumber(scoreVal) {alive = false}
        case 3:
            if !isPrimeNumber(scoreVal) {alive = false}
        default:
            if !isOddNumber(scoreVal) {alive = false}
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
        scoreVal = scoreVal + vals[0]
        checkStatus()
        update()

    }
    @IBAction func swipeDown(sender: UISwipeGestureRecognizer) {
        scoreVal = scoreVal + vals[1]
        checkStatus()
        update()

    }
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        scoreVal = scoreVal + vals[2]
        checkStatus()
        update()

    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        scoreVal = scoreVal + vals[3]
        checkStatus()
        update()

    }

    @IBAction func Restart(sender: UIButton) {
        initScene()
    }
    
    func isEvenNumber(i: Int) -> Bool {
        if scoreVal % 2 == 0 {return true}; return false
    }
    
    func isOddNumber(i: Int) -> Bool {
        if scoreVal % 2 == 1 {return true}; return false
    }
    
    func isSquareNumber(i: Int) -> Bool {
        if Int(sqrt(Float(i))) * Int(sqrt(Float(i))) == i {return true}; return false
    }
    
    func nextSquare(i: Int) -> Int {
        var j: Int
        j = i
        while !isSquareNumber(j) {
            j = j + 1
        }
        return j
    }
    
    func isPrimeNumber(i: Int) -> Bool {
        if i < 4 {
            return false
        }
        var root = sqrt(Double(i))
        var max = floor(root)
        for j in 2...Int(max) {
            if i % j == 0 {
                return false
            }
        }
        return true
    }
    
    func nextPrimeNumber(i: Int) -> Int {
        var j: Int
        j = i
        while !isPrimeNumber(j) {
            j = j + 1
        }
        return j
    }

}

