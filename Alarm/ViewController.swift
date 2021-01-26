//
//  ViewController.swift
//  Alarm
//
//  Created by 陳郁勳 on 2021/1/13.
//

import UIKit

class ViewController: UITabBarController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let worldClockVc = WorldClockViewController()
        let worldClockVcController = UINavigationController(rootViewController: worldClockVc)
        worldClockVcController.tabBarItem = UITabBarItem(title: "世界時鐘", image: UIImage(named: "alarmn"), selectedImage: UIImage(named: "alarmn"))
        
        let alarmVc = AlarmViewController()
        let alarmVcController = UINavigationController(rootViewController: alarmVc)
        alarmVcController.tabBarItem = UITabBarItem(title: "鬧鐘", image: UIImage(named: "alarmd.png"), selectedImage: UIImage(named: "alarm.pn"))
        
        let stopWatchVc = StopWatchViewController()
        let stopWatchController = UINavigationController(rootViewController: stopWatchVc)
        stopWatchController.tabBarItem.image = UIImage(named: "alarm.fill")
        stopWatchController.tabBarItem.title = "碼表"
        
        let timerVc = TimerViewController()
        let timerVcController = UINavigationController(rootViewController: timerVc)
        timerVcController.tabBarItem.image = UIImage(named: "alarm.fill")
        timerVcController.tabBarItem.title = "計時器"
        
        viewControllers = [worldClockVcController, alarmVcController, stopWatchController, timerVcController]
    }


}

