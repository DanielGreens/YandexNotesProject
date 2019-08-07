//
//  NoteExtension.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 02/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import Foundation
import UIKit

extension Note {
    
    var json : [String: Any] {
        get {
            var dict : [String: Any] = [:]
            dict["uid"] = self.uid
            dict["title"] = self.title
            dict["content"] = self.content
            dict["color"] = self.color == .white ? nil : self.color.rgba
            //            1 - обычная важность.
            dict["importance"] = self.importance.rawValue == 1 ? nil : self.importance.rawValue
            
            if let date = self.selfDestructionDate?.timeIntervalSince1970 {
                dict["selfDestructionDate"] = Int(date)
            }
            
            return dict
        }
    }
    
    
    static func parse (json: [String: Any]) -> Note? {
        guard
            let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String else {
                return nil
        }
        
        return Note(uid: uid,
                    title: title,
                    content: content,
                    color: json["color"] == nil ? .white : UIColor.rgbaToUIColor(json["color"] as! [CGFloat]),
                    importance: Importance.init(rawValue: (json["importance"] as? Int ?? 1))!,
                    selfDestructionDate: json["selfDestructionDate"] == nil ? nil : Date.init(timeIntervalSince1970: Double(json["selfDestructionDate"] as! Int)))
    }
    
}

extension UIColor {
    var rgba: [CGFloat] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [red, green, blue, alpha]
    }
    
    
    static func rgbaToUIColor (_ rgba: [CGFloat]) -> UIColor {
        let color = UIColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])
        return color
    }
    
    var brightness: CGFloat? {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        guard self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return nil
        }
        
        return brightness
    }
    
    func serialize() -> String {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            let redGrid = String(format:"%02X", Int(red * 255))
            let greenGrid = String(format:"%02X", Int(green * 255))
            let blueGrid = String(format:"%02X", Int(blue * 255))
            
            return "#\(redGrid)\(greenGrid)\(blueGrid)"
        }
}
