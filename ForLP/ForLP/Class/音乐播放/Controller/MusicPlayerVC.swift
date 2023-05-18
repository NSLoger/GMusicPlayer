//
//  MusicPlayerVC.swift
//  ForLP
//
//  Created by Fucker on 2023/4/4.
//

import UIKit
import AVFoundation
import MediaPlayer


/**
 参考
 音乐播放：https://www.hangge.com/blog/cache/detail_1669.html
         https://www.jianshu.com/p/1ab430c82b93
 */

class MusicPlayerVC: GBaseViewController {
    var musicMsgModel:AlbumMusicModel?    //播放歌曲内容
    
    let userDefaults = UserDefaults.standard
    
    var playerBgView:UIView!              //播放背景图片
    var backReBtn:UIButton!               //新返回按钮
    var collectBtn:UIButton!              //收藏按钮
    var collectStatusLogo:UIImageView!    //收藏logo
    //默认展示内容背景
    var animationBgView:UIView!           //音乐播放动画背景
    var musicLogoImgV:UIImageView!        //音乐logo
    var durationBgView:MusicDurationView! //音乐进度
    //播放器相关
    var player:AVPlayer!
    //歌词展示内容背景
    var musicWordsBgView:UIView?
    //操作台
    var controlBgView:MusicControlView! 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //添加播放结束的通知
        NotificationCenter.default.addObserver(self, selector: #selector(musicDidFinishPlay), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        //告知系统接受远程响应事件，并注册成为第一响应者
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //移除通知
        NotificationCenter.default.removeObserver(self)
        
        //停止接受远程响应事件
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.hideNavigationView()
        
        //搭建UI
        self.setupUI()
        
        
    }
    
//    MARK: -UI搭建
    func setupUI() {
        playerBgView = UIView.init(frame: CGRect(x: 0, y: 0, width: Width_Screen, height: Height_Screen))
        playerBgView.backgroundColor = UIColor.lightGray
        self.view.addSubview(playerBgView)
        
        //返回按钮
        let statusBarHeight = self.g_getStatusBarHeight()
        let navigationBarHeight = self.g_getNavigationBarHeight()
        
        backReBtn = UIButton(type: UIButton.ButtonType.custom)
        backReBtn.frame = CGRectMake(0, statusBarHeight, navigationBarHeight, navigationBarHeight)
        backReBtn.addTarget(self, action: #selector(backClick), for: UIControl.Event.touchUpInside)
        self.view.addSubview(backReBtn)
        
        let backArrowLogo = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30));
        backArrowLogo.image = UIImage(named: "DownArrowWhite")
        backReBtn!.addSubview(backArrowLogo)
        backArrowLogo.center = CGPoint(x: backReBtn!.bounds.size.width/2, y: backReBtn!.bounds.size.height/2)
            
        //收藏按钮
        collectBtn = UIButton(type: UIButton.ButtonType.custom)
        collectBtn.frame = CGRect(x: Width_Screen-navigationBarHeight-10, y: statusBarHeight, width: navigationBarHeight, height: navigationBarHeight)
        collectBtn.addTarget(self, action: #selector(collectClick), for: UIControl.Event.touchUpInside)
        self.view.addSubview(collectBtn)
        
        collectStatusLogo = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        collectStatusLogo.center = CGPoint(x: collectBtn.bounds.size.width/2, y: collectBtn.bounds.size.height/2)
        collectBtn.addSubview(collectStatusLogo)
        //判别是否已经收藏过
        var isCollected = false
        
        let collectionMusicArray = self.getCollectionMusicMsg()
        for i in 0..<collectionMusicArray.count {
            let collectionMsg:Dictionary = collectionMusicArray[i] as! Dictionary<String, Any>
            
            let collectionModel = AlbumMusicModel()
            collectionModel.initWithDict(dict: collectionMsg)
            if collectionModel.MusicName == musicMsgModel?.MusicName {
                isCollected = true
            }
        }
        
        if isCollected == true {
            collectBtn.tag = 10000
            collectStatusLogo.image = UIImage(named: "Tabbar2_select")
        }else {
            collectBtn.tag = 10001
            collectStatusLogo.image = UIImage(named: "CollectNotLogo")
        }
        
        //播放器内容展示
        self.setupPlayerView()
        
        //歌词内容展示
        self.setupMusicWordsView()
        
        //操作台
        self.setupControlView()
    }
    
    //播放音乐
    func playMusic() {
        //播放器
        let musicNameString = musicMsgModel?.MusicName
        var musicPath = ""
        musicPath = Bundle.main.path(forResource: musicNameString, ofType: "mp3") ?? Bundle.main.path(forResource: "Papercut", ofType: "mp3")!
        let musicUrl = URL(fileURLWithPath: musicPath)
        let playerItem = AVPlayerItem(url: musicUrl as URL)
        //播放器
        player = AVPlayer(playerItem: playerItem)
        player.play()
        
        //总时长和播放过程中时间和进度的变化
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            
            let durationT : CMTime = (self.player.currentItem?.asset.duration)!
            let dSecond : Float64 = CMTimeGetSeconds(durationT)
            //适配后台播放
            if self.player.currentItem?.status == .readyToPlay && self.player.rate != 0 {
                let currentT = CMTimeGetSeconds(self.player!.currentTime())
                self.durationBgView.setMusicDurationData(currentTime: Float(currentT), totleTime: Float(dSecond))
                
                //设置后台播放显示信息
                self.setPlaybackInfo(playbackStatus: 1)
            }
            
        }
    }
    
    //操作台
    func setupControlView() {
        //进度
        durationBgView = MusicDurationView.init(frame: CGRect(x: 0, y: Height_Screen-140, width: Width_Screen, height: 40))
        self.view.addSubview(durationBgView)
        
        durationBgView.changeProgressBlock = {
            (sliderValue:Float) -> () in
            self.player.seek(to: CMTime(seconds: Double(sliderValue), preferredTimescale: 1))
        }
        
        //操作
        controlBgView = MusicControlView(frame: CGRect(x: 0, y: Height_Screen-100, width: Width_Screen, height: 100))
        controlBgView.backgroundColor = UIColor.white
        self.view.addSubview(controlBgView)
        
        controlBgView.previousBlock = {
            print("上一曲")
            
            let musicNameString = self.musicMsgModel?.MusicName
            var musicPath = ""
            musicPath = Bundle.main.path(forResource: musicNameString, ofType: "mp3") ?? Bundle.main.path(forResource: "Papercut", ofType: "mp3")!
            let musicUrl = URL(fileURLWithPath: musicPath)
            let playerItem = AVPlayerItem(url: musicUrl as URL)
            self.player.replaceCurrentItem(with: playerItem)
        }

        controlBgView.playSuspendBlock = {
            (isSuspend:Bool) -> () in
            if isSuspend == true {
                print("暂停")
                self.player.pause()
                
                self.musicLogoImgV.layer.pauseAnimation()
                
                //后台播放信息进度暂停
                self.setPlaybackInfo(playbackStatus: 0)
            } else {
                print("播放")
                self.player.play()
                
                self.musicLogoImgV.layer.resumeAnimation()
            }
        }
        
        controlBgView.nextBlock = { [self] in
            print("下一曲")
            
            let musicNameString = self.musicMsgModel?.MusicName
            var musicPath = ""
            musicPath = Bundle.main.path(forResource: musicNameString, ofType: "mp3") ?? Bundle.main.path(forResource: "Papercut", ofType: "mp3")!
            let musicUrl = URL(fileURLWithPath: musicPath)
            let playerItem = AVPlayerItem(url: musicUrl as URL)
            self.player.replaceCurrentItem(with: playerItem)
        }
        
        
    }
    
    //歌词内容
    func setupMusicWordsView() {
        let statusBarHeight = self.g_getStatusBarHeight()
        let navigationBarHeight = self.g_getNavigationBarHeight()
        
        musicWordsBgView = UIView.init(frame: CGRect(x: 0, y: 0, width: animationBgView.bounds.size.width, height: animationBgView.bounds.size.height))
        musicWordsBgView?.backgroundColor = UIColor.colorWithHex(hexString: "#666666", alpha: 1.0)
        playerBgView?.addSubview(musicWordsBgView!)
        //默认不显示
        musicWordsBgView?.isHidden = true
        
        //点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(statusChange))
        musicWordsBgView?.isUserInteractionEnabled = true
        musicWordsBgView?.addGestureRecognizer(tap)
        
        //歌词logo
        let wordsTitle = UILabel(frame: CGRectMake(0, musicWordsBgView!.bounds.size.height/2-7.0, musicWordsBgView!.bounds.size.width, 14.0))
        wordsTitle.text = "歌词"
        wordsTitle.textColor = UIColor.white
        wordsTitle.textAlignment = NSTextAlignment.center
        wordsTitle.font = UIFont.systemFont(ofSize: 14.0)
        musicWordsBgView?.addSubview(wordsTitle)
    }
    
    //播放内容
    func setupPlayerView() {
        let statusBarHeight = self.g_getStatusBarHeight()
        let navigationBarHeight = self.g_getNavigationBarHeight()
        //默认展示内容
        animationBgView = UIView.init(frame: CGRect(x: 0, y: 0, width: Width_Screen, height: playerBgView!.bounds.size.height-100))
        animationBgView.backgroundColor = UIColor.colorWithHex(hexString: "#333333", alpha: 1.0)
        playerBgView!.addSubview(animationBgView)
        //默认显示
        animationBgView.isHidden = false
        
        //点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(statusChange))
        animationBgView.isUserInteractionEnabled = true
        animationBgView.addGestureRecognizer(tap)
        
        //唱片图片
        musicLogoImgV = UIImageView.init(frame: CGRect(x: Width_Screen/2-100, y: statusBarHeight+navigationBarHeight+15, width: 200, height: 200))
        musicLogoImgV.image = UIImage(named: "MusicDefaultLogo")
        animationBgView.addSubview(musicLogoImgV)
        //给logo添加自转动画
        let logoAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        //动画属性
        logoAnimation.fromValue = 0
        logoAnimation.toValue = CGFloat.pi * 2
        logoAnimation.duration = 4.0
        logoAnimation.repeatCount = .infinity
        //为logo添加动画
        musicLogoImgV.layer.add(logoAnimation, forKey: "rotationAnimation")
        
        
        
        //播放音乐
        self.playMusic()
    }
    
    //获取收藏数据
    func getCollectionMusicMsg() -> Array<Any>{
        var collectionMusicArray = NSMutableArray()
        if (userDefaults.object(forKey: collectionMusicKey) != nil) {
            let savedArray = userDefaults.object(forKey: collectionMusicKey) as! Array<Any>
            collectionMusicArray.addObjects(from: savedArray)
        }
        return collectionMusicArray.copy() as! Array<Any>
    }
    
//    MARK: -按钮点击事件
    @objc func statusChange() {
        //歌词-歌曲背景互斥的展示效果
        animationBgView.isHidden = !animationBgView.isHidden
        musicWordsBgView!.isHidden = !musicWordsBgView!.isHidden
    }
    
    @objc func collectClick(sender:UIButton) {
        //收藏按钮
        var collectionMusicArray = self.getCollectionMusicMsg()
        
        if sender.tag == 10000 {
            //取消收藏
            sender.tag = 10001
            collectStatusLogo.image = UIImage(named: "CollectNotLogo")
            
            for i in 0..<collectionMusicArray.count {
                let collectionMsg:Dictionary = collectionMusicArray[i] as! Dictionary<String, Any>
                
                let collectionModel = AlbumMusicModel()
                collectionModel.initWithDict(dict: collectionMsg)
                if collectionModel.MusicName == musicMsgModel?.MusicName {
                    collectionMusicArray.remove(at: i)
                }
            }
        }else{
            //收藏
            sender.tag = 10000
            collectStatusLogo.image = UIImage(named: "Tabbar2_select")
            
            let musicDict:Dictionary = ["MusicName":musicMsgModel!.MusicName]
            collectionMusicArray.insert(musicDict, at: 0)
        }
        //同步本地数据
        userDefaults.set(collectionMusicArray, forKey: collectionMusicKey)
        userDefaults.synchronize()
    }
    
    @objc func backClick() {
        //返回按钮
        self.player.pause()
        self.navigationController?.popViewController(animated: true)
    }
    
//    MARK: -后台播放显示信息
    func setPlaybackInfo(playbackStatus:Int) {
        let mpic = MPNowPlayingInfoCenter.default()
        //专辑封面
        let mySize = CGSize(width: 400, height: 400)
        let albumArt = MPMediaItemArtwork(boundsSize: mySize) { sz in
            return UIImage(named: "MusicDefaultLogo")!
        }
        
        //获取进度
        let position = Double(durationBgView.sliderCurrentValue)
        let duration = Double(durationBgView.sliderTotleValue)
        
        mpic.nowPlayingInfo = [MPMediaItemPropertyTitle:musicMsgModel?.MusicName ?? "未知",
                              MPMediaItemPropertyArtist:"Linkin Park",
                             MPMediaItemPropertyArtwork:albumArt,
            MPNowPlayingInfoPropertyElapsedPlaybackTime:position,
                    MPMediaItemPropertyPlaybackDuration:duration,
                   MPNowPlayingInfoPropertyPlaybackRate:playbackStatus]
    }
    
//    MARK: -通知事件
    @objc func musicDidFinishPlay(playerItemNotification:NSNotification) {
        print("播放完毕")
        //移除通知，更改控制面板状态，更改播放进度数据，暂停唱片动画
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        //更改控制器面板和进度面板状态
        controlBgView.changeStatus(isSelected: true)
        durationBgView.setDefaultData()
        //停止音乐播放'唱片'动画
        self.musicLogoImgV.layer.pauseAnimation()
        
        //重新装配播放下一首
        let musicNameString = self.musicMsgModel?.MusicName
        var musicPath = ""
        musicPath = Bundle.main.path(forResource: musicNameString, ofType: "mp3") ?? Bundle.main.path(forResource: "Papercut", ofType: "mp3")!
        let musicUrl = URL(fileURLWithPath: musicPath)
        let playerItem = AVPlayerItem(url: musicUrl as URL)
        self.player.replaceCurrentItem(with: playerItem)
        self.player.play()
        
        //再次更新控制面板状态，开始唱片动画
        controlBgView.changeStatus(isSelected: false)
        self.musicLogoImgV.layer.resumeAnimation()
        //添加新的通知
        NotificationCenter.default.addObserver(self, selector: #selector(musicDidFinishPlay), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
//    MARK: -重写系统方法
    //后台操作
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else {
            print("无事件")
            return
        }
        
        if event.type == UIEvent.EventType.remoteControl {
            switch event.subtype {
            case .remoteControlTogglePlayPause:
                print("暂停/播放")
            case .remoteControlPreviousTrack:
                print("上一曲")
            case .remoteControlNextTrack:
                print("下一曲")
            case .remoteControlPlay:
                print("播放")
                self.player.play()
                //开始’唱片‘转动
                self.musicLogoImgV.layer.resumeAnimation()
                //更新播放按钮状态
                controlBgView.changeStatus(isSelected: false)
            case .remoteControlPause:
                print("暂停")
                self.player.pause()
                //停止’唱片‘转动
                self.musicLogoImgV.layer.pauseAnimation()
                //更新播放按钮状态
                controlBgView.changeStatus(isSelected: true)
                
                //设置后台播放显示信息
                self.setPlaybackInfo(playbackStatus: 0)
            default:
                break
            }
        }
    }
    
    //是否成为第一响应对象
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
