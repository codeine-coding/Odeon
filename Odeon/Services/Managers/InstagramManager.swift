////
////  InstagramManager.swift
////  InstagramSDK
////
////  Created by Attila Roy on 23/02/15.
////  share image with caption to instagram
import UIKit

class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {

    static let kInstagramURL = "instagram://app"
    static let kAlertViewTitle = "Error"
    static let kAlertViewMessage = "Please install the Instagram application"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"

    var documentInteractionController = UIDocumentInteractionController()

    // singleton manager
    class var sharedManager: InstagramManager {
        struct Singleton {
            static let instance = InstagramManager()
        }
        return Singleton.instance
    }
    
    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView) {
        // called to post image with caption to the instagram application

        let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
        
        do {
            try imageInstagram.jpegData(compressionQuality: 1.0)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)

        } catch {

            print(error)
        }

        // let rect = CGRect(x: 0, y: 0, width: 1024, height: 1024)
        let fileURL = NSURL.fileURL(withPath: jpgPath)
        documentInteractionController.url = fileURL
        documentInteractionController.delegate = self
        documentInteractionController.uti = kUTI

        // adding caption for the image
        documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
        documentInteractionController.presentOpenInMenu(from: view.frame, in: view, animated: true)
    }

    func copyTextToInstagram(_ quote: Quote? ) {
        guard let quote = quote else { return }
        let textCaption = """
        \"\(quote.content)\"
        - \(quote.author)
        \(quote.film.title) [\(quote.film.type.title)]
        .
        .
        .
        .
        ——————————————————
        #motivationalquotes #motivation #motivationquotes #life #lifequotes #photography #love #photooftheday #beautiful #behappy #succes #succesquotes #inspiration #inspirationalquotes #inspiringquotes #deep #deepquotes #moviequotes #successfulmindset #successday #successhabits #successmindset #successful #successstories #successmotivation #successfulliving
        """
        UIPasteboard.general.string = textCaption
    }
}
