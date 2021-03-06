//
//  AppDelegate.swift
//  Echo
//
//  Created by Dang Pham on 3/1/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNDelegate {
    
    var pubNub: PubNub?
    var session:SPTSession?
    var user: User?
    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("MUJzfsX8Y7z6xm4PsXrwyr3GTCRHPnJmVOF4lhDf", clientKey: "ywrNxXXEcg2gUnbSgZJwozopJfWRjyGp1fdUONfk")
        self.pubNub = PubNub.connectingClientWithConfiguration(PNConfiguration.defaultConfiguration(), delegate: self, andSuccessBlock: {(orign) -> Void in println("connected to Pubnub")}, errorBlock: {(error) -> Void in println("error")})
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func pubnubClient(client: PubNub!, didReceiveMessage message: PNMessage!) {
        var channel_name = message.channel.name
        var sender = message.valueForKey("sender") as String
        var song = message.valueForKey("song") as String?
        var text = message.message as String?
        if (channel_name == self.user?.id){
            
        }
    }

}

