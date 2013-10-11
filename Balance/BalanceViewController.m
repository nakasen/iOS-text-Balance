//
//  BalanceViewController.m
//  Balance
//
//  Created by Satoshi Nakagawa on 2013/10/06.
//  Copyright (c) 2013年 nakasen.com. All rights reserved.
//

#import "BalanceViewController.h"

@interface BalanceViewController ()

@end

@implementation BalanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 自動ロックの禁止
    UIApplication *application = [UIApplication sharedApplication];
    application.idleTimerDisabled = YES;
    
    // 位置の初期値を設定
    positionX = self.view.bounds.size.width / 2;
    positionY = self.view.bounds.size.height / 2;
    
    // 速度の初期値を設定
    speedX = 0.0;
    speedY = 0.0;
    
    // 加速度の初期値を設定
    accelX = 0.0;
    accelY = 0.0;
    
    // 効果音の再生を準備
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Beep" ofType:@"caf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    
    // 加速度センサーの利用
    
    // 加速度センサーのインスタンスを取得
    // UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    self.motionManager = [[CMMotionManager alloc] init];
    // 加速度センサーの値を得る時間間隔を指定
    //accelerometer.updateInterval = 0.02;
    self.motionManager.accelerometerUpdateInterval = 0.02;
    // 加速度センサーの値を受け取るデリゲートを自分自身に設定
    //accelerometer.delegate = self;
    
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    
    [self.motionManager startAccelerometerUpdatesToQueue:currentQueue
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 CMAcceleration acceleration = accelerometerData.acceleration;
                                                 accelX = acceleration.x;
                                                 accelY = acceleration.y;
                                                 accelZ = acceleration.z;
                                                 [self move];
                                             }];
    
#if (TARGET_IPHONE_SIMULATOR)
    // シミュレータ動作時はタイマーを動作
    [NSTimer scheduledTimerWithTimeInterval:0.02
                                     target:self
                                   selector:@selector(fakeAccelerometer)
                                   userInfo:nil
                                    repeats:YES];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
	accelX = acceleration.x;
	accelY = acceleration.y;
	accelZ = acceleration.z;
	
	[self move];
	
}
*/

// ボールを移動させるメソッド
- (void)move
{
    // 加速度から速度を計算
    speedX = speedX + accelX;
    speedY = speedY - accelY;
    
    // 速度から位置を計算
    positionX = positionX + speedX;
    positionY = positionY + speedY;
    
    // ボールと左側のフレームとの衝突判定
    if (positionX <= 80) {
        // ボールが跳ね返るよう位置と速度を設定
        speedX *= -1;
        positionX = 80 + (80 - positionX);
        // フレームを光らせる
        [self bump];
    }
    
    // ボールと右側のフレームとの衝突判定
    if (positionX >= 240) {
        // ボールが跳ね返るよう位置と速度を設定
        speedX *= -1;
        positionX = 240 + (positionX - 240);
        // フレームを光らせる
        [self bump];
    }

    // ボールと上側のフレームとの衝突判定
    if (positionY <= 80) {
        // ボールが跳ね返るよう位置と速度を設定
        speedY *= -1;
        positionY = 80 + (80 - positionY);
        // フレームを光らせる
        [self bump];
    }
    
    // ボールと下側のフレームとの衝突判定
    double bottom = self.view.bounds.size.height - 80;
    if (positionY >= bottom) {
        // ボールが跳ね返るよう位置と速度を設定
        speedY *= -1;
        positionY = bottom + (positionY - bottom);
        // フレームを光らせる
        [self bump];
    }
    
    // 計算した位置にボールを移動
    self.ball.center = CGPointMake(positionX, positionY);
}

- (void)bump
{
    // アルファ値を1.0にして光るフレームを表示
    self.flash.alpha = 1.0;
    
    // １秒かけてアルファ値を0.0に変化させる
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    
    self.flash.alpha = 0.0;
    
    [UIView commitAnimations];
    
    // 効果音を鳴らす
    AudioServicesPlayAlertSound(soundID);
}

#if (TARGET_IPHONE_SIMULATOR)
// シミュレータ動作時の擬似的な加速度センサーの処理
- (void)fakeAccelerometer
{
    // インスタンス変数に加速度の値を代入
    accelX = 0.01;
    accelY = 0.01;
    accelZ = 0.0;
    // ボールを移動させる
    [self move];
}
#endif

@end
