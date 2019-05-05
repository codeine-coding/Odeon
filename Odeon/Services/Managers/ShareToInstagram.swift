//////
//////  InstagramManager.swift
//////  InstagramSDK
//////
//////  Created by Attila Roy on 23/02/15.
//////  share image with caption to instagram
////import UIKit
////
////private let documentInteractionController = UIDocumentInteractionController()
////
////class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
////
////    let vc = UIViewController()
////
////    private let kInstagramURL = "instagram://"
////    private let kUTI = "com.instagram.exclusivegram"
////    private let kfileNameExtension = "instagram.igo"
////    private let kAlertViewTitle = "Error"
////    private let kAlertViewMessage = "Please install the Instagram application"
////
////    // singleton manager
////    class var sharedManager: InstagramManager {
////        struct Singleton {
////            static let instance = InstagramManager()
////        }
////        return Singleton.instance
////    }
////
////    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView) {
////        // called to post image with caption to the instagram application
////
////        let instagramURL = NSURL(string: kInstagramURL)
////        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
////            let jpgPath = NSTemporaryDirectory().appending(kfileNameExtension)
////            // var jpgPath = NSTemporaryDirectory().stringByAppendingPathComponent(kfileNameExtension)
////            try? imageInstagram.jpegData(compressionQuality: 1.0)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
////            // UIImageJPEGRepresentation(imageInstagram, 1.0).writeToFile(jpgPath, atomically: true)
////            let rect = view.frame
////            // var fileURL = NSURL.fileURLWithPath(jpgPath)
////            let fileURL = URL(fileURLWithPath: jpgPath)
////            let documentInteractionController = UIDocumentInteractionController()
////            documentInteractionController.url = fileURL
////            documentInteractionController.delegate = self
////            documentInteractionController.uti = kUTI
////
////            // adding caption for the image
////            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
////            documentInteractionController.presentOpenInMenu(from: rect, in: view, animated: true)
////        }
////        else {
////
////            // alert displayed when the instagram application is not available in the device
////            let alertController = UIAlertController(title: kAlertViewTitle, message: kAlertViewMessage, preferredStyle: .alert)
////            let alertAction = UIAlertAction(title: "ok", style: .default, handler: nil)
////            alertController.addAction(alertAction)
////            vc.present(alertController, animated: true)
////            // UIAlertView(title: kAlertViewTitle, message: kAlertViewMessage, delegate:nil, cancelButtonTitle:"Ok").show()
////        }
////    }
////}
//
//
//import UIKit
//
//class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
//    
//    static let kInstagramURL = "instagram://app"
//    static let kAlertViewTitle = "Error"
//    static let kAlertViewMessage = "Please install the Instagram application"
//    private let kUTI = "com.instagram.exclusivegram"
//    private let kfileNameExtension = "instagram.igo"
//    
//    var documentInteractionController = UIDocumentInteractionController()
//    
//    // singleton manager
//    class var sharedManager: InstagramManager {
//        struct Singleton {
//            static let instance = InstagramManager()
//        }
//        return Singleton.instance
//    }
//    
//    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView) {
//        // called to post image with caption to the instagram application
//        
//        let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
//        
//        do {
//            try imageInstagram.jpegData(compressionQuality: 1.0)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
//            
//        } catch {
//            
//            print(error)
//        }
//        
//        // let rect = CGRect(x: 0, y: 0, width: 1024, height: 1024)
//        let fileURL = NSURL.fileURL(withPath: jpgPath)
//        documentInteractionController.url = fileURL
//        documentInteractionController.delegate = self
//        documentInteractionController.uti = kUTI
//        
//        // adding caption for the image
//        documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
//        documentInteractionController.presentOpenInMenu(from: view.frame, in: view, animated: true)
//    }
//}
