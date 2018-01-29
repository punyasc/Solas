//
//  Tagger.swift
//  Solas
//
//  Created by Punya Chatterjee on 12/5/17.
//  Copyright © 2017 Punya Chatterjee. All rights reserved.
//

import Foundation

class Tagger {
    var tags:[String] = ["People In Your Industry Are Checking In",
        "People Your Age Are Checking In",
        "Chloe R. and Sydney H. Have Checked In",
        "Alex B. Just Checked In",
        "Sayuri S. Just Checked In",
        "Punya C. Just Checked In",
        "Yanyan T. and James L. Have Checked In",
        "Andrew B. Just Checked In",
        "Sam P. and Nishtha T. Have Checked In",
        "29 People Have Checked In",
        "52 People Have Checked In",
        "73 People Have Checked In",
        "21 People Have Checked In",
        "15 People Have Checked In",
        "You Checked In Here Last Saturday Night",
        "Always Popular On Saturday Night",
        "Also Trending Last Saturday Night",
        "12867 People Have Checked In This Month"]
    var max:Int
    
    init(max:Int) {
        self.max = max
    }
    
    func shuffleAndReturn() -> [String] {
        var tagsCopy = tags
        var shuffled = [String]()
        for i in 0..<tagsCopy.count
        {
            let rand = Int(arc4random_uniform(UInt32(tagsCopy.count)))
            
            shuffled.append(tagsCopy[rand])
            
            tagsCopy.remove(at: rand)
        }
    
        var ret:[String] = []
        for i in 0..<max {
            ret.append(shuffled[i])
        }
        return ret
    }
    
    
}

