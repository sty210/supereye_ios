//
//  CustomOverlayView.swift
//  supereye_ios
//
//  Created by 송태양 on 2016. 2. 9..
//  Copyright © 2016년 송태양. All rights reserved.
//

import UIKit

protocol CustomOverlayDelegate{
    func didShoot(overlayView:CustomOverlayView)
    func searchByVoice()
    func toggleFlash()->Bool
    func searchWeb(keyword: String)
}

class CustomOverlayView: UIView 
{
    var delegate:CustomOverlayDelegate! = nil
    @IBOutlet weak var shootButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var recordView: UIView!
    
    @IBAction func clickedSearchButton(sender: AnyObject) {
        let resultKeyword: String = ""
        delegate.searchWeb(resultKeyword)
    }
    
    @IBAction func clickedFlashButton(sender: AnyObject) {
        let flashStatus:Bool = delegate.toggleFlash()
        
        if flashStatus == true{
            flashButton.setImage(UIImage(named: "flash_selected"), forState: .Normal)
        }else{
            flashButton.setImage(UIImage(named: "flash"), forState: .Normal)
        }
    }
    
    
    @IBAction func shootButton(sender: AnyObject) {
        delegate.didShoot(self)
        
    }

    @IBAction func clickedVoiceButton(sender: AnyObject) {
        delegate.searchByVoice()
        
    }
    

}
