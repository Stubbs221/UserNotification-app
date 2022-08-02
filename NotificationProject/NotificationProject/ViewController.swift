//
//  ViewController.swift
//  NotificationProject
//
//  Created by MAC on 02.08.2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.delegate = self
        setupUI()
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("\(granted)")
        }
    }

// MARK: Properties
    
    let notificationCenter = UNUserNotificationCenter.current()

    let content: UNMutableNotificationContent = {
        let content = UNMutableNotificationContent()
        content.title = "Notification title"
        content.body = "Notification body"
        content.sound = .defaultRingtone
        return content
    }()
    
    lazy var labelForTimer: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.font = UIFont(name: "Arial", size: 40)
        label.textColor = UIColor(named: "firstColor")
        return label
    }()
    
    lazy var labelForDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Set interval in seconds"
        label.font = UIFont(name: "Arial", size: 36)
        label.textColor = UIColor(named: "firstColor")
        return label
    }()
    
    lazy var buttonStart: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor(named: "secondColor")
        button.tintColor = UIColor(named: "firstColor")
        button.titleLabel?.font = UIFont(name: "Arial", size: 36)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.stepValue = 1
        stepper.maximumValue = 10
        stepper.minimumValue = 1
        stepper.backgroundColor = UIColor(named: "secondColor")
        stepper.layer.cornerRadius = 5
        stepper.tintColor = UIColor(named: "thirdColor")
        stepper.addTarget(self, action: #selector(stepperChanged), for: .touchUpInside)
        return stepper
    }()
    
//    MARK: Actions
    
    @objc private func stepperChanged() {
        labelForTimer.text = String(Int(stepper.value))
    }
    
    @objc private func buttonPressed() {
        content.body = "Timer is set to \(labelForTimer.text)"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (labelForTimer.text as! NSString).doubleValue, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            print("OK!!!")
        }
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
    }
}
// MARK: SetupUI

extension ViewController {
    private func setupUI() {
        view.addSubview(labelForDescription)
        view.addSubview(labelForTimer)
        view.addSubview(stepper)
        view.addSubview(buttonStart)
        
        view.backgroundColor = UIColor(named: "thirdColor")
        
        NSLayoutConstraint.activate([
            labelForDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelForDescription.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            ])
        
        NSLayoutConstraint.activate([
            labelForTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelForTimer.topAnchor.constraint(equalTo: labelForDescription.bottomAnchor, constant: 50)])
        
        NSLayoutConstraint.activate([
            stepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepper.topAnchor.constraint(equalTo: labelForTimer.bottomAnchor, constant: 50),
        ])
        
        NSLayoutConstraint.activate([
            buttonStart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStart.topAnchor.constraint(equalTo: stepper.bottomAnchor, constant: 50),
            buttonStart.heightAnchor.constraint(equalToConstant: 70),
            buttonStart.widthAnchor.constraint(equalToConstant: 200),])
    }
}
