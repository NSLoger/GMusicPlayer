//
//  HistoryListCell.swift
//  ForLP
//
//  Created by Fucker on 2022/12/27.
//

import UIKit

class HistoryListCell: UITableViewCell {
    //全部属性
    var logoShow:UIImageView?       //左侧logo展示
    var titleShow:UILabel?          //右侧标题展示
    var dateShow:UILabel?           //右侧时间展示
    var separateLine:UIView?        //底部分割线
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        //创建UI
        self.setupUI()
    }
    
    func setupUI() {
        //logo展示
        logoShow = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        logoShow!.backgroundColor = UIColor.black
        self.contentView.addSubview(logoShow!)
        //文字展示
        titleShow = UILabel.init(frame: CGRect(x: 120, y: 37, width: Width_Screen-130, height: 16))
        titleShow!.textColor = UIColor.black
        titleShow!.textAlignment = NSTextAlignment.left
        titleShow!.font = UIFont.systemFont(ofSize: 16.0)
        self.contentView.addSubview(titleShow!)
        //时间
        dateShow = UILabel.init(frame: CGRect(x: 120, y: 66, width: Width_Screen-130, height: 13))
        dateShow!.textColor = UIColor.lightGray
        dateShow!.textAlignment = NSTextAlignment.left
        dateShow!.font = UIFont.systemFont(ofSize: 13.0)
        self.contentView.addSubview(dateShow!)
        //分割线
        separateLine = UIView.init(frame: CGRect(x: 10, y: 119, width: Width_Screen-20, height: 0.5))
        separateLine?.backgroundColor = UIColor.black
        self.contentView.addSubview(separateLine!)
    }
    
    //为cell赋值
    func setupCellData(dataModel:AlbumMsgModel) -> () {
        logoShow?.image = UIImage(named: dataModel.AlbumLogo!)
        titleShow?.text = dataModel.AlbumName!
        dateShow?.text = "发行时间:" + dataModel.AlbumDate!
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

