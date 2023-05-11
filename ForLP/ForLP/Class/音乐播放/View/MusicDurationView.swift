//
//  MusicDurationView.swift
//  ForLP
//
//  Created by Fucker on 2023/4/17.
//

import UIKit

class MusicDurationView: UIView {
    //block
    typealias SliderValueChangeBlock = (_ sliderValue:Float) ->()
    typealias SliderDidEndBlock = () -> ()
    
    var changeProgressBlock:SliderValueChangeBlock?
    var changeDidEndBlock:SliderDidEndBlock?
    
    var durationSlider:UISlider!            //进度slider展示
    var currentTimeShow:UILabel!            //当前播放时间展示
    var durationTimeShow:UILabel!           //总时间展示
    
    /**
     这里需要加入默认值，否则会在init方法里提示
     Property 'self.sliderCurrentValue' not initialized at super.init call
     Property 'self.sliderTotleValue' not initialized at super.init call
     具体原因是：https://www.jianshu.com/p/636f82f4a372
     
     在 init 中 有四个阶段的安全检查, 这里违背了第四个检查
     // 初始化 编译的过程的四个安全检查
     // 1. 在调用父类初始化之前 必须给子类特有的属性设置初始值, 只有在类的所有存储属性状态都明确后, 这个对象才能被初始化
     // 2. 先调用父类的初始化方法, 再 给从父类那继承来的属性初始化值, 不然这些属性值 会被父类的初始化方法覆盖
     // 3. convenience 必须先调用 designated 初始化方法, 再 给属性初始值. 不然设置的属性初始值会被 designated 初始化方法覆盖
     // 4. 在第一阶段完成之前, 不能调用实类方法, 不能读取属性值, 不能引用self
     错误: Property not initialized at super.init call
     违反了 安全检查第1条.
     */
    var sliderCurrentValue:Float = 0.0
    var sliderTotleValue:Float = 0.0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
        self.setupDurationUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //搭建UI
    func setupDurationUI() {
        //self的总高度40，宽度为屏幕宽度
        
        currentTimeShow = UILabel.init(frame: CGRect(x: 5, y: 13.0, width: 60, height: 14.0))
        currentTimeShow.text = "0:00"
        currentTimeShow.textColor = UIColor.white
        currentTimeShow.textAlignment = NSTextAlignment.right
        currentTimeShow.font = UIFont.systemFont(ofSize: 13.0)
        self.addSubview(currentTimeShow)
        
        durationSlider = UISlider.init(frame: CGRect(x: 70, y: 13.0, width: Width_Screen-140, height: 14.0))
        let pointImg : UIImage = UIImage.imageWithColor(color: UIColor.white, size: CGSize(width: 10.0, height: 10.0), cornerRadius: 5.0)
        durationSlider.setThumbImage(pointImg, for: UIControl.State.normal)
        durationSlider.minimumValue = 0.0
        durationSlider.value = 0.0
        durationSlider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        self.addSubview(durationSlider)
        
        durationTimeShow = UILabel.init(frame: CGRect(x: Width_Screen-65, y: 13.0, width: 60, height: 14.0))
        durationTimeShow.text = "0:00"
        durationTimeShow.textColor = UIColor.white
        durationTimeShow.textAlignment = NSTextAlignment.left
        durationTimeShow.font = UIFont.systemFont(ofSize: 13.0)
        self.addSubview(durationTimeShow)
    }

    //滑动中
    @objc func sliderValueChange(_ sender: UISlider) {
        if self.changeProgressBlock != nil {
            self.changeProgressBlock!(sender.value)
        }
    }
    
}


extension MusicDurationView {
    func setDefaultData() {
        currentTimeShow.text = "0:00"
        durationSlider.value = 0.0;
        durationTimeShow.text = "0:00"
        
    }
    
    func setMusicDurationData(currentTime:Float,totleTime:Float) {
        let cT = Int(currentTime)
        let cString = self.formateTime(inputTime: cT)
        currentTimeShow.text = cString
        
        let tT = Int(totleTime)
        let tString = self.formateTime(inputTime: tT)
        durationTimeShow.text = tString
        
        durationSlider.value = currentTime
        durationSlider.maximumValue = totleTime
        sliderCurrentValue = currentTime
        sliderTotleValue = totleTime
    }
    
    //格式化‘时分秒’
    func formateTime(inputTime:Int) -> String {
        var resultTime:String = ""
        
        let HH = inputTime / 3600
        let MM = (inputTime - (3600 * HH)) / 60
        let SS = inputTime - (HH * 3600 + MM * 60)
        
        if HH > 0 {
            if HH < 10 {
                resultTime += "0\(resultTime):"
            }else {
                resultTime += "\(HH):"
            }
        }
        
        if MM > 0 {
            if MM < 10 {
                resultTime += "0\(MM):"
            }else{
                resultTime += "\(MM):"
            }
        }else{
            resultTime += "00:"
        }
        
        if SS > 0 {
            if SS < 10 {
                resultTime += "0\(SS)"
            }else{
                resultTime += "\(SS)"
            }
        }else{
            resultTime += "00"
        }
        
        return resultTime
    }
}
