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
    @IBOutlet weak var mainLabel: UILabel!
    
    var settedTime = 0
    var hour = 0
    var minute = 0
    var second = 0
    
    var switchForDQ = 0
    
    var fixedHour = 0
    var fixedMinute = 0
    var fixedSecond = 0
    
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowDateAndTime()
        pickerFunction()
        
        testLabel.text = "최근 설정한 시분초는 \(String(UserDefaults.standard.integer(forKey: "hour")))시간 or \(String(UserDefaults.standard.integer(forKey: "min")))분 or \(String(UserDefaults.standard.integer(forKey: "sec")))초 이다"

        }


    
    @IBAction func clickConfirm(_ sender: UIButton) {

        
//        hour = settedTime / 3600
//        minute = settedTime / 60
//        second = settedTime
        
        hour = settedTime / 3600
        minute = settedTime / 60
        second = settedTime
        
        UserDefaults.standard.set(hour, forKey: "hour")
        UserDefaults.standard.set(minute, forKey: "min")
        UserDefaults.standard.set(second, forKey: "sec")
        
        
        if switchForDQ == 0{
            // 현재 시각 text로 구하기
            let str = nowData.text
            let hourStartIndex = str!.index(str!.startIndex, offsetBy: 0)// 사용자지정 시작인덱스
            let hourEndIndex = str!.index(str!.startIndex, offsetBy: 2)// 사용자지정 끝인덱스
            let hourString = str![hourStartIndex ..< hourEndIndex]
            
            let minuteStartIndex = str!.index(str!.startIndex, offsetBy: 3)// 사용자지정 시작인덱스
            let minuteEndIndex = str!.index(str!.startIndex, offsetBy: 5)// 사용자지정 끝인덱스
            let minuteString = str![minuteStartIndex ..< minuteEndIndex]
            
            let secondStartIndex = str!.index(str!.startIndex, offsetBy: 6)// 사용자지정 시작인덱스
            let secondEndIndex = str!.index(str!.startIndex, offsetBy: 8)// 사용자지정 끝인덱스
            let secondString = str![secondStartIndex ..< secondEndIndex]
            
            //초로 계산된 걸 시,분,초 로 표현하기
            fixedHour = settedTime / 3600 + Int(hourString)!
            fixedMinute = (settedTime % 3600) / 60 + Int(minuteString)!
            fixedSecond = settedTime % 60 + Int(secondString)!
            
            mainLabel.text = "\(fixedHour)시 \(fixedMinute)분 \(fixedSecond)초에 알람이 울립니다"
            
            //DispatchQueue 3개로 시,분,초 각각 돌아가게끔 만들기
            let myQueue = DispatchQueue(label: "myQueue", attributes: .concurrent)
            let secondQueue = DispatchWorkItem(qos: .userInitiated){
                var countdown = self.second
                for _ in stride(from: 0, to: self.second, by: 1){

                    DispatchQueue.main.async {
                        self.secondLeft.text = String(countdown)
                        countdown -= 1
                        
                        if countdown == 0{
                            let alert = UIAlertController(title:"알람이 끝났습니다",
                                message: "다시 설정하시려면 앱을 재시작해주세요",
                                preferredStyle: UIAlertController.Style.alert)
                            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
                            alert.addAction(confirm)
                            self.present(alert,animated: true,completion: nil)
                        }
                    }
                    usleep(1000000)
                }
                
            }
            
            let minuteQueue = DispatchWorkItem(qos: .userInitiated){
                var countdown = self.minute
                for _ in stride(from: 0, to: self.minute, by: 1){

                    DispatchQueue.main.async {
                        self.minuteLeft.text = String(countdown)
                        countdown -= 1
                    }
                    usleep(60000000)
                }
            }
            
            
            let hourQueue = DispatchWorkItem(qos: .userInitiated){
                var countdown = self.hour
                for _ in stride(from: 0, to: self.hour, by: 1){

                    DispatchQueue.main.async {
                        self.hourLeft.text = String(countdown)
                        countdown -= 1
                    }
                    usleep(3600000000)
                }
            }
            
            myQueue.async(execute: secondQueue)
            myQueue.async(execute: minuteQueue)
            myQueue.async(execute: hourQueue)
            switchForDQ = 1
            

            
            
        }else{
            //1. 경고창 내용 만들기
            let alert = UIAlertController(title:"알람이 이미 실행중입니다.",
                message: "다시 설정하시려면 앱을 재시작해주세요",
                preferredStyle: UIAlertController.Style.alert)
            //2. 확인 버튼 만들기
            let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
            //3. 확인 버튼을 경고창에 추가하기
            alert.addAction(confirm)
            //4. 경고창 보이기
            present(alert,animated: true,completion: nil)
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
        settedTime = Int(time)

    }
}

