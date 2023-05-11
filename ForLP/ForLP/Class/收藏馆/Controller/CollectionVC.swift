//
//  CollectionVC.swift
//  ForLP
//
//  Created by Fucker on 2022/12/23.
//

import UIKit

class CollectionVC: GBaseViewController {
    
    let userDefaults = UserDefaults.standard
    let collectionListID = "collectionListID"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //每次进入时都获取并刷新列表
        collectionListArray = self.getCollectionMusicMsg()
        self.collectionListTbView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //设置标题
        self.setNavigationTitle(titleString: "收藏馆")
        
        self.setupUI()
        
    }
    
    func setupUI() {
        var statusBarNavigationBarHeight:CGFloat = 0.0          //导航栏状态栏高度
        var tabbarHeight:CGFloat = 0.0
        
        statusBarNavigationBarHeight = self.g_getStatusBarHeight() + self.g_getNavigationBarHeight()
        tabbarHeight = self.g_getTabbarHeight()
        
        //收藏列表
        self.collectionListTbView.frame = CGRect(x: 0, y: statusBarNavigationBarHeight, width: Width_Screen, height: Height_Screen-statusBarNavigationBarHeight-tabbarHeight)
        self.view.addSubview(self.collectionListTbView)
        self.collectionListTbView.register(CollectionListCell.classForCoder(), forCellReuseIdentifier: collectionListID)
    }
    
    //获取收藏数据
    func getCollectionMusicMsg() -> NSMutableArray{
        var collectionMusicArray = NSMutableArray()
        if (userDefaults.object(forKey: collectionMusicKey) != nil) {
            let savedArray = userDefaults.object(forKey: collectionMusicKey) as! Array<Any>
            
            for i in 0..<savedArray.count {
                let musicDict : Dictionary = savedArray[i] as! Dictionary<String, Any>
                let musicModel = AlbumMusicModel()
                musicModel.initWithDict(dict: musicDict)
                collectionMusicArray.add(musicModel)
            }
        }
        return collectionMusicArray
    }
    
//    MARK: -懒加载
    lazy var collectionListTbView: UITableView = {
        let collectionListTbView = UITableView(frame: CGRectZero, style: UITableView.Style.plain)
        collectionListTbView.backgroundColor = UIColor.white
        collectionListTbView.delegate = self
        collectionListTbView.dataSource = self
        collectionListTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return collectionListTbView
    }()
    
    lazy var collectionListArray: NSMutableArray = {
        let collectionListArray = NSMutableArray()
        return collectionListArray
    }()

}

extension CollectionVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: collectionListID, for: indexPath) as! CollectionListCell
        let musicModel = self.collectionListArray[indexPath.row] as! AlbumMusicModel
        cell.setupCellData(musicModel: musicModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //跳转音乐播放界面
        let musicModel = self.collectionListArray[indexPath.row] as! AlbumMusicModel
        let playerVC = MusicPlayerVC()
        playerVC.hidesBottomBarWhenPushed = true
        playerVC.musicMsgModel = musicModel
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
}
