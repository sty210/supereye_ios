//
//  CustomOverlayViewController.swift
//  supereye_ios
//
//  Created by 송태양 on 2016. 2. 9..
//  Copyright © 2016년 송태양. All rights reserved.
//

import UIKit

class CustomOverlayViewController: UIViewController {
    @IBOutlet weak var shootButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shootButton.setImage(UIImage(named: "takephoto_selected"), forState: .Highlighted)
        flashButton.setImage(UIImage(named: "flash_selected"), forState: .Highlighted)
        searchButton.setImage(UIImage(named: "search_selected"), forState: .Highlighted)
        voiceButton.setImage(UIImage(named: "voice_selected"), forState: .Highlighted)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
