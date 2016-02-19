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
import SpriteKit
import GPUImage

class MainViewController: UIViewController,
                          UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate,
                          CustomOverlayDelegate,
                          G8TesseractDelegate,
                          MTSpeechRecognizerDelegate,
                          MTSpeechRecognizerViewDelegate
{
    var customOverlayViewController: CustomOverlayViewController?
    @IBOutlet weak var shootedImageView: UIImageView!
    @IBOutlet weak var shootedRecordView: UIView!
    @IBOutlet weak var shootedImageMagic: UIButton!
    var clearImage: UIImage?
    var copiedImagePicker:UIImagePickerController? = UIImagePickerController()
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    var newMedia: Bool?
    var isShooted: Bool = false
    var start: CGPoint?
    //var canWriting: Bool = false
    var currentPenColor: CGColor = UIColor.grayColor().CGColor
    var customView: CustomOverlayView?
    var speechRecognizerView: MTSpeechRecognizerView?
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var penButton: UIButton!
    @IBOutlet weak var shootedImageSearchButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shootedImageVoiceButton: UIButton!
    @IBOutlet weak var sharpCompareButton: UIButton!
    @IBOutlet weak var shootedImageShareButton: UIButton!
    
    var recordingOnOffResult:Bool = false
    
    
    
    
    @IBOutlet weak var shootedSlider: UISlider!
    @IBOutlet weak var sliderView: UIView!
    var inputImage: UIImage?
    var stillImageSource: GPUImagePicture?
    var sharpenFilter: GPUImageSharpenFilter?
    var sketchFilter: GPUImageSketchFilter?
    var isSelectedFilterButton: Bool = false
    
    @IBAction func clickedSharpenEffectButton(sender: AnyObject) {
        
        //sliderView.hidden = !sliderView.hidden
        isSelectedFilterButton = !isSelectedFilterButton
        if !isSelectedFilterButton {
            shootedImageMagic.setImage(UIImage(named: "magic"), forState: .Normal)

            shootedImageView.image = clearImage
        }else{
            shootedImageMagic.setImage(UIImage(named: "magic_selected"), forState: .Normal)
            
            inputImage = clearImage
            stillImageSource = GPUImagePicture(image: inputImage)
            sketchFilter = GPUImageSketchFilter()
            stillImageSource!.addTarget(sketchFilter)
            sketchFilter!.useNextFrameForImageCapture()
            stillImageSource!.processImage()
            shootedImageView.image = sketchFilter!.imageByFilteringImage(inputImage)
        }
        
        print("clickedSharpenEffectButton  Clicked!!!!!!!!!!")
        
    }
    
    
    
    
    //return 버튼 클릭 시 clearImage로 바꾸어 원본으로 돌아간다.
    @IBAction func clickedReturnImageButton(sender: AnyObject) {
        shootedSlider.value = 0
        shootedImageView.image = clearImage
    }
    
    @IBAction func sliderTouched(sender: AnyObject) {
        inputImage = clearImage
        stillImageSource = GPUImagePicture(image: inputImage)
        sharpenFilter = GPUImageSharpenFilter()
        
        sharpenFilter!.sharpness = CGFloat(shootedSlider.value)
        
        stillImageSource!.addTarget(sharpenFilter)
        sharpenFilter!.useNextFrameForImageCapture()
        stillImageSource!.processImage()
        shootedImageView.image = sharpenFilter!.imageByFilteringImage(inputImage)
    }

    @IBAction func clickedMoreactionButton(sender: AnyObject) {
        
        let imageToShare:UIImage = shootedImageView.image!
        
        if let myString = NSURL(string: "SuperEye")
        {
            let objectsToShare = [imageToShare, myString]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabedPenGesture = UITapGestureRecognizer(target: self, action: "tabedPenButton")
        tabedPenGesture.numberOfTapsRequired = 1
        penButton.addGestureRecognizer(tabedPenGesture)
        
        //let longClickedPenGesture = UILongPressGestureRecognizer(target: self, action: "longClickedPenButton")
        //penButton.addGestureRecognizer(longClickedPenGesture)
        
        saveButton.setImage(UIImage(named: "save_selected"), forState: .Highlighted)
        shootedImageSearchButton.setImage(UIImage(named: "search_selected"), forState: .Highlighted)
        penButton.setImage(UIImage(named: "pen_selected"), forState: .Highlighted)
        cancelButton.setImage(UIImage(named: "cancel_selected"), forState: .Highlighted)
        shootedImageVoiceButton.setImage(UIImage(named: "voice_selected"), forState: .Highlighted)
        shootedImageMagic.setImage(UIImage(named: "magic_selected"), forState: .Highlighted)
        shootedImageShareButton.setImage(UIImage(named: "share_selected"), forState: .Highlighted)
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
            customView = customViewController.view as? CustomOverlayView
            customOverlayViewController = customViewController
            
            let translate: CGAffineTransform = CGAffineTransformMakeTranslation(0.0, 70.0) //This slots the preview exactly in the middle of the screen by moving it down 0 points
            let scale: CGAffineTransform  = CGAffineTransformScale(translate, 1.0, 1.2)
            //let scale: CGAffineTransform  = CGAffineTransformScale(translate, 1.0, 1.0)
            imagePicker!.cameraViewTransform = translate
            imagePicker!.cameraViewTransform = scale

            
            imagePicker!.view.frame.size.height = self.screenHeight
            customView!.frame = imagePicker!.view.frame
            customView!.delegate = self
            
            
            newMedia = true

            //페이지 넘김 효과
            imagePicker!.modalTransitionStyle = .FlipHorizontal
            
            imagePicker!.modalPresentationStyle = .FullScreen
            self.presentViewController(imagePicker!, animated: true, completion: {imagePicker!.cameraOverlayView = self.customView})
            
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

    
    
     //MARK: Image Picker Controller Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        shootedImageView.image = chosenImage
        clearImage = chosenImage
        
        isShooted = true
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shootedImageSave(sender: AnyObject) {
        
        saveButton.highlighted = !saveButton.highlighted
        if saveButton.highlighted {
            saveButton.imageView!.image = UIImage(named: "saved_selected")
        }
        
        isShooted = false
        //저장 후 카메라를 다시 연다.
        UIImageWriteToSavedPhotosAlbum(self.shootedImageView.image!, self,nil, nil)
        
        
        let alert = UIAlertController(title: "", message: "Successfully saved.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                print("default")
                self.shootedImageMagic.setImage(UIImage(named: "magic"), forState: .Normal)
                self.showCamera()
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
        //showCamera()
        
    }
    
    @IBAction func shootedImageSearch(sender: AnyObject) {
        
        //찍힌 사진을 기반으로 검색, 문자인식 구현 중
        /*
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
        */
        //searchWeb("이 곳에 키워드가 들어갑니다.")
        
        searchWeb("")
    }
    
    @IBAction func shootedImageWriting(sender: AnyObject) {
        //canWriting = !canWriting
        
        
    }
    
    @IBAction func shootedImageCancel(sender: AnyObject) {
        isShooted = false
        shootedImageMagic.setImage(UIImage(named: "magic"), forState: .Normal)
        //카메라를 다시 연다.
        showCamera()
    }
    @IBAction func shootedImageVoice(sender: AnyObject) {
        searchByVoice()
    }
    
    
    func searchByVoice(){
        
        let isAvailableUsingMic:Bool = MTSpeechRecognizer.isRecordingAvailable()
        print("isAvailableUsingMic : "+String(isAvailableUsingMic))
        
        let config:NSDictionary = [SpeechRecognizerConfigKeyApiKey:"6fe94d81f416ed44e516fe88a3938686", SpeechRecognizerConfigKeyCustomStrings:"SpeechRecognizerDefault", SpeechRecognizerConfigKeyShowSuggestView:false]
        //let config:NSDictionary = [SpeechRecognizerConfigKeyApiKey:"test중", SpeechRecognizerConfigKeyCustomStrings:"SpeechRecognizerDefault", SpeechRecognizerConfigKeyShowSuggestView:"NO"]
        
        //mic 사용이 허용된 경우
        if isAvailableUsingMic{
            let recongnizerInstance: MTSpeechRecognizerClient = MTSpeechRecognizerClient()
            recongnizerInstance.delegate = self
            recongnizerInstance.startRecording()
            print("recongnizerInstance.startRecording()")
            
            
            var currentView: UIView
            if isShooted{
                currentView = self.view
            }else{
                currentView = self.customView!
            }
            
            speechRecognizerView = MTSpeechRecognizerView(frame: currentView.frame, withConfig: config as [NSObject : AnyObject])
            speechRecognizerView!.delegate = self // view의 delegate 설정
            //currentView.addSubview(speechRecognizerView!)
            
            speechRecognizerView!.frame.size.height=0
            speechRecognizerView!.frame.size.width=0
            speechRecognizerView!.show()
            shootedRecordView.hidden = false
            shootedImageVoiceButton.setImage(UIImage(named: "voice_selected"), forState: .Normal)
            customOverlayViewController?.setVoiceRecognitionUsing()
            

            /*for sv in speechRecognizerView.subviews{
                sv.backgroundColor = UIColor(red: 0.7, green: 0.0, blue: 0.5, alpha: 0.5)
            }*/
        }
    }
    
    func onPartialResult(partialResult: String!) {
        //뉴톤 기능 중 중간결과가 있을 때에 호출
    }
    
    func onResults(results: [AnyObject]!, confidences: [AnyObject]!, marked: Bool) {
        //음성인식이 성공적으로 끝났을 때에 호출 됨
        searchWeb(String(results[0]))
        shootedRecordView.hidden = true
        shootedImageVoiceButton.setImage(UIImage(named: "voice"), forState: .Normal)
        customOverlayViewController?.setVoiceRecognitionNotUsing()
    }
    
    func onError(errorCode: MTSpeechRecognizerError, message: String!) {
        //뉴톤 기능 중 에러가 발생했을 때에 호출
        shootedRecordView.hidden = true
        shootedImageVoiceButton.setImage(UIImage(named: "voice"), forState: .Normal)
        customOverlayViewController?.setVoiceRecognitionNotUsing()
    }
    
    func onReady() {
        print("")
    }
    
    func onBeginningOfSpeech() {
        print("")
    }
    
    func onEndOfSpeech() {
        shootedRecordView.hidden = true
        shootedImageVoiceButton.setImage(UIImage(named: "voice"), forState: .Normal)
        customOverlayViewController?.setVoiceRecognitionNotUsing()
        print("")
    }
    
    func onAudioLevel(audioLevel: Float) {
        print("")
    }
    
    func onFinished() {
        shootedRecordView.hidden = true
        print("")
    }

    
    
    
    
    
    
    
    
    
    
    func didShoot(overlayView:CustomOverlayView) {
        copiedImagePicker!.takePicture()
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
    func toggleFlash() -> Bool {
        var onOffResult:Bool? = false
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureTorchMode.On) {
                    device.torchMode = AVCaptureTorchMode.Off
                    onOffResult = false
                } else {
                    do {
                        try device.setTorchModeOnWithLevel(1.0)
                        onOffResult = true
                    } catch {
                        print(error)
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        
        return onOffResult!
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
            if let touch = touches.first {
                start = touch.locationInView(view)
            }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
            if let touch = touches.first {
                let end = touch.locationInView(view)
                if let start = self.start {
                    drawFromPoint(start, toPoint: end)
                }
                self.start = end
            }
    }
    
    
    func drawFromPoint(start: CGPoint, toPoint end: CGPoint) {
        
        // set the context to that of an image
        UIGraphicsBeginImageContext(shootedImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        // draw the existing image onto the current context
        shootedImageView.image?.drawInRect(CGRect(x: 0, y: 0,
            width: shootedImageView.frame.size.width, height: shootedImageView.frame.size.height))
        // draw the new line segment
        CGContextSetLineWidth(context, 3)
        CGContextSetStrokeColorWithColor(context, self.currentPenColor)
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, start.x, start.y-70)
        CGContextAddLineToPoint(context, end.x, end.y-70)
        CGContextStrokePath(context)
        // obtain a UIImage object from the context
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // set the UIImageView's image to the new, generated image
        shootedImageView.image = newImage
    }
    
    func tabedPenButton(){
        
        let optionMenu = UIAlertController(title: nil, message: "choose color", preferredStyle: .Alert)
        
        let whiteAction = UIAlertAction(title: "white", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.currentPenColor = UIColor.whiteColor().CGColor
        })
        let blackAction = UIAlertAction(title: "balck", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.currentPenColor = UIColor.blackColor().CGColor
        })
        let grayAction = UIAlertAction(title: "gray", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.currentPenColor = UIColor.grayColor().CGColor
        })
        let blueAction = UIAlertAction(title: "blue", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.currentPenColor = UIColor.blueColor().CGColor
        })
        let redAction = UIAlertAction(title: "red", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.currentPenColor = UIColor.redColor().CGColor
        })
        let eraseAction = UIAlertAction(title: "erase all", style: .Destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.shootedImageView.image = self.clearImage
            self.shootedImageMagic.setImage(UIImage(named: "magic"), forState: .Normal)
        })
        
        
        optionMenu.addAction(whiteAction)
        optionMenu.addAction(blackAction)
        optionMenu.addAction(grayAction)
        optionMenu.addAction(blueAction)
        optionMenu.addAction(redAction)
        optionMenu.addAction(eraseAction)
        
        //canWriting = true
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
 
    
    
    
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
