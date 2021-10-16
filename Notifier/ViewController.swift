//
//  ViewController.swift
//  Notifier
//
//  Created by Abdulrahman on 10/16/21.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal(){
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.badge,.sound]){
            granted, error in
            
            if granted {
                print("yay")
                
            } else {
                print("oh no")
            }
        }
    }
    
    @objc func scheduleLocal(){
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["CustomData": "FizzBuzz"]
        
        content.sound = .default
        
        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 40
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }

    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let showMeMore =  UNNotificationAction(identifier: "showMeMore", title: "Show me more", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "alarm", actions: [showMeMore], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["CustomData"] as? String {
            print("Custom Data: \(customData))")
            switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    //the user swiped to unlock
                    print("Default identifier")
                    
                case "showMeMore":
                    print("Show more Informations")
                    
                default:
                    break
            }
        }
        completionHandler()
    }

}

