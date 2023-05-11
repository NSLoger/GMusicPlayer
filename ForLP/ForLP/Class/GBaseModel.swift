//
//  GBaseModel.swift
//  ForLP
//
//  Created by Fucker on 2023/4/3.
//

import UIKit

/**
 在swift4.0中使用class_copyPropertyList来获取类里面的属性列表，结果发现获取的列表使用为空，count始终为0。
 后来通过查找资料发现是因为swift4.0中继承 NSObject 的 swift class 不再默认 BRIDGE 到 OC，如果我们想要使用的话我们就需要在class前面加上@objcMembers 这么一个关键字
 */
@objcMembers class GBaseModel: NSObject {
    
    override init() {
        super.init()
    }
    //自动获取所有属性并赋值
    func initWithDict(dict:Dictionary<String, Any>) {
        var keys = [String]()
        var count:UInt32 = 0
        let propertyArray = class_copyPropertyList(self.classForCoder, &count)
        
        //获取到所有属性名
        for i in 0..<Int(count) {
            let property = propertyArray![i]
            //获取属性名
            let gName = String(utf8String: property_getName(property))
            keys.append(gName!)
        }
        
        //赋值
        for i in 0..<Int(keys.count) {
            let keyString = keys[i]
            let value = dict[keyString]
            self.setValue(value, forKey: keyString)
        }
        
        free(propertyArray);
    }
}

