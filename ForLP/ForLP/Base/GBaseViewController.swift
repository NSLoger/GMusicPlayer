//
//  GBaseViewController.swift
//  ForLP
//
//  Created by Fucker on 2023/3/23.
//

import UIKit

class GBaseViewController: UIViewController {
    //自定义导航栏
    var navigationBgView:UIView?
    var navigationTitleShow:UILabel?
    var backBtn:UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //默认背景颜色白色，隐藏导航栏
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        
        self.setupNavigationView()
    }
    
// MARK: -UI相关
    //创建自定义导航栏
    func setupNavigationView() -> () {
        var topHeight:CGFloat = 0.0                 //导航栏和状态栏高度
        topHeight = self.g_getStatusBarHeight()+self.g_getNavigationBarHeight()
        //导航栏背景
        navigationBgView = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(Width_Screen), height:Int(topHeight)))
        navigationBgView!.backgroundColor = UIColor.white
        self.view.addSubview(navigationBgView!)
        
        let navigationLine = UIView.init(frame: CGRectMake(0, navigationBgView!.bounds.size.height-0.5, navigationBgView!.bounds.size.width, 0.5))
        navigationLine.backgroundColor = UIColor.lightGray
        navigationBgView!.addSubview(navigationLine)
        //导航栏标题
        navigationTitleShow = UILabel.init(frame: CGRect(x: 0, y: self.g_getStatusBarHeight()+(self.g_getNavigationBarHeight()-18)/2, width: (navigationBgView?.bounds.size.width)!, height: 18))
        navigationTitleShow!.textColor = UIColor.black
        navigationTitleShow!.textAlignment = NSTextAlignment.center
        navigationTitleShow!.font = UIFont.boldSystemFont(ofSize: 18.0)
        navigationBgView!.addSubview(navigationTitleShow!)
    }
    
    //设置导航栏标题
    func setNavigationTitle(titleString:String) -> () {
        navigationTitleShow?.text = titleString
    }
    
    //导航栏返回按钮
    func setReturnButton() {
        let statusH = self.g_getStatusBarHeight()
        let navigationH = self.g_getNavigationBarHeight()
        
        var topHeight:CGFloat = 0.0                 //导航栏和状态栏高度
        topHeight = statusH + navigationH
        
        backBtn = UIButton(type: UIButton.ButtonType.custom)
        backBtn?.frame = CGRect(x: 0, y: 0, width: topHeight, height: topHeight)
        backBtn?.backgroundColor = UIColor.clear
        backBtn?.addTarget(self, action: #selector(backBtnClick), for: UIControl.Event.touchUpInside)
        navigationBgView?.addSubview(backBtn!)
        
        let returnArrowLogo = UIImageView(frame: CGRect(x: 15, y: statusH+(navigationH-28)/2, width: 28, height: 28))
        returnArrowLogo.image = UIImage(named: "ReturnArrow")
        backBtn?.addSubview(returnArrowLogo)
    }
    
    //隐藏导航栏
    func hideNavigationView() {
        navigationBgView?.isHidden = true
    }
    
    //展示导航栏
    func showNavigationView() {
        navigationBgView?.isHidden = false
    }
    
    
// MARK: -响应事件
    @objc func backBtnClick() {
        self.navigationController?.popViewController(animated: true)
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

extension GBaseViewController {
    //获取状态栏高度
    func g_getStatusBarHeight() -> CGFloat {
        var statusBarHeight:CGFloat = 0.0
        if #available (iOS 13.0,*) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else {return 0}
            guard let statusBarManager = windowScene.statusBarManager else {return 0}
            
            statusBarHeight = statusBarManager.statusBarFrame.height
        }else{
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    //获取导航栏高度，44
    func g_getNavigationBarHeight() -> CGFloat {
        var navigationBarHeight:CGFloat = 0.0
        if (self.navigationController != nil) {
            navigationBarHeight = (self.navigationController?.navigationBar.frame.height)!
        }
        
        return navigationBarHeight
    }
    
    //获取tabbar高度，49
    func g_getTabbarHeight() -> CGFloat {
        var tabbarHeight:CGFloat = 0.0
        tabbarHeight = (self.tabBarController?.tabBar.frame.height)!
        return tabbarHeight
    }
}
