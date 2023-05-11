//
//  UIColor+Hex.swift
//  ForLP
//
//  Created by Fucker on 2023/4/7.
//

import UIKit

/**
 参考:https://www.jianshu.com/p/21ea94362319
 */

//MARK: -扩展
extension UIColor {
    //随机色
    class var colorWithRandom: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
    
    
    //16进制颜色
    class func colorWithHex(hexString:String,alpha:CGFloat) -> UIColor {
        //删除字符串中的空格
        let formateColorString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        //判断处理后的字符串
        if formateColorString.count < 6 {
            return UIColor.clear
        }
        
        //截取末6位的值作为有效值
        let targetRange = formateColorString.index(formateColorString.endIndex, offsetBy: -6)
        let resultString = String(formateColorString[targetRange...])
        //获取RGB
        let RStartIndex = resultString.index(resultString.startIndex, offsetBy: 0)
        let REndIndex = resultString.index(RStartIndex, offsetBy: 2)
        let RString = resultString[RStartIndex..<REndIndex]
        
        let GEndIndex = resultString.index(REndIndex, offsetBy: 2)
        let GString = resultString[REndIndex..<GEndIndex]
        
        
        let BEndIndex = resultString.index(GEndIndex, offsetBy: 2)
        let BString = resultString[GEndIndex..<BEndIndex]
        
        //处理三色值
        var rValue : UInt32 = 0x0
        var gValue : UInt32 = 0x0
        var bValue : UInt32 = 0x0
        
        Scanner(string: String(RString)).scanHexInt32(&rValue)
        Scanner(string: String(GString)).scanHexInt32(&gValue)
        Scanner(string: String(BString)).scanHexInt32(&bValue)
        
        
        return UIColor(red: CGFloat(rValue)/255.0, green: CGFloat(gValue)/255.0, blue: CGFloat(bValue)/255.0, alpha: alpha)
    }
}

