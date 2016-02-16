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
    func toggleFlash()
    func searchWeb(keyword: String)
}

class CustomOverlayView: UIView {

    var delegate:CustomOverlayDelegate! = nil
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var shootButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    
    @IBAction func clickedSearchButton(sender: AnyObject) {
        testLabel.text = "검색들어갑니다."
        let resultKeyword: String = ""
        delegate.searchWeb(resultKeyword)
    }
    
    @IBAction func clickedFlashButton(sender: AnyObject) {
        testLabel.text = "후레쉬 On/Off"
        delegate.toggleFlash()
    }
    
    
    @IBAction func shootButton(sender: AnyObject) {
        delegate.didShoot(self)
        
    }

    @IBAction func clickedVoiceButton(sender: AnyObject) {
        delegate.searchByVoice()
    }


}
