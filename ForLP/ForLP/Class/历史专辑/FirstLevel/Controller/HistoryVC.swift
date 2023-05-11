//
//  HistoryVC.swift
//  ForLP
//
//  Created by Fucker on 2023/3/23.
//

import UIKit

class HistoryVC: GBaseViewController {
    
    var typeChangeBtn:UIButton!         //更改布局按钮
    var collectionFlowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
   
    let historyCellID:String = "HistoryCellID"
    let historyCollectionCellID:String = "historyCollectionReuse"
      
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //设置标题
        self.setNavigationTitle(titleString: "历史专辑")
       
        self.setupUI()
        self.getLocalData()
    }
    
    //读取本地数据
    func getLocalData() {
        //中间量
        var dataList = [AlbumMsgModel]()
        //本地内容路径
        let plistPath = Bundle.main.path(forResource: "HistoryMessage", ofType: "plist")
        //获取内容数组
        let msgArray = NSArray(contentsOfFile: plistPath!)!
        //循环处理
        for i in 0..<msgArray.count {
            let dict:Dictionary = msgArray[i] as! Dictionary<String, Any>
            let model = AlbumMsgModel()
            //字典到模型
            model.initWithDict(dict: dict)
            dataList.append(model)
        }
        
        //更新列表
        self.historyListArray.addObjects(from: dataList)
        self.historyListTbView.reloadData()
    }
      
    func setupUI() {
        var statusBarNavigationBarHeight:CGFloat = 0.0          //导航栏状态栏高度
        var tabbarHeight:CGFloat = 0.0
        
        statusBarNavigationBarHeight = self.g_getStatusBarHeight() + self.g_getNavigationBarHeight()
        tabbarHeight = self.g_getTabbarHeight()
        
        //两种状态切换
        typeChangeBtn = UIButton(type: UIButton.ButtonType.custom)
        typeChangeBtn.frame = CGRect(x: Width_Screen-50, y: statusBarNavigationBarHeight-40, width: 30, height: 30)
        typeChangeBtn.setBackgroundImage(UIImage.init(named: "HistoryColLogo"), for: UIControl.State.normal)
        typeChangeBtn.setBackgroundImage(UIImage.init(named: "HistoryListLogo"), for: UIControl.State.selected)
        typeChangeBtn.addTarget(self, action:#selector(changeTypeClick), for: UIControl.Event.touchUpInside)
        navigationBgView?.addSubview(typeChangeBtn)
        
        //列表
        self.historyListTbView.frame = CGRect(x: 0, y: statusBarNavigationBarHeight, width: Width_Screen, height: Height_Screen-statusBarNavigationBarHeight-tabbarHeight)
        self.view.addSubview(self.historyListTbView)
        self.historyListTbView.isHidden = false
        
        //瀑布流
        self.historyCollectionView.frame = self.historyListTbView.frame
        self.view.addSubview(self.historyCollectionView)
        self.historyCollectionView.isHidden = true
    }
    
    // MARK: -方法实现
    @objc func changeTypeClick(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        self.historyListTbView.isHidden = sender.isSelected
        self.historyCollectionView.isHidden = !sender.isSelected
    }
    
    // MARK: - 懒加载
    lazy var historyCollectionView:UICollectionView = {
        collectionFlowLayout.itemSize = CGSize(width: Width_Screen/2-0.5, height: 200)
        collectionFlowLayout.scrollDirection = .vertical
        collectionFlowLayout.minimumLineSpacing = 0.5
        collectionFlowLayout.minimumInteritemSpacing = 0.5
        
        let historyCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: self.collectionFlowLayout)
        historyCollectionView.backgroundColor = UIColor.white
        historyCollectionView.delegate = self
        historyCollectionView.dataSource = self
        historyCollectionView.register(HistoryCollectionCell.self, forCellWithReuseIdentifier: historyCollectionCellID)
        
        return historyCollectionView
    }()
    
    lazy var historyListTbView:UITableView = {
        let historyListTbView = UITableView.init(frame: .zero, style: UITableView.Style.plain)
        historyListTbView.backgroundColor = UIColor.white
        historyListTbView.delegate = self
        historyListTbView.dataSource = self
        historyListTbView.separatorStyle = UITableViewCell.SeparatorStyle.none
        historyListTbView.register(HistoryListCell.classForCoder(),forCellReuseIdentifier: historyCellID)
        return historyListTbView
    }()
   
    lazy var historyListArray:NSMutableArray = {
        let historyListArray = NSMutableArray()
        return historyListArray
    }()
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension HistoryVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let historyCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: historyCollectionCellID, for: indexPath) as! HistoryCollectionCell
        let dataModel = self.historyListArray[indexPath.row]
        historyCollectionCell.setupCollectionViewCellData(dataModel: dataModel as! AlbumMsgModel)
        return historyCollectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumModel = self.historyListArray[indexPath.row] as! AlbumMsgModel
        let musicListVC = AlbumMusicVC()
        musicListVC.hidesBottomBarWhenPushed = true
        musicListVC.albumModel = albumModel
        self.navigationController?.pushViewController(musicListVC, animated: true)
    }
}

// MARK: - UITableViewDelegate,UITableViewDataSource
extension HistoryVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyListArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let historyCell = tableView.dequeueReusableCell(withIdentifier: historyCellID, for: indexPath) as! HistoryListCell
        let dataModel = self.historyListArray[indexPath.row]
        historyCell.setupCellData(dataModel: dataModel as! AlbumMsgModel)
        return historyCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumModel = self.historyListArray[indexPath.row] as! AlbumMsgModel
        let musicListVC = AlbumMusicVC()
        musicListVC.hidesBottomBarWhenPushed = true
        musicListVC.albumModel = albumModel
        self.navigationController?.pushViewController(musicListVC, animated: true)
    }
    
}

