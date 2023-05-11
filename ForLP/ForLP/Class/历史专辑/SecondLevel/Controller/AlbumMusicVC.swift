//
//  AlbumMusicVC.swift
//  ForLP
//
//  Created by Fucker on 2023/4/3.
//

import UIKit

class AlbumMusicVC: GBaseViewController {
    //传过来的专辑信息模型
    var albumModel:AlbumMsgModel?
    
    let AlbumMusicID = "AlbumMusicID"
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //设置标题
        self.setNavigationTitle(titleString: "专辑")
        self.setReturnButton()
        
        self.setupUI()
        self.getMusicData()
    }
    
    //获取数据
    func getMusicData() {
        //中间量
        var dataList = [AlbumMusicModel]()
        //处理数据
        let musicArray = self.albumModel?.AlbumMusics
        for i in 0..<musicArray!.count {
            let musicMsg:Dictionary = musicArray?[i] as! Dictionary<String, Any>
            let musicModel = AlbumMusicModel()
            musicModel.initWithDict(dict: musicMsg)
            dataList.append(musicModel)
        }
        self.musicListArray.addObjects(from: dataList)
        self.musicListTbView.reloadData()
    }
    
    //搭建UI
    func setupUI() {
        var statusBarNavigationBarHeight:CGFloat = 0.0          //导航栏状态栏高度
        
        statusBarNavigationBarHeight = self.g_getStatusBarHeight() + self.g_getNavigationBarHeight()
        
        self.musicListTbView.frame = CGRect(x: 0, y: statusBarNavigationBarHeight, width: Width_Screen, height: Height_Screen-statusBarNavigationBarHeight)
        self.musicListTbView.backgroundColor = UIColor.white
        self.view.addSubview(self.musicListTbView)
        self.musicListTbView.register(MusicListCell.classForCoder(),forCellReuseIdentifier: AlbumMusicID)
    }

//  MARK: -懒加载
    lazy var musicListTbView: UITableView = {
        let musicListTbView = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        musicListTbView.backgroundColor = UIColor.white
        musicListTbView.delegate = self
        musicListTbView.dataSource = self
        musicListTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return musicListTbView
    }()
    
    lazy var musicListArray: NSMutableArray = {
        let musicListArray = NSMutableArray()
        return musicListArray
    }()
}


// MARK: -UITableViewDataSource,UITableViewDelegate
extension AlbumMusicVC:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let musicCell = tableView.dequeueReusableCell(withIdentifier: AlbumMusicID, for: indexPath) as! MusicListCell
        let musicModel = self.musicListArray[indexPath.row]
        musicCell.setupCellData(dataModel: musicModel as! AlbumMusicModel)
        return musicCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerBg = UIView.init(frame: CGRect(x: 0, y: 0, width: Width_Screen, height: 150))
        headerBg.backgroundColor = UIColor.white
        
        let albumLogoShow = UIImageView.init(frame: CGRect(x: Width_Screen/2-50, y:25, width: 100, height: 100))
        albumLogoShow.image = UIImage(named: (self.albumModel?.AlbumLogo)!)
        albumLogoShow.layer.masksToBounds = true
        albumLogoShow.layer.cornerRadius = 50.0
        headerBg.addSubview(albumLogoShow)
        
        return headerBg
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //跳转音乐播放界面
        let musicModel = self.musicListArray[indexPath.row] as! AlbumMusicModel
        let playerVC = MusicPlayerVC()
        playerVC.hidesBottomBarWhenPushed = true
        playerVC.musicMsgModel = musicModel
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
}


