//
//  ViewController.swift
//  ServerAPIDemo
//
//  Created by 唐韬 on 2017/11/11.
//  Copyright © 2017年 Demo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timezoneLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        /// 可以看到, 相同的调用方式, 但是result的类型却会随着参数的不同而自动匹配。
        
        request(api: API.getWeather) { (result) in
            // result的类型就为 Result<Weather>
            self.timezoneLabel.text = result.value?.timezone
            self.summaryLabel.text = result.value?.summary
        }
        
//        request(api: API.getXXX) { (result) in
//            // result的类型就为 Result<[Weather]>
//        }
        
//        request(api: API.getAnotherModel) { (result) in
//            // result的类型就为 Result<AnotherModel>
//        }
        
    }

}

