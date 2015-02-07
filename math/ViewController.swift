//
//  ViewController.swift
//  math
//
//  Created by Gabriel Tan on 1/21/15.
//  Copyright (c) 2015 Gabriel Tan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let databaseName:NSString = "math.db"
    var databasePath = NSString()
    
    let baseConditions: UInt32 = 4
    let baseRange: UInt32 = 10
    
    var prevVal: Int!
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
    var timer: NSTimer!
    var timerSpeed: Int!
    var currLevel: Int!

    let startSpeed = 2
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var top: UILabel!
    @IBOutlet weak var bottom: UILabel!
    @IBOutlet weak var right: UILabel!
    @IBOutlet weak var left: UILabel!
    @IBOutlet weak var condLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerBar: UIImageView!
    
    func initScene() {
        scoreVal = 0
        vals = [0, 0, 0, 0]
        currLevel = 0
        alive = true
        running = true
//        timerBar.image = UIImage(named: "timerBar")
//        timerBar.frame = CGRect(x: 45, y: 90, width: 240, height: 30)
        timerSpeed = startSpeed
        update()
    }
    
    func timeUpdate() {
        if running == true {
            let barWidth = Int(timerBar.frame.width)
            if barWidth > 0 {
                timerBar.frame = CGRect(x: 45, y: 90, width: barWidth - timerSpeed, height: 30)
            } else {
                alive = false
                update()
            }
            if barWidth < 80 {
                timerBar.backgroundColor = UIColor.redColor()
            }
        }

    }
    
    func update() {
        // 0: Odd, 1: Even, 2: Square, 3: Prime, 4: Divisible by 3, 5: Divisible by 7, 6: Divisible by 11, 7: Divisble by 13, 8: Divisible by 17, 9: Divisible by 19
        if running == true {
            currLevel = Int(scoreVal / 50)
            timerSpeed = startSpeed + currLevel
            
            if alive == false {
                stateLabel.text = "You are dead"
                stateLabel.textColor = UIColor.redColor()
                running = false
                self.addScore(prevVal)
            } else {
                prevVal = scoreVal
                condition = Int(arc4random_uniform(baseConditions + currLevel))
                answerPos = Int(arc4random_uniform(3))
                
                for pos in 0...3 {
                    vals[Int(pos)] = Int(arc4random_uniform(baseRange + 5 * currLevel))
                }
                
                switch(condition) {
                case 1:
                    condLabel.text = "Even"
                    if !isMultiple(vals[answerPos] + scoreVal, i: 2) {
                        vals[answerPos] = vals[answerPos] + 1
                    }
                case 2:
                    condLabel.text = "Square"
                    vals[answerPos] = addToSquare(scoreVal)
                case 3:
                    condLabel.text = "Prime"
                    vals[answerPos] = addToPrimeNumber(scoreVal)
                case 4:
                    condLabel.text = "Multiple of 3"
                    vals[answerPos] = addToMultiple(scoreVal, i: 3)
                case 5:
                    condLabel.text = "Multiple of 5"
                    vals[answerPos] = addToMultiple(scoreVal, i: 5)
                case 6:
                    condLabel.text = "Multiple of 7"
                    vals[answerPos] = addToMultiple(scoreVal, i: 7)
                case 7:
                    condLabel.text = "Multiple of 11"
                    vals[answerPos] = addToMultiple(scoreVal, i: 11)
                default:
                    condLabel.text = "Odd"
                    if isMultiple(vals[answerPos] + scoreVal, i: 2) {
                        vals[answerPos] = vals[answerPos] + 1
                    }
                }
                top.text = "\(vals[0])"
                bottom.text = "\(vals[1])"
                right.text = "\(vals[2])"
                left.text = "\(vals[3])"
                score.text = "\(scoreVal)"
                stateLabel.text = ""
                timerBar.frame = CGRect(x: 45, y: 90, width: 240, height: 30)
                timerBar.backgroundColor = UIColor.greenColor()
            }
        }
        

    }
    
    func checkStatus() {
        switch(condition) {
        case 1:
            if !isMultiple(scoreVal, i: 2) {alive = false}
        case 2:
            if !isSquareNumber(scoreVal) {alive = false}
        case 3:
            if !isPrimeNumber(scoreVal) {alive = false}
        case 4:
            if !isMultiple(scoreVal, i: 3) {alive = false}
        case 5:
            if !isMultiple(scoreVal, i: 5) {alive = false}
        case 6:
            if !isMultiple(scoreVal, i: 7) {alive = false}
        case 7:
            if !isMultiple(scoreVal, i: 11) {alive = false}
        default:
            if isMultiple(scoreVal, i: 2) {alive = false}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initScene()
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "blackboard.jpg")!.drawInRect(self.view.bounds)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.04, target: self, selector: Selector("timeUpdate"), userInfo: nil, repeats: true)
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        
        databasePath = docsDir.stringByAppendingPathComponent(databaseName)
        
        if !filemgr.fileExistsAtPath(databasePath) {
            
            let scoreDB = FMDatabase(path: databasePath)
            
            if scoreDB == nil {
                println("Error: \(scoreDB.lastErrorMessage())")
            }
            
            if scoreDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS SCORES (ID INTEGER PRIMARY KEY AUTOINCREMENT, SCORE INTEGER)"
                if !scoreDB.executeStatements(sql_stmt) {
                    println("Error: \(scoreDB.lastErrorMessage())")
                }
                scoreDB.close()
            } else {
                println("Error: \(scoreDB.lastErrorMessage())")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
        timerBar.frame = CGRect(x: 45, y: 90, width: 240, height: 30)
    }
    
    func isSquareNumber(i: Int) -> Bool {
        return Int(sqrt(Float(i))) * Int(sqrt(Float(i))) == i
    }
    
    func addToSquare(i: Int) -> Int {
        var j: Int
        j = i + 1
        while !isSquareNumber(j) {
            j = j + 1
        }
        return j - i
    }
    
    func isPrimeNumber(i: Int) -> Bool {
        if i == 1 {
            return false
        } else if i < 4 {
            return true
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
    
    func addToPrimeNumber(i: Int) -> Int {
        var j: Int
        j = i + 1
        while !isPrimeNumber(j) {
            j = j + 1
        }
        return j - i
    }
    
    func isMultiple(score: Int, i: Int) -> Bool {
        return score % i == 0
    }
    
    func addToMultiple(score: Int, i: Int) -> Int {
        return i - score % i
    }
    
    func addScore(score: Int) {
        let scoreDB = FMDatabase(path: databasePath)
        
        if scoreDB.open() {
            let insertSQL = "INSERT INTO SCORES (SCORE) VALUES (\(score))"
            let result = scoreDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
            
            if !result {
                println("Error: \(scoreDB.lastErrorMessage())")
            }
        } else {
            println("Error: \(scoreDB.lastErrorMessage())")
        }
    }

}

