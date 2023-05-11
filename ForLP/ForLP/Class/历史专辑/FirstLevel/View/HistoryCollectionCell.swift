//
//  HistoryCollectioCell.swift
//  ForLP
//
//  Created by Fucker on 2023/4/26.
//

import UIKit

class HistoryCollectionCell: UICollectionViewCell {
    //全部属性
    var logoShow:UIImageView!       //logo展示
    var titleShow:UILabel!          //标题展示
    var dateShow:UILabel!           //发布时间展示
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //创建UI
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //UI搭建
    func setupUI() {
        self.contentView.backgroundColor = UIColor.white
        
        //logo展示
        logoShow = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        logoShow.backgroundColor = UIColor.black
        self.contentView.addSubview(logoShow)
        //文字展示
        titleShow = UILabel.init(frame: CGRect(x: 0, y: logoShow.bounds.size.height-40, width: logoShow.bounds.size.width, height: 16))
        titleShow.textColor = UIColor.white
        titleShow.textAlignment = NSTextAlignment.center
        titleShow.font = UIFont.systemFont(ofSize: 16.0)
        self.contentView.addSubview(titleShow)
        //时间
        dateShow = UILabel.init(frame: CGRect(x: 0, y: logoShow.bounds.size.height-18, width: logoShow.bounds.size.width, height: 13))
        dateShow.textColor = UIColor.white
        dateShow.textAlignment = NSTextAlignment.center
        dateShow.font = UIFont.systemFont(ofSize: 13.0)
        self.contentView.addSubview(dateShow)
    }
    
    //为cell赋值
    func setupCollectionViewCellData(dataModel:AlbumMsgModel) -> () {
        logoShow.image = UIImage(named: dataModel.AlbumLogo!)
        titleShow.text = dataModel.AlbumName!
        dateShow.text = "发行时间:" + dataModel.AlbumDate!
    }
}
