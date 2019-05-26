//
//  SettingsViewController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/26/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit
import MessageUI
//import QuoteInfoKit
import UserNotifications

enum Section: Int {
    case preferences
    case about
    case share
}

class SettingsViewController: UIViewController {
    let cellID = "cellID"
    let aboutSectionCellsTitles = ["About Developer", "About Application"]
    let shareSecitonCellTitles = ["Share by Txt", "Share by Email", "Share App on Instagram", "Share on Facebook", "Share on Twitter", "Share on LinkedIn"]
    let preferenceSectionCellTitles = ["Notification"]
    let qotdAvailableIdentifier = "QOTD_AVAILABLE"
    
    lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .white
        tableview.separatorColor = .white
        tableview.backgroundColor = .white
        return tableview
    }()
    
    let notificationCell = UITableViewCell(style: .value1, reuseIdentifier: "")
    let notificationPickerCell = UITableViewCell()
    let notificationPickerIndexPath = IndexPath(row: 1, section: 0)
    var notificationTimeLabel: UILabel!
    var notificationSwitch = UISwitch()
    
    var isNotificationsOn: Bool = false {
        didSet {
            notificationSwitch.setOn(isNotificationsOn, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notifications) in
//            for notif in notifications {
//                print(notif.identifier)
//            }
//        })
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [qotdAvailableIdentifier,])
        if let isOn = UserDefaults.standard.object(forKey: "notificationsOn") as? Bool {
            notificationSwitch.isOn = isOn
        } else {
            notificationSwitch.isOn = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupView()
    }
    
    func setupView() {
        navigationItem.title = "Settings"
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        // construct notification cell
        notificationCell.backgroundColor = .white
        notificationCell.textLabel?.text = "Notifications"
        notificationSwitch.addTarget(self, action: #selector(notificationSwitchChanged), for: .valueChanged)
        notificationCell.accessoryView = notificationSwitch

        
        let qotdAvailableNotificationCategory = UNNotificationCategory(identifier: qotdAvailableIdentifier, actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([qotdAvailableNotificationCategory])
        displayConstraints()
    }
    
    func displayConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func getRandomQuote() -> Quote {
        var quotes = [Quote]()
//        QuoteService.shared.getQuotesOfTheDay {}
//        quotes = QuoteService.shared.qotd
        let randomNum = Int(arc4random_uniform(UInt32(quotes.count)))
        let suggestedQuote = quotes[randomNum]
        return suggestedQuote
    }
    

    
    func prepareNotification(with time: Date) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [qotdAvailableIdentifier,])

        // create notifcation
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }

            let suggestedQuote = self.getRandomQuote()
            // set up content
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = self.qotdAvailableIdentifier
            content.title = "Quotes of The Day are ready!"
            content.subtitle = "Here's one of them!"
            content.body = "Press down to see."
            content.userInfo = [
                AnyHashable("content"): suggestedQuote.content,
                AnyHashable("author"): suggestedQuote.author,
                AnyHashable("film"): suggestedQuote.film.title,
            ]
            content.sound = UNNotificationSound.default

            // configer date for calendar notification
            let datecomponent = Calendar.current.dateComponents([.hour, .minute], from: time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponent, repeats: true)

            // create notification request
            let request = UNNotificationRequest(identifier: self.qotdAvailableIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func setNotification() {
        // create notifcation
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            let suggestedQuote = self.getRandomQuote()
            
            // set up content
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = self.qotdAvailableIdentifier
            content.title = "Quotes of The Day are ready!"
            content.subtitle = "Here's one of them!"
            content.body = "Press down to see."
            content.userInfo = [
                AnyHashable("content"): suggestedQuote.content,
                AnyHashable("author"): suggestedQuote.author,
                AnyHashable("film"): suggestedQuote.film.title,
            ]
            content.sound = UNNotificationSound.default
            
            // configer date for calendar notification
//            let datecomponent = Calendar.current.dateComponents([.hour, .minute], from: time)
//            let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponent, repeats: true)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            
            // create notification request
            let request = UNNotificationRequest(identifier: self.qotdAvailableIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [qotdAvailableIdentifier,])
    }
    
    func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error ) in
            if granted {
                print("User notifications are allowed.")
            } else {
                print("User notifications are NOT allowed.")
            }
        }
    }
    
    func sendToSettingsToSetNotifications() {
        let alertController = UIAlertController(title: "Notification Alert", message: "please enable notifications", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            self.isNotificationsOn = false
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //
    // MARK - Action Functions
    //
    @objc func notificationSwitchChanged() {
        if notificationSwitch.isOn {
            requestNotifications()
            setNotification()
            UserDefaults.standard.set(true, forKey: "notificationsOn")
        } else {
            removeNotification()
            UserDefaults.standard.set(false, forKey: "notificationsOn")
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let settingsSection = Section(rawValue: section) else { fatalError() }
        
        switch settingsSection {
        case .preferences:
            return 1
        case .about:
            return aboutSectionCellsTitles.count
        case .share:
            return shareSecitonCellTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        guard let section = Section(rawValue: indexPath.section) else { fatalError() }
        
        let titleLableText: String
        switch section {
        case .preferences:
            switch indexPath.row {
            case 0: return notificationCell
            default: fatalError()
            }
        case .about:
            titleLableText = aboutSectionCellsTitles[indexPath.row]
        case .share:
            titleLableText = shareSecitonCellTitles[indexPath.row]
        }
        
        cell.textLabel?.text = titleLableText
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionHeaders = Section(rawValue: section) else { fatalError() }
        
        switch sectionHeaders{
        case .preferences:
            return "Application"
        case .about:
            return "About"
        case .share:
            return "Share"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .lightGray
        header.textLabel?.font = UIFont(name: Font.Animosa.Bold, size: 15)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch (indexPath.section, indexPath.row) {
//        case (notificationPickerIndexPath.section, notificationPickerIndexPath.row - 1):
//                requestNotifications()
//                if isNotificationPickerShown {
//                    if notificationTimeLabel.text != "Time" {
//                        let time = notificationPicker.date
//                        UserDefaults.standard.set(time, forKey: "dailyNotificationTime")
//                        prepareNotification(with: time)
//                    }
//                    isNotificationPickerShown = false
//                    updateTimeView()
//                } else {
//                    isNotificationPickerShown = true
//                }
//                tableView.beginUpdates()
//                tableView.endUpdates()
//        default: break
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (2, 0):
            if MFMessageComposeViewController.canSendText() {
                let composeVC = MFMessageComposeViewController()
                composeVC.disableUserAttachments()
                composeVC.messageComposeDelegate = self
                composeVC.body = "This is cool text"
                
                present(composeVC, animated: true, completion: nil)
            } else {
                print("can't send text")
            }
        case (2, 1):
            if MFMailComposeViewController.canSendMail() {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                composeVC.setSubject("Check this new application")
                composeVC.setMessageBody("You have to check this new app out", isHTML: false)
                
                present(composeVC, animated: true, completion: nil)
            } else {
                print("cant send email")
            }
        default:
            print("nothing")
        }
    }
    
    
    func funcToBeNamed() {
        guard let savedTime = UserDefaults.standard.object(forKey: "dailyNotificationTime") as? String else { return }
        let date = notificationTimeLabel.text
        if date == savedTime {
            print("true")
        } else { print("false") }
    }
    
}

extension SettingsViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // dismish the message compose view controller
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // dismish the message compose view controller
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIView {
    func anchor(inside view: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }
}

