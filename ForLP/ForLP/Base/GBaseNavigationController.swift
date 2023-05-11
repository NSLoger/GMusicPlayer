//
//  GBaseNavigationController.swift
//  ForLP
//
//  Created by Fucker on 2022/12/23.
//

import UIKit

class GBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationBar.isTranslucent = false
        
        if #available(iOS 15.0, *) {
            let itemAppearance = UINavigationBarAppearance()
            itemAppearance.configureWithOpaqueBackground()
            itemAppearance.titleTextAttributes = [.foregroundColor:UIColor.black]
            //设置背景
            itemAppearance.backgroundImage = UIImage(named: "NavBarAppearanceBg.png")
            //去除底部黑线
            itemAppearance.shadowImage = UIImage()
            self.navigationBar.standardAppearance = itemAppearance
            self.navigationBar.scrollEdgeAppearance = itemAppearance
        } else {
            //顶部线条颜色
            self.navigationBar.tintColor = UIColor.white
            self.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.black]
        }
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
