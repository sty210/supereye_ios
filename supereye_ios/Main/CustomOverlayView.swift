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
    /*@IBOutlet weak var zoomLevelLabel: UILabel!
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
    }*/
    
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
        //testLabel.text = "Even Cooler Camera"
        delegate.didShoot(self)
    }



}
