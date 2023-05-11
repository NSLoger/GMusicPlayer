//
//  CollectionListCell.swift
//  ForLP
//
//  Created by Fucker on 2023/5/5.
//

import UIKit

class CollectionListCell: UITableViewCell {
    var collectLogo : UIImageView!            //收藏logo
    var separateLineVertical:UIView!          //中间分隔线
    var musicNameShow : UILabel!              //歌曲名
    
    
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
        collectLogo = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        collectLogo.image = UIImage(named: "Tabbar2_select")
        self.contentView.addSubview(collectLogo)
        
        separateLineVertical = UIView(frame: CGRect(x: 40, y: 8, width: 1, height: 24))
        separateLineVertical.backgroundColor = UIColor.colorWithHex(hexString: "#666666", alpha: 1.0)
        self.contentView.addSubview(separateLineVertical)
        
        musicNameShow = UILabel(frame: CGRect(x: 45, y: 12, width: Width_Screen-55, height: 16))
        musicNameShow.textColor = UIColor.colorWithHex(hexString: "#999999", alpha: 1.0)
        musicNameShow.textAlignment = NSTextAlignment.left
        musicNameShow.font = UIFont.systemFont(ofSize: 16.0)
        self.contentView.addSubview(musicNameShow)
    }
    
    func setupCellData(musicModel:AlbumMusicModel) {
        musicNameShow.text = musicModel.MusicName
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
