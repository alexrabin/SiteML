//
//  ScanResult.swift
//  SiteML
//
//  Created by Alex Rabin on 4/30/20.
//  Copyright © 2020 Alex Rabin. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ScanResult {
    public private(set) var date : Date = Date()
    public private(set) var allImageLabels : [VisionImageLabel] = [VisionImageLabel]()
    public private(set) var hasLabels = false
    public private(set) var textOCR : String?
    
    public func addTextOCR(text: String){
        textOCR = text
    }
    
    public func setImageLabels(labels: [VisionImageLabel]){
        allImageLabels = labels.filter{
            if let conf = $0.confidence, Float(truncating: conf) > 0.8 {
                return true
            }
            return false
        }
        hasLabels = allImageLabels.count > 0
//           for label in self.allImageLabels{
//               if let conf = label.confidence, Float(truncating: conf) > 0.8{
//                   hasLabels = true
//                   break
//               }
//
//           }
           
       }
    
    /// - Returns: a formatted string of the scan result's date in MMM dd, yyyy hh:mm
    public func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm"
        return dateFormatter.string(from: date)
    }
    
    public func toString() -> String{
        var result = ""
        result += "Date: \(self.getFormattedDate())\n"
        result += "Found Text: \(textOCR != nil)\n"
        if let text = textOCR{
            result += text + "\n"
        }
        result += "Found Image Labels: \(hasLabels)\n"
        if hasLabels {
            for label in self.allImageLabels{
                if let conf = label.confidence, Float(truncating: conf) > 0.8{
                    result += "\(label.text):\(Float(truncating: conf))"
                }
            }
        }
        return result
    }
}
