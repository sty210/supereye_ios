//
//  MainViewController.swift
//  supereye_ios
//
//  Created by 송태양 on 2016. 2. 7..
//  Copyright © 2016년 송태양. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation

class MainViewController: UIViewController,
                          UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate,
                          CustomOverlayDelegate
{
    @IBOutlet weak var CameraImageView: UIImageView!
    var imagePicker:UIImagePickerController? = UIImagePickerController()
    
    //var newMedia: Bool?
    
    @IBAction func testButtonClicked(sender: AnyObject) {
        //showCamera()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        //imagePicker!.delegate = self
        
        showCamera()
        /*toggleFlash()
        
        let keyword = "우아한형제들"
        searchWeb(keyword)
        */
        
        
        
        //UIApplication.sharedApplication().openURL(NSURL(string: "tel://01065360331")!)
        //UIApplication.sharedApplication().openURL(NSURL(string: "sms://")!)
        //UIApplication.sharedApplication().canOpenURL(NSURL(string: "music://")!)
    }
    
    //App 실행 시 기본 카메라를 띄워주는 함수
    func showCamera(){

        
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            imagePicker!.allowsEditing = false
            imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker!.cameraCaptureMode = .Photo
            imagePicker!.showsCameraControls = false
            imagePicker!.mediaTypes = [kUTTypeImage as String]
            imagePicker!.delegate = self
            imagePicker!.cameraViewTransform.ty = 70
            //imagePicker!.
            UIImagePickerControllerQualityType.TypeIFrame1280x720
            
            //customView stuff
            let customViewController = CustomOverlayViewController(
                nibName:"CustomOverlayViewController",
                bundle: nil
            )
            let customView:CustomOverlayView = customViewController.view as! CustomOverlayView
            
            //self.imagePicker!.view.frame.origin =
            
            customView.frame = self.imagePicker!.view.frame
            customView.delegate = self
            
            
            //imagePicker!.modalTransitionStyle = .PartialCurl
            imagePicker!.modalPresentationStyle = .FullScreen
            self.presentViewController(imagePicker!, animated: true, completion: {self.imagePicker!.cameraOverlayView = customView})
            
        }else{
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .Alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.Default,
                handler: nil)
            alertVC.addAction(okAction)
            presentViewController(
                alertVC,
                animated: true,
                completion: nil)
        }
        
    }
    
    
     //MARK: Image Picker Controller Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        UIImageWriteToSavedPhotosAlbum(chosenImage, self,nil, nil)
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Custom View Delegates
    func didCancel(overlayView:CustomOverlayView) {
        //imagePicker!.dismissViewControllerAnimated(true, completion: nil)
        print("dismissed!!")
    }
    
    func didShoot(overlayView:CustomOverlayView) {
        imagePicker!.takePicture()
        overlayView.testLabel.text = "찍었다."
        print("Shot Photo")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    //원하는 검색어로 바로 브라우저를 띄워주는 함수
    func searchWeb(keyword: String){
        
        //keyword를 인코딩 시켜 준 후 검색함. 한글 keyword가 들어온 경우 검색하지 못하는 상황 발생.
        let escapedKeyword = keyword.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let baseUrl = "https://www.google.com/#q="
        let requestURL = baseUrl + escapedKeyword!
        UIApplication.sharedApplication().openURL(NSURL(string: requestURL)!)
    }
    
    
    //토치(플래시라이트)를 On/Off 시켜주는 함수
    func toggleFlash() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureTorchMode.On) {
                    device.torchMode = AVCaptureTorchMode.Off
                } else {
                    do {
                        try device.setTorchModeOnWithLevel(1.0)
                    } catch {
                        print(error)
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
