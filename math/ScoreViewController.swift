//
//  ScoreViewController.swift
//  math
//
//  Created by Gabriel Tan on 2/6/15.
//  Copyright (c) 2015 Gabriel Tan. All rights reserved.
//

import UIKit
    
class ScoreViewController: UIViewController {
        
        let databaseName = "math.db"
        var databasePath = NSString()
        
        var scores: [UILabel]!
        
        @IBOutlet weak var score1: UILabel!
        @IBOutlet weak var score2: UILabel!
        @IBOutlet weak var score3: UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "blackboard.jpg")!.drawInRect(self.view.bounds)
            
            var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            self.view.backgroundColor = UIColor(patternImage: image)
            
            
            let filemgr = NSFileManager.defaultManager()
            let dirPaths =
            NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                .UserDomainMask, true)
            
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
            
            scores = [score1, score2, score3]
            getHighScores()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func shouldAutorotate() -> Bool {
            return true
        }
        
        override func supportedInterfaceOrientations() -> Int {
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
            } else {
                return Int(UIInterfaceOrientationMask.All.rawValue)
            }
        }
        
        override func prefersStatusBarHidden() -> Bool {
            return true
        }
        
        func getHighScores() {
            let scoreDB = FMDatabase(path: databasePath)
            
            if scoreDB.open() {
                let querySQL = "SELECT SCORE FROM SCORES ORDER BY SCORE DESC"
                let results:FMResultSet? = scoreDB.executeQuery(querySQL, withArgumentsInArray: nil)
                var pos = 0
                while results?.next() == true && pos < 3 {
                    scores[pos].text = results?.stringForColumn("score")
                    pos = pos + 1
                }
                while pos < 3 {
                    scores[pos].text = "-"
                    pos = pos + 1
                }
                scoreDB.close()
            } else {
                println("Error: \(scoreDB.lastErrorMessage())")
            }
        }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
