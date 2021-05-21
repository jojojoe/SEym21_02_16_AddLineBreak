//
//  ALFontManager.swift
//  ALBymAddLineBreak
//
//  Created by JOJO on 2021/5/18.
//

import UIKit

class ALFontManager: NSObject {
    
    let regular_low = "abcdefghijklmnopqrstuvwxyz"
    let regular_up = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let bold_low = "𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘁𝘂𝘃𝘄𝘅𝘆𝘇"
    let bold_up = "𝗔𝗕𝗖𝗗𝗘𝗙𝗚𝗛𝗜𝗝𝗞𝗟𝗠𝗡𝗢𝗣𝗤𝗥𝗦𝗧𝗨𝗩𝗪𝗫𝗬𝗭"
    let italic_low = "𝒶𝒷𝒸𝒹𝑒𝒻𝑔𝒽𝒾𝒿𝓀𝓁𝓂𝓃𝑜𝓅𝓆𝓇𝓈𝓉𝓊𝓋𝓌𝓍𝓎𝓏"
    let italic_up = "𝒜𝐵𝒞𝒟𝐸𝐹𝒢𝐻𝐼𝒥𝒦𝐿𝑀𝒩𝒪𝒫𝒬𝑅𝒮𝒯𝒰𝒱𝒲𝒳𝒴𝒵"
    
    static let `default` = ALFontManager()
    
    func processReplaceText(contentStr: String, targetType: ALBymTextFontStyle) -> String {
        var resultStr = ""
        
        contentStr.charactersArray.forEach {[weak self] item in
            
            guard let `self` = self else {return}
            if targetType == .regular {
                if self.bold_low.charactersArray.contains(item) {
                    if let index = self.bold_low.charactersArray.firstIndex(of: item) {
                        let char = self.regular_low.charactersArray[index]
                        resultStr.append(char)
                    }
                } else if self.bold_up.charactersArray.contains(item) {
                    if let index = self.bold_up.charactersArray.firstIndex(of: item) {
                        let char = self.regular_up.charactersArray[index]
                        resultStr.append(char)
                    }
                } else if self.italic_low.charactersArray.contains(item) {
                    if let index = self.italic_low.charactersArray.firstIndex(of: item) {
                        let char = self.regular_low.charactersArray[index]
                        resultStr.append(char)
                    }
                } else if self.italic_up.charactersArray.contains(item) {
                    if let index = self.italic_up.charactersArray.firstIndex(of: item) {
                        let char = self.regular_up.charactersArray[index]
                        resultStr.append(char)
                    }
                } else {
                    resultStr.append(item)
                }
            } else if targetType == .bold {
                if self.regular_low.charactersArray.contains(item) {
                    if let index = self.regular_low.charactersArray.firstIndex(of: item) {
                        let char = self.bold_low.charactersArray[index]
                        resultStr.append(char)
                    }
                } else if self.regular_up.charactersArray.contains(item) {
                    if let index = self.regular_up.charactersArray.firstIndex(of: item) {
                        let char = self.bold_up.charactersArray[index]
                        resultStr.append(char)
                    }
                } else if self.italic_low.charactersArray.contains(item) {
                    if let index = self.italic_low.charactersArray.firstIndex(of: item) {
                        let char = self.bold_low.charactersArray[index]
                        resultStr.append(char)
                    }
                } else if self.italic_up.charactersArray.contains(item) {
                    if let index = self.italic_up.charactersArray.firstIndex(of: item) {
                        let char = self.bold_up.charactersArray[index]
                        resultStr.append(char)
                    }
                } else {
                    resultStr.append(item)
                }
            } else if targetType == .italic {
                if self.regular_low.charactersArray.contains(item) {
                    if let index = self.regular_low.charactersArray.firstIndex(of: item) {
                        let char = self.italic_low.charactersArray[index]
                        resultStr.append(char)
                    }
                } else if self.regular_up.charactersArray.contains(item) {
                    if let index = self.regular_up.charactersArray.firstIndex(of: item) {
                        let char = self.italic_up.charactersArray[index]
                        resultStr.append(char)
                    }
                } else if self.bold_low.charactersArray.contains(item) {
                    if let index = self.bold_low.charactersArray.firstIndex(of: item) {
                        let char = self.italic_low.charactersArray[index]
                        resultStr.append(char)
                    }
                } else if self.bold_up.charactersArray.contains(item) {
                    if let index = self.bold_up.charactersArray.firstIndex(of: item) {
                        let char = self.italic_up.charactersArray[index]
                        resultStr.append(char)
                    }
                } else {
                    resultStr.append(item)
                }
            }
            
        }
        debugPrint("resultStr = \(resultStr)")
        return resultStr
    }
    
    
    var specialStringList: [String] = [
        "ミ★ 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 ★彡",
        "╰☆☆ 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 ☆☆╮",
        " 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦♡𝓇  °°°·.°·..·°¯°·._.· ",
        "♫♪♩·.¸¸.·♩♪♫ 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 ♫♪♩·.¸¸.·♩♪♫",
        "˜”°•.˜”°• 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 •°”˜.•°”˜",
        "❤꧁ღ⊱♥ 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 ♥⊱ღ꧂❤",
        "ミ💖 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 💖彡",
        "✿.｡.:* ☆::. 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 .::.☆*.:｡.✿",
        "𓂀  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  𓂀",
        "꧁༒༻☬ད  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 ཌ☬༺༒꧂",
        "▌│█║▌║▌║ 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 ║▌║▌║█│▌",
        "ஜ۩۞۩ஜ  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ஜ۩۞۩ஜ",
        "▄︻デ 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 ══━一",
        "¸„.-•~¹°”ˆ˜¨  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ¨˜ˆ”°¹~•-.„¸",
        "➶➶➶➶➶  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ➷➷➷➷➷",
        "▀▄▀▄▀▄  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ▄▀▄▀▄▀",
        "⫷  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ⫸",
        "•.¸♡  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ♡¸.•",
        "↤↤↤↤↤ 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 ↦↦↦↦↦",
        "一═デ︻  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ︻デ═一",
        "▁ ▂ ▄ ▅ ▆ ▇ █  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  █ ▇ ▆ ▅ ▄ ▂ ▁",
        "•.¸♡ 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 ♡¸.•",
        "•.,¸¸,.• 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 •.,¸¸,.•",
        "ıllıllı 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 ıllıllı",
        "░▒▓█  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  █▓▒░",
        "↫↫↫↫↫  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ↬↬↬↬↬",
        "◦•●◉✿  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ✿◉●•◦",
        "·.¸¸.·♩♪♫  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ♫♪♩·.¸¸.·",
        "••¤(`×[¤ 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ¤]×´)¤••",
        "◥꧁ད  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ཌ꧂◤",
        "¯_( ͡° ͜ʖ ͡°)_/¯ 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ¯_( ͡° ͜ʖ ͡°)_/¯",
        "┗(^o^ )┓三 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  三 ┗(^o^ )┓",
        "]|I{•------» 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  «------•}I|[",
        "꧁꫱꧂  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ꧁꫱꧂ ",
        ".•♫•♬• 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 •♬•♫•.",
        "██▓▒­░⡷⠂𝘢𝘥𝘥 𝘭𝘪𝘯𝘦⠐⢾░▒▓██",
        "𒆜 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 𒆜",
        "ᕚ( 𝘢𝘥𝘥 𝘭𝘪𝘯𝘦 )ᕘ",
        "◤✞  𝘢𝘥𝘥 𝘭𝘪𝘯𝘦  ✞◥"
    ]
    
}
