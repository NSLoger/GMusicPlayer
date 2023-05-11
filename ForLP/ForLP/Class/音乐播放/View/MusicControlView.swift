//
//  MusicControlView.swift
//  ForLP
//
//  Created by Fucker on 2023/4/11.
//

import UIKit



class MusicControlView: UIView {
    //block
    typealias PreviousClickBlock = () ->()
    typealias PlaySuspendClickBlock = (_ isSuspend:Bool) ->()
    typealias NextClickBlock = () -> ()
    
    var previousBlock:PreviousClickBlock?
    var playSuspendBlock:PlaySuspendClickBlock?
    var nextBlock:NextClickBlock?
    
    var previousBtn : UIButton!     //上一曲
    var playBtn : UIButton!         //播放按钮
    var nextBtn : UIButton!         //下一曲
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    MARK: -创建UI
    func setupUI() {
        let selfFrame = self.bounds
        //上一曲
        previousBtn = UIButton(type: UIButton.ButtonType.custom)
        previousBtn.frame = CGRect(x: (selfFrame.size.width-40-(30+40+30))/2, y: selfFrame.size.height/2-15, width: 30, height: 30)
        previousBtn.setBackgroundImage(UIImage(named: "previousMusicLogo"), for: UIControl.State.normal)
        previousBtn.addTarget(self, action: #selector(previousClick), for: UIControl.Event.touchUpInside)
        self.addSubview(previousBtn)
        
        //播放
        playBtn = UIButton(type: UIButton.ButtonType.custom)
        playBtn.frame = CGRect(x: CGRectGetMaxX(previousBtn.frame)+20, y: selfFrame.size.height/2-20, width: 40, height: 40)
        playBtn.setBackgroundImage(UIImage(named: "suspendMusicLogo"), for: UIControl.State.normal)
        playBtn.setBackgroundImage(UIImage(named: "playMusicLogo"), for: UIControl.State.selected)
        playBtn.addTarget(self, action: #selector(playAndSuspendClick), for: UIControl.Event.touchUpInside)
        self.addSubview(playBtn)
        
        //下一曲
        nextBtn = UIButton(type: UIButton.ButtonType.custom)
        nextBtn.frame = CGRect(x: CGRectGetMaxX(playBtn.frame)+20, y: selfFrame.size.height/2-15, width: 30, height: 30)
        nextBtn.setBackgroundImage(UIImage(named: "nextMusitLogo"), for: UIControl.State.normal)
        nextBtn.addTarget(self, action: #selector(nextClick), for: UIControl.Event.touchUpInside)
        self.addSubview(nextBtn)
        
    }
    
//    MARK: -按钮点击事件
    @objc func previousClick() {
        if self.previousBlock != nil {
            self.previousBlock!()
        }
    }
    
    @objc func playAndSuspendClick(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        
        if self.playSuspendBlock != nil {
            self.playSuspendBlock!(sender.isSelected)
        }
    }
    
    @objc func nextClick() {
        if self.nextBlock != nil {
            self.nextBlock!()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension MusicControlView {
    func changeStatus(isSelected:Bool) {
        playBtn!.isSelected = isSelected
    }
}
