//
//  ViewController.swift
//  AVAudioPlayer
//
//  Created by 端 闻 on 24/12/14.
//  Copyright (c) 2014年 monk-studio. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var audioProgress: UIProgressView!
    
    @IBOutlet weak var average1: UILabel!
    @IBOutlet weak var average2: UILabel!
    @IBOutlet weak var peak1: UILabel!
    @IBOutlet weak var peak2: UILabel!
    
    
    
    
    var player:AVAudioPlayer?
    var playing:Bool = false
    var timer:NSTimer?
    override func viewDidLoad() {
        super.viewDidLoad()
        //basic init
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didPressedPlayButton(sender: AnyObject) {
        if(player == nil){
            var resourceURL = NSBundle.mainBundle().URLForResource("audioFX", withExtension: "mp3")
            var error:NSError? = NSError()
            player = AVAudioPlayer(contentsOfURL: resourceURL?, error: &error)
            player!.meteringEnabled = true
            player!.prepareToPlay() //add into the buffer
        }
        if(player != nil){
                //setting up the speed
//                player!.enableRate = true
//                player!.rate = 0.5 //0.5 represents half speed
//                player!.rate = 2  // 2 represents 2 times speed
                //delay the play
//                var delayTime = 2.0
//                player!.playAtTime(player!.deviceCurrentTime+delayTime)
                
                player!.play()
                self.enableTimer()
                player!.delegate = self
                self.playing = true
            }
        
    }
    
    
    @IBAction func didPressedStopButton(sender: AnyObject) {
        if(player != nil){
            if(self.playing == true){
                self.endTimer()
                player!.pause()
                stopButton.setTitle("Resume", forState: UIControlState.Normal)
                playing = false
            }else{
                player!.play()
                self.enableTimer()
                stopButton.setTitle("Stop", forState: UIControlState.Normal)
                playing = true
            }
            
        }
    }
    
    
    @IBAction func didPressedReplayButton(sender: AnyObject) {
        if(player != nil){
            self.endTimer()
            self.player = nil
            stopButton.setTitle("Stop", forState: UIControlState.Normal)
            self.didPressedPlayButton(replayButton)
        }
        
    }
    
    
//delegate
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        self.endTimer()
        self.playing = false
        
    }
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("\(error)  in  \(player)")
    }
//IOS8和IOS6 删掉了下面的API，做成了自动的
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
        //here code when player interrupted
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer!) {
        //here code when player end being interrupted
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer!, withFlags flags: Int) {
        //flag interruption
    }
    func audioPlayerEndInterruption(player: AVAudioPlayer!, withOptions flags: Int) {
        //option interruption
    }
    
    
    
//tIMER
    func enableTimer(){
        if(self.player != nil){
            timer = NSTimer(timeInterval: 0.1, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: "NSDefaultRunLoopMode")
        }
    }
    func endTimer(){
        if(self.timer != nil){
            timer!.invalidate()
        }
    }

    func updateProgress(){
        if(self.player != nil){
            self.player!.updateMeters() //refresh state
            self.audioProgress.progress = Float(self.player!.currentTime/self.player!.duration)
            self.average1.text = "LAvrg:\(self.player!.averagePowerForChannel(0))"
            self.average2.text = "RAvrg:\(self.player!.averagePowerForChannel(1))"
            self.peak1.text = "LPeak:\(self.player!.peakPowerForChannel(0))"
            self.peak2.text = "RPeak:\(self.player!.peakPowerForChannel(1))"
        }
    }
    
}

