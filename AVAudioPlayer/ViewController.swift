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
            player = AVAudioPlayer(contentsOfURL: resourceURL, error: &error)
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
                enableTimer()
                player!.delegate = self
            }
        
    }
    
    
    @IBAction func didPressedStopButton(sender: AnyObject) {
        if(player != nil){
            if(player?.playing == true){
                endTimer()
                player!.pause()
                stopButton.setTitle("Resume", forState: UIControlState.Normal)
            }else{
                player!.play()
                enableTimer()
                stopButton.setTitle("Stop", forState: UIControlState.Normal)
            }
            
        }
    }
    
    
    @IBAction func didPressedReplayButton(sender: AnyObject) {
        if player != nil{
            endTimer()
            player = nil
            stopButton.setTitle("Stop", forState: UIControlState.Normal)
            didPressedPlayButton(replayButton)
        }
        
    }
    
    
//delegate
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        endTimer()
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
        if(player != nil){
            timer = NSTimer(timeInterval: 0.1, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer!, forMode: "NSDefaultRunLoopMode")
        }
    }
    func endTimer(){
        if(timer != nil){
            timer!.invalidate()
        }
    }

    func updateProgress(){
        if(player != nil){
            player!.updateMeters() //refresh state
            audioProgress.progress = Float(player!.currentTime/player!.duration)
            average1.text = "LAvrg:\(player!.averagePowerForChannel(0))"
            average2.text = "RAvrg:\(player!.averagePowerForChannel(1))"
            peak1.text = "LPeak:\(player!.peakPowerForChannel(0))"
            peak2.text = "RPeak:\(player!.peakPowerForChannel(1))"
        }
    }
    
}
