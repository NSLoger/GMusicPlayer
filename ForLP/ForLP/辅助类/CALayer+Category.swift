//
//  CALayer+Category.swift
//  ForLP
//
//  Created by Fucker on 2023/4/17.
//

import UIKit

extension CALayer {
    //MARK: -暂停动画
    func pauseAnimation() {
        /**
         将当前时间转换为layer时间，并将speed设置为0，以暂停动画。
         将timeOffset设置为pausedTime，以便在恢复动画时可以正确计算时间。
         */
        let pauseTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pauseTime
    }
    
    //MARK: -恢复动画
    func resumeAnimation() {
        /**
         将暂停时间转换为layer时间，并将speed设置为1.0，以恢复动画。
         将timeOffset设置为0，并将beginTime设置为当前时间减去暂停时间，以便在恢复动画时可以正确计算时间。
         */
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
}
