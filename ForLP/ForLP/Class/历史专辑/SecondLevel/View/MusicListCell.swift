//
//  MusicListCell.swift
//  ForLP
//
//  Created by Fucker on 2023/4/3.
//

import UIKit

class MusicListCell: UITableViewCell {
    var musicLogo:UIImageView?              //左侧logo
    var musicNameShow:UILabel?              //歌曲名
    var separateLine:UIView?                //分割线
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.setupUI()
    }
    
//  MARK: -UI相关
    func setupUI() {
        musicLogo = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
        musicLogo!.image = UIImage(named: "MusicLogo")
        self.contentView.addSubview(musicLogo!)
        
        musicNameShow = UILabel.init(frame: CGRect(x: 55, y: 23, width: Width_Screen-70, height: 15))
        musicNameShow?.textColor = UIColor.lightGray
        musicNameShow?.textAlignment = NSTextAlignment.left
        musicNameShow?.font = UIFont.systemFont(ofSize: 14.0)
        self.contentView.addSubview(musicNameShow!)
        
        separateLine = UIView.init(frame: CGRect(x: 15, y: 59, width: Width_Screen-30, height: 0.5))
        separateLine?.backgroundColor = UIColor.black
        self.contentView.addSubview(separateLine!)
    }
    
//  MARK: -赋值
    func setupCellData(dataModel:AlbumMusicModel) {
        musicNameShow?.text = dataModel.MusicName
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
