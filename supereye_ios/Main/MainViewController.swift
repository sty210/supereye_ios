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
                          CustomOverlayDelegate,
                          G8TesseractDelegate
    
{
    @IBOutlet weak var shootedImageView: UIImageView!
    var copiedImagePicker:UIImagePickerController? = UIImagePickerController()
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    var newMedia: Bool?
    var isShooted: Bool = false
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        
        if isShooted == false{
            showCamera()
        }
        


        //UIApplication.sharedApplication().openURL(NSURL(string: "tel://01065360331")!)
        //UIApplication.sharedApplication().openURL(NSURL(string: "sms://")!)
        //UIApplication.sharedApplication().canOpenURL(NSURL(string: "music://")!)
    }
    
    //App 실행 시 기본 카메라를 띄워주는 함수
    func showCamera(){

        
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            let imagePicker:UIImagePickerController? = UIImagePickerController()
            imagePicker!.allowsEditing = false
            imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker!.cameraCaptureMode = .Photo
            imagePicker!.showsCameraControls = false
            imagePicker!.mediaTypes = [kUTTypeImage as String]
            imagePicker!.delegate = self
            //imagePicker!.cameraViewTransform.ty = 20
            
            //customView stuff
            let customViewController = CustomOverlayViewController(
                nibName:"CustomOverlayViewController",
                bundle: nil
            )
            let customView:CustomOverlayView = customViewController.view as! CustomOverlayView
        
            
            let translate: CGAffineTransform = CGAffineTransformMakeTranslation(0.0, 70.0); //This slots the preview exactly in the middle of the screen by moving it down 0 points
            let scale: CGAffineTransform  = CGAffineTransformScale(translate, 1.0, 1.2);
            
            imagePicker!.cameraViewTransform = translate
            imagePicker!.cameraViewTransform = scale

            
            imagePicker!.view.frame.size.height = self.screenHeight
            customView.frame = imagePicker!.view.frame
            //customView.transform = CGAffineTransformMakeTranslation(0.0, 20.0);
            customView.delegate = self
            
            
            newMedia = true
    
            
            /*
            self.imagePicker!.view.multipleTouchEnabled = false
            self.imagePicker!.view.exclusiveTouch = true
            customView.multipleTouchEnabled = false
            customView.exclusiveTouch = true
            */
            
            
            
            
            
            //이 두줄 지우면 안됌!! 보류 !!!!!!
            //let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "pinchDetected")
            //customView.addGestureRecognizer(pinchRecognizer)
            
            
            
            //imagePicker!.modalTransitionStyle = .PartialCurl
            
            imagePicker!.modalPresentationStyle = .FullScreen
            self.presentViewController(imagePicker!, animated: true, completion: {imagePicker!.cameraOverlayView = customView})
            
            copiedImagePicker = imagePicker
            
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
    
    /*func pinchDetected(){
        print("pinchDetected!!")
        //self.imagePicker!.view.userInteractionEnabled = false
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesEnded!!")
        //self.imagePicker!.view.userInteractionEnabled = true
    }*/
    
    
     //MARK: Image Picker Controller Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        shootedImageView.image = chosenImage
        
        isShooted = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shootedImageSave(sender: AnyObject) {
        isShooted = false
        //저장 후 카메라를 다시 연다.
        UIImageWriteToSavedPhotosAlbum(self.shootedImageView.image!, self,nil, nil)
        showCamera()
    }
    
    @IBAction func shootedImageSearch(sender: AnyObject) {
        
        //찍힌 사진을 기반으로 검색, 문자인식 구현 중
        
        let tesseract:G8Tesseract = G8Tesseract(language:"kor3+eng")
        tesseract.delegate = self
        tesseract.image = shootedImageView.image
        //tesseract.image = UIImage(named: "test4")
        
        tesseract.recognize()
        print(".")
        print(".")
        print(".")
        print("tesseract.recognizedText : "+tesseract.recognizedText)
        print("--------------------------------------------")

        searchWeb(tesseract.recognizedText)
        
        //searchWeb("이 곳에 키워드가 들어갑니다.")
    }
    
    @IBAction func shootedImageCancel(sender: AnyObject) {
        isShooted = false
        //카메라를 다시 연다.
        showCamera()
    }
    

    
    //MARK: Custom View Delegates
    func didCancel(overlayView:CustomOverlayView) {
        //imagePicker!.dismissViewControllerAnimated(true, completion: nil)
        print("dismissed!!")
    }
    
    func didShoot(overlayView:CustomOverlayView) {
        copiedImagePicker!.takePicture()
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
    
    
    
    
    
    
    
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
