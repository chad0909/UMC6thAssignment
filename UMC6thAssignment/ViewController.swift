//
//  ViewController.swift
//  UMC6thAssignment
//
//  Created by 077tech on 2022/11/03.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nowData: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var hourLeft: UILabel!
    @IBOutlet weak var minuteLeft: UILabel!
    @IBOutlet weak var secondLeft: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    
    var settedTime = 0
    var hour = 0
    var minute = 0
    var second = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowDateAndTime()
        pickerFunction()
        
        }
    
    @IBAction func clickConfirm(_ sender: UIButton) {
        hour = settedTime / 3600
        minute = settedTime / 60
        second = settedTime
        
        DispatchQueue.global().async {
            var countdown = self.second
            for _ in stride(from: 0, to: self.second, by: 1){
                DispatchQueue.main.async {
                    self.secondLeft.text = String(countdown)
                    countdown -= 1
                }
                usleep(1000000)
            }
        }
        
        DispatchQueue.global().async {
            var countdown = self.minute
            for _ in stride(from: 0, to: self.minute, by: 1){
                DispatchQueue.main.async {
                    self.minuteLeft.text = String(countdown)
                    countdown -= 1
                }
                usleep(60000000)
            }
        }
        
        DispatchQueue.global().async {
            var countdown = self.hour
            for _ in stride(from: 0, to: self.hour, by: 1){
                DispatchQueue.main.async {
                    self.hourLeft.text = String(countdown)
                    countdown -= 1
                }
                usleep(3600000000)
            }
        }
        
        
    }
    func nowDateAndTime(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.string(from: Date())
        self.nowData.text = time
    }
    
    func pickerFunction(){
        timePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
    }
    
    @objc func changed(){
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        let time = timePicker.countDownDuration
        testLabel.text = String(time)
        settedTime = Int(time)

    }
}

