//
//  BalanceViewController.h
//  Balance
//
//  Created by Satoshi Nakagawa on 2013/10/06.
//  Copyright (c) 2013年 nakasen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

#import <CoreMotion/CoreMotion.h>

@interface BalanceViewController : UIViewController // <UIAccelerometerDelegate>
{
    double accelX, accelY, accelZ; // 加速度
    double speedX, speedY; // 速度
    double positionX, positionY; // 位置
    SystemSoundID soundID; // 効果音
}
@property (strong, nonatomic) IBOutlet UIImageView *backGroundView;
@property (strong, nonatomic) IBOutlet UIImageView *flashView;

@property (strong, nonatomic) IBOutlet UIImageView *ball;
@property (strong, nonatomic) IBOutlet UIImageView *flash;

@property (nonatomic, strong) CMMotionManager *motionManager; // モーションマネージャー

- (void)move; // ボールを移動させるメソッド
- (void)bump; // ボールが衝突した時に、フレームを光らせるメソッド

@end
