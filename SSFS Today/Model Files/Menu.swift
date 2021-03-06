//
//  Menu.swift
//  SSFS Today
//
//  Created by Brian Wilkinson on 9/12/17.
//  Copyright © 2017 Brian Wilkinson. All rights reserved.
//

import Foundation

class Menu {
    var menuContents = String()
    
    var shorterMenu = [String]()
    var otherMenu = [String]()
    var differentMenu = [String]()
    var spacesMenu = [String]()
    var aMenu = String()
    
    init() {
        retrieveMenuFromWebsite()
        stripOutXMLfromMenu()
        createTextOnlyMenu()
        convertMenuToString()
    }
    
    func retrieveMenuFromWebsite() {
        if let url = NSURL(string: "https://grover.ssfs.org/menus/word/document.xml") {
            
            do {
                self.menuContents = try String(contentsOf: url as URL)
            } catch {
                print("there was an error.")
            }
        }
    }
    
    func stripOutXMLfromMenu() {
        let newMenu = self.menuContents.components(separatedBy: ">")
        for item in newMenu {
            if item.contains("</w:t") && !item.contains("</w:tc") && !item.contains("</w:tr") && !item.contains("</w:tbl"){
                shorterMenu.append(item)
            }
        }
    }
    
    func createTextOnlyMenu() {
        for item in shorterMenu {
            if item.contains("</w:t") {
                let newString = item.replacingOccurrences(of: "</w:t", with: "")
                otherMenu.append(newString)
            }
            else {
                otherMenu.append(item)
            }
        }
        
        for item in otherMenu {
            if item.contains("&amp;") {
                let newString = item.replacingOccurrences(of: "&amp;", with: "&")
                differentMenu.append(newString)
            }
            else {
                differentMenu.append(item)
            }
        }
    }
    
    func convertMenuToString() {
        for item in differentMenu {
            let newString = String(item)
            aMenu = aMenu + newString
        }
    }
    
    func rangeFromNSRange(nsRange: NSRange, forString str: String) -> Range<String.Index>? {
        let fromUTF16 = str.index(str.startIndex, offsetBy: nsRange.location)
        //let fromUTF16 = str.utf16.startIndex.advanced(by: nsRange.location)
        let toUTF16 = str.index(fromUTF16, offsetBy: nsRange.length)
        //let toUTF16 = fromUTF16.advanced(by: nsRange.length)
        if let from = String.Index(fromUTF16, within: str),
            let to = String.Index(toUTF16, within: str) {
            return from ..< to
        }
        return nil
    }
    
    func getLunch(stringToParse: String, regExText: String) -> String {
        var name: String = ""
        do {
            let regex = try NSRegularExpression(pattern: regExText, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: stringToParse as String, options: [], range: NSMakeRange(0, stringToParse.characters.count))
            if let match = matches.first {
                let range = match.range(at: 1)
                if let swiftRange = rangeFromNSRange(nsRange: range, forString: stringToParse as String) {
                    name = String(stringToParse[swiftRange])
                }
            }
        } catch {
            //regex was bad!
        }
        return name
    }
    
    func getMenuItem(stringToParse: String, regExText: String) -> String {
        var name: String = ""
        do {
            let regex = try NSRegularExpression(pattern: regExText, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: stringToParse as String, options: [], range: NSMakeRange(0, stringToParse.characters.count))
            if let match = matches.first {
                let range = match.range(at: 1)
                if let swiftRange = rangeFromNSRange(nsRange: range, forString: stringToParse as String) {
                    name = String(stringToParse[swiftRange])
                }
            }
        } catch {
            //regex was bad!
        }
        // Puts a comma between the side dishes.
        let newString = name.replacingOccurrences(of: "(?<=[a-z])[A-Z]", with: ", $0", options: .regularExpression)
        return newString
    }
    
}
