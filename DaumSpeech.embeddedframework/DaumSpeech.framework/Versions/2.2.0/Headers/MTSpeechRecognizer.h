//
//  MTSpeechRecognizer.h
//  DaumSpeech
//
//  Created by KimKyungmin on 13. 7. 18..
//  Copyright (c) 2013 Daum Communications Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MTSpeechRecognizerClient.h"
#import "MTSpeechRecognizerViewDelegate.h"
#import "MTSpeechRecognizerView.h"

/**
 * @brief MTSpeechRecognizer interface.
 *
 * Singleton instance로 버전정보 확인 및 음성인식 가능여부를 체크 한다.
 * {@link #getVersion}으로 음성인식 버전을 체크할 수 있다.
 * {@link #isRecordingAvailable}와 {@link #isGrantedRecordingPermission}의 클래스 메소드로 음성인식 가능여부를 체크할 수 있다.
 *
 **/
@interface MTSpeechRecognizer : NSObject

/**
 * MTSpeechRecognizer instance 생성.
 *
 * @return MTSpeechRecognizer instance.
 **/
+ (MTSpeechRecognizer*)sharedInstance;

/**
 * 버전 정보를 확인하는 메소드.
 * @return 음성인식 라이브러리 버전.
 */
+ (NSString*)getVersion;

/**
 * 현재 장치에서 음성의 녹음이 가능한지 여부를 체크한다.
 **/
+ (BOOL)isRecordingAvailable;

/**
 * iOS 7 이상 기기에서 audio session을 사용할 때, 마이크 접근 허용을 확인하는 절차가 추가됨으로써
 * 현재 장치에서 마이크 접근 허용 상태를 체크한다.
 * 마이크 접근 허용 승인은 [설정>개인정보보호>마이크] 에서 변경할 수 있다.
 **/
+ (BOOL)isGrantedRecordingPermission;

@end
