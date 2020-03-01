//
//  ViewController.swift
//  BasketballScoreboard
//
//  Created by Kicher on 28/08/2017.
//  Copyright © 2017 Kicher. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var txt_red_score: UITextField!
    @IBOutlet weak var btn_time: UIButton!
    @IBOutlet weak var txt_blue_score: UITextField!
    @IBOutlet weak var lb_quater: UILabel!
    @IBOutlet weak var txt_limit_time: UITextField!
    var snd_player = AVAudioPlayer()
    var timer = Timer()
    var limit_timer = Timer()
    var red_score:Int = 0
    var blue_score:Int = 0
    var time_minute:Int = 0
    var time_second:Int = 0
    var limit_time:Int = 0
    var quater:Int = 0
    var timer_state:Bool = false;
    var limit_timer_state:Bool = false;
    
    let end_snd = Bundle.main.path(forResource: "end", ofType: "mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        init_app()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func init_app()
    {
        UIApplication.shared.isIdleTimerDisabled = true
        
        /*
        btn_time.layer.borderColor = UIColor.white.cgColor
        btn_time.layer.borderWidth = 2
        btn_time.layer.cornerRadius = 10
        */
        
        do
        {
            snd_player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: end_snd!))
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch
        {
            print(error)
        }
        
        reset()
    }
    
    func reset()
    {
        stop_timer()
        stop_limit_timer()
        
        red_score = 0
        blue_score = 0
        quater = 1
        
        reset_time()
        setTime()
        set_limit_time()
        txt_red_score.text = "\(red_score)"
        txt_blue_score.text = "\(blue_score)"
        lb_quater.text = "\(quater) Quater"
    }
    
    func reset_time()
    {
        time_minute = 10
        time_second = 0
        limit_time = 240
    }

    func start_timer()
    {
        if timer_state {
            timer.invalidate()
        }
        
        timer_state = true
        timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(update_timer), userInfo:nil, repeats:true)
    }
    
    func stop_timer()
    {
        if timer_state {
            timer_state = false;
            timer.invalidate()
        }
    }
    
    func update_timer()
    {
        play_basketball_with_time()
        setTime()
    }
    
    func toggle_timer()
    {
        if timer_state {
            stop_timer()
        }
        else
        {
            start_timer()
        }
    }
    
    func start_limit_timer()
    {
        if limit_timer_state {
            limit_timer.invalidate()
        }
        
        limit_timer_state = true
        limit_timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(update_limit_timer), userInfo:nil, repeats:true)
    }
    
    func stop_limit_timer()
    {
        if limit_timer_state {
            limit_timer_state = false;
            limit_timer.invalidate()
        }
    }
    
    func update_limit_timer()
    {
        play_basketball_with_limit_time()
        set_limit_time()
    }
    
    func toggle_limit_timer()
    {
        if limit_timer_state {
            stop_limit_timer()
        }
        else
        {
            start_limit_timer()
        }
    }
    
    func play_basketball_with_time()
    {
        if time_second > 0 {
            time_second -= 1
            if time_minute == 0 && time_second == 0 {
                end_playtime()
            }
        }
        else{
            if time_minute > 0 {
                time_minute -= 1
                time_second = 599
            }
            else{
                end_playtime()
            }
        }
    }
    
    func play_basketball_with_limit_time()
    {
        if limit_time > 0 {
            limit_time -= 1
            if limit_time == 0 {
                end_limit_time()
            }
        }
        else{
            end_limit_time()
        }
    }
    
    func end_playtime()
    {
        snd_player.play()
        change_quater()
    }
    
    func end_limit_time()
    {
        snd_player.play()
        stop_limit_timer()
    }
    
    func setTime()
    {
        if time_minute > 0
        {
            btn_time.setTitle("\(String(format: "%02d", time_minute)):\(String(format: "%02d", time_second / 10))", for: .normal)
        }
        else
        {
            btn_time.setTitle("\(String(format: "%02d", time_second / 10)).\(time_second % 10)", for: .normal)
        }
    }
    
    func set_limit_time()
    {
        if limit_time > 240
        {
            txt_limit_time.text = "\(limit_time / 10)"
        }
        else
        {
            txt_limit_time.text = "\(String(format: "%02d", limit_time / 10)).\(limit_time % 10)"
        }
    }
    
    func change_quater()
    {
        stop_timer()
        stop_limit_timer()
        reset_time()
        
        quater += 1
        lb_quater.text = "\(quater) Quater"
        setTime()
        set_limit_time()
    }
    
    // Red Buttons
    @IBAction func OnTouchUpInside_btn_red_1p(_ sender: UIButton) {
        red_score += 1
        txt_red_score.text = "\(red_score)"
    }
    
    @IBAction func OnTouchUpInside_btn_red_2p(_ sender: UIButton) {
        red_score += 2
        txt_red_score.text = "\(red_score)"
    }
    
    @IBAction func OnTouchUpInside_btn_red_3p(_ sender: UIButton) {
        red_score += 3
        txt_red_score.text = "\(red_score)"
    }
    
    @IBAction func OnTouchUpInside_btn_red_plus(_ sender: UIButton) {
        red_score += 1
        txt_red_score.text = "\(red_score)"
    }
    
    @IBAction func OnTouchUpInside_btn_red_minus(_ sender: UIButton) {
        if red_score > 0
        {
            red_score -= 1
            txt_red_score.text = "\(red_score)"
        }
    }

    // Time and Limit Time Buttons
    @IBAction func OnTouchUpInside_btn_ltime_24t(_ sender: UIButton) {
        limit_time = 240
        set_limit_time()
        
        if timer_state
        {
            start_limit_timer()
        }
    }
    
    @IBAction func OnTouchUpInside_btn_ltime_14t(_ sender: UIButton) {
        limit_time = 140
        set_limit_time()
        
        if timer_state
        {
            start_limit_timer()
        }
    }
    
    @IBAction func OnTouchUpInside_btn_time_mplus(_ sender: UIButton) {
        if time_minute < 99 {
            time_minute += 1
            setTime()
        }
    }
    
    @IBAction func OnTouchUpInside_btn_time_mminus(_ sender: UIButton) {
        if time_minute > 0 {
            time_minute -= 1
            setTime()
        }
    }
    
    @IBAction func OnTouchUpInside_btn_time_splus(_ sender: UIButton) {
        if time_second < 590 {
            time_second += 10
        }
        else{
            time_second = time_second % 10
        }
        
        setTime()
    }
    
    @IBAction func OnTouchUpInside_btn_time_sminus(_ sender: UIButton) {
        if time_second > 10 {
            time_second -= 10
        }
        else{
            time_second = 590 + (time_second % 10)
        }
        
        setTime()
    }
    
    @IBAction func OnTouchUpInsid_btn_time(_ sender: UIButton) {
        toggle_timer()
        toggle_limit_timer()
    }
    
    @IBAction func OnTouchUpInside_btn_reset_all(_ sender: UIButton) {
        reset()
    }
    
    
    // Blue Buttons
    @IBAction func OnTouchUpInside_btn_blue_1p(_ sender: UIButton) {
        blue_score += 1
        txt_blue_score.text = "\(blue_score)"
    }
    
    @IBAction func OnTouchUpInside_btn_blue_2p(_ sender: UIButton) {
        blue_score += 2
        txt_blue_score.text = "\(blue_score)"
    }
    
    @IBAction func OnTouchUpInside_btn_blue_3p(_ sender: UIButton) {
        blue_score += 3
        txt_blue_score.text = "\(blue_score)"
    }
    
    @IBAction func OnTouchUpInside_btn_blue_plus(_ sender: UIButton) {
        blue_score += 1
        txt_blue_score.text = "\(blue_score)"
    }
    
    @IBAction func OnTouchUpInside_btn_blue_minus(_ sender: UIButton) {
        if blue_score > 0 {
            blue_score -= 1
            txt_blue_score.text = "\(blue_score)"
        }
    }
}

