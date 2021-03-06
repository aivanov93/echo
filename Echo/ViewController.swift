//
//  ViewController.swift
//  Echo
//
//  Created by Dang Pham on 3/1/15.
//  Copyright (c) 2015 Quartet. All rights reserved.
//

import UIKit




class ViewController: UIViewController, SPTAuthViewDelegate {
    
    
    let ClientID = "782ed7079eef47cdb3d0d21df4cc9db3"
    let CallbackURL = "echo://returnAfterLogin"
    let kTokenSwapURL = "http://mysterious-waters-9692.herokuapp.com/swap"
    let kTokenRefreshServiceURL = "http://mysterious-waters-9692.herokuapp.com/refresh"
    let auth = SPTAuth.defaultInstance()
    @IBOutlet weak var loginButton: UIButton!
    
    
    var session:SPTSession!
    var user: SPTUser!
    var collection: MusicCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateAfterFirstLogin", name: "loginSuccessfull", object: nil)
//        
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        
//        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession") { // session available
//            let sessionDataObj = sessionObj as NSData
//            
//            let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as SPTSession
//            
//            if !session.isValid() {
//                SPTAuth.defaultInstance().renewSession(session, callback: { (error:NSError!, renewdSession:SPTSession!) -> Void in
//                    if error == nil {
//                        let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
//                        userDefaults.setObject(sessionData, forKey: "SpotifySession")
//                        userDefaults.synchronize()
//                        self.session = renewdSession
//                    }else{
//                        println("error refreshing session")
//                    }
//                })
//            }else{
//                println("session valid")
//                self.session = session
//            }
//        }else{
//        }
        
        
    }
    
    func updateAfterFirstLogin () {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession") {
            let sessionDataObj = sessionObj as NSData
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as SPTSession
            self.session = firstTimeSession
            SPTRequest.userInformationForUserInSession(self.session, callback:
                {(error: NSError!, userInfo: AnyObject!) -> Void in
                    self.user = userInfo as SPTUser
                    println(self.user)
                    println(self.user.displayName)
                    println(self.user.followerCount)
                    //println(self.user.largestImage.imageURL)
                    
                    })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func loginWithSpotify(sender: AnyObject) {
        auth.clientID = ClientID
        auth.requestedScopes = [SPTAuthStreamingScope,SPTAuthUserReadEmailScope,SPTAuthUserLibraryReadScope,SPTAuthUserReadPrivateScope,SPTAuthPlaylistReadPrivateScope,SPTAuthPlaylistModifyPrivateScope,SPTAuthPlaylistModifyPublicScope]
        auth.redirectURL = NSURL(string: CallbackURL)
        auth.tokenSwapURL = NSURL(string: kTokenSwapURL)
        auth.tokenRefreshURL = NSURL(string: kTokenRefreshServiceURL)
        
        let authView = SPTAuthViewController.authenticationViewController()
        authView.delegate = self
        authView.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        authView.definesPresentationContext = true
        presentViewController(authView, animated: false, completion: nil)
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        self.session = session
        println("session valid")
        SPTRequest.userInformationForUserInSession(self.session, callback: {(error: NSError!, user: AnyObject!) -> Void in
            if error != nil {
                println("error lmao")
            } else {
                self.user = user as SPTUser
                println(self.user.emailAddress)
                var scrapper = Scrapper(session: self.session, user: self.user)
                
                //var scrapper = Scrapper(session: self.session, user: self.user)
                //scrapper.retrievePlaylists()
                
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.session = self.session
                var prefs: [Int] = []
                var a: [String] = []
                var sc: [String: Int] = ["":0]
                var alb: [String: [String]] = ["":[]]
                var musicCollec = MusicCollection(artists: a, songCounts: sc, albums: alb);
                println(self.user.emailAddress)
                
                var username: String
                if (self.user.displayName == "<null>") {
                    println("here")
                    println(self.user.canonicalUserName)
                    username = self.user.canonicalUserName
                } else {
                    username = self.user.displayName
                }
                appDelegate.user = User(displayName: username, email: self.user.emailAddress, preferences: prefs)
                scrapper.scrape(appDelegate.user!)
                if (self.user.largestImage != nil){
                    appDelegate.user?.picURL = self.user.largestImage.imageURL
                }
            }
        })
        performSegueWithIdentifier("leaveLogIn", sender: nil)


    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        println("login cancelled")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        println("login failed")
    }



}

