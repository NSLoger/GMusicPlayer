//
//  UIImage+Category.swift
//  ForLP
//
//  Created by Fucker on 2023/4/17.
//

import UIKit

//MARK: -扩展
extension UIImage {
    //颜色转图片
    static func imageWithColor(color: UIColor, size: CGSize, cornerRadius: CGFloat) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
