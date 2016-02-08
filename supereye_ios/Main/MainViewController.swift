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

class MainViewController: SunViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var CameraImageView: UIImageView!
    @IBOutlet weak var ControllZoomView: UIView!
    var newMedia: Bool?
    //var cameraFlashMode: UIImagePickerControllerCameraFlashMode
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        showCamera()
        toggleFlash()
        
        let keyword = "우아한형제들"
        searchWeb(keyword)
        
        
        
        //UIApplication.sharedApplication().openURL()
        //let memoPicker = UIApplicationOpen
        
    }
    
    
    //원하는 검색어로 바로 브라우저를 띄워주는 함수
    func searchWeb(keyword: String){
        
        //keyword를 인코딩 시켜 준 후 검색함. 한글 keyword가 들어온 경우 검색하지 못하는 상황 발생.
        let escapedKeyword = keyword.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let baseUrl = "https://www.google.com/#q="
        let requestURL = baseUrl + escapedKeyword!
        UIApplication.sharedApplication().openURL(NSURL(string: requestURL)!)
    }
    
    
    //App 실행 시 기본 카메라를 띄워주는 함수
    func showCamera(){
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        //imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.On
        
        
        //밑에는 사진첩에 접근하기 위한 소스
        //imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Auto
        //imagePicker.allowsEditing = false
        //
        
        self.presentViewController(imagePicker, animated: true,
            completion: nil)
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
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        CameraImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    <#code#>
    }
    */
    
    
   /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as! String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            CameraImageView.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType.isEqualToString(kUTTypeMovie as! String) {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }*/
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
