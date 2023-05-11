//
//  GBaseTabBarController.swift
//  ForLP
//
//  Created by Fucker on 2022/12/20.
//

import UIKit

class GBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupItemBaseData()
        self.setupChildViewController()
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

/**
 extension类似OC中的分类，在swift中可以用来切分代码块
 可以把相近功能的函数，放在一个extension中
 和OC的分类一样，extension中不能定义属性
 */
extension GBaseTabBarController {
    // MARK: -设置基本属性参数
    private func setupItemBaseData() {
        if #available(iOS 15.0, *) {
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.normal.titleTextAttributes = [.foregroundColor:UIColor.gray]
            itemAppearance.selected.titleTextAttributes = [.foregroundColor:UIColor.blue]
            
            let tabbarAppearance = UITabBarAppearance()
            //顶部线条颜色
            tabbarAppearance.shadowColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            //item具体参数
            tabbarAppearance.stackedLayoutAppearance = itemAppearance
            
            self.tabBar.standardAppearance = tabbarAppearance
            self.tabBar.scrollEdgeAppearance = tabbarAppearance
        } else {
            //顶部线条颜色
            self.tabBar.shadowImage = UIImage()
            self.tabBar.unselectedItemTintColor = UIColor.clear
            //item具体参数
            self.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.gray], for: UIControl.State.normal)
            self.tabBarItem.setTitleTextAttributes([.foregroundColor:UIColor.blue], for: UIControl.State.selected)
        }
    }
    // MARK: -设置所有子控制器
    private func setupChildViewController() {
        //历史
        let history = HistoryVC()
        let historyNav = self.formateSubViewControllers(subViewController: history, title: "历史专辑", normalImgName: "Tabbar0_normal", selectImgName: "Tabbar0_select")
        //音乐库
        let musicLibrary = MusicLibraryVC()
        let libraryNav = self.formateSubViewControllers(subViewController: musicLibrary, title: "音乐库", normalImgName: "Tabbar1_normal", selectImgName: "Tabbar1_select")
        //收藏馆
        let collection = CollectionVC()
        let collectionNav = self.formateSubViewControllers(subViewController: collection, title: "收藏馆", normalImgName: "Tabbar2_normal", selectImgName: "Tabbar2_select")
        
        self.viewControllers = [historyNav,libraryNav,collectionNav]
    }
    
    //自定义tabbar
    private func formateSubViewControllers(subViewController:UIViewController, title:String, normalImgName:String, selectImgName:String) -> GBaseNavigationController {
        let navVC = GBaseNavigationController(rootViewController: subViewController)
        subViewController.title = title
        navVC.tabBarItem.image = UIImage(named: normalImgName)?.withRenderingMode(.alwaysOriginal)
        navVC.tabBarItem.selectedImage = UIImage(named: selectImgName)?.withRenderingMode(.alwaysOriginal)
        
        return navVC
    }
}
