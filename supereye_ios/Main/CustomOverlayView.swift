//
//  CustomOverlayView.swift
//  supereye_ios
//
//  Created by 송태양 on 2016. 2. 9..
//  Copyright © 2016년 송태양. All rights reserved.
//

import UIKit

protocol CustomOverlayDelegate{
    func didCancel(overlayView:CustomOverlayView)
    func didShoot(overlayView:CustomOverlayView)
    func toggleFlash()
    func searchWeb(keyword: String)
}

class CustomOverlayView: UIView {

    var delegate:CustomOverlayDelegate! = nil
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var zoomLevelLabel: UILabel!
    @IBOutlet weak var zoomSlider: UISlider!
    
    
     //Slider의 변화 감지
    @IBAction func detectedChangeOfSlider(sender: AnyObject) {
        zoomSlider.value = round(zoomSlider.value*10)/10
        zoomLevelLabel.text = "x"+String(zoomSlider.value)
    }
    
    //Zoom Controll <Minus>버튼 눌렀을 시 동작
    @IBAction func clickedMinusButton(sender: AnyObject) {
        if zoomSlider.value >= 2{
            zoomSlider.value = zoomSlider.value - 1
        }else if zoomSlider.value >= 1.1 {
            zoomSlider.value = zoomSlider.value - 0.1
        }
        zoomSlider.value = round(zoomSlider.value*10)/10
        zoomLevelLabel.text = "x"+String(zoomSlider.value)
    }
    
    //Zoom Controll <Plus>버튼 눌렀을 시 동작
    @IBAction func clickedPlusButton(sender: AnyObject) {
        if zoomSlider.value <= 3{
            zoomSlider.value = zoomSlider.value + 1
        }else if zoomSlider.value <= 3.9 {
            zoomSlider.value = zoomSlider.value + 0.1
        }
        zoomSlider.value = round(zoomSlider.value*10)/10
        zoomLevelLabel.text = "x"+String(zoomSlider.value)
    }
    
    @IBAction func clickedSearchButton(sender: AnyObject) {
        let resultKeyword: String = "아직 구현 안됐지롱^^"
        delegate.searchWeb(resultKeyword)
    }
    
    @IBAction func clickedFlashButton(sender: AnyObject) {
        testLabel.text = "후레쉬 On/Off"
        delegate.toggleFlash()
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        testLabel.text = "뭐 넣을 까?"
        delegate.didCancel(self)
    }
    
    @IBAction func shootButton(sender: AnyObject) {
        //testLabel.text = "Even Cooler Camera"
        delegate.didShoot(self)
    }

    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
