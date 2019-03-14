
    import UIKit
    import Foundation
    import MessageUI

    class AddEditTableViewController: UITableViewController , MFMailComposeViewControllerDelegate {
        
        var iTunes: StoreItem?
        var myImage: UIImage?
        
        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var artistLabel: UILabel!
        @IBOutlet weak var kindLabel: UILabel!
        @IBOutlet weak var descriptionLabel: UILabel!
        @IBOutlet weak var favoriteButton: UITabBarItem!
        @IBOutlet weak var addToFavoriteButton: UIBarButtonItem!
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if let iTunes = iTunes {
                nameLabel.text = iTunes.name
                artistLabel.text = iTunes.artist
                kindLabel.text = iTunes.kind
                descriptionLabel.text = iTunes.description
                imageView.image = myImage
            }
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                imageView.image = selectedImage
                dismiss(animated: true, completion: nil)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
        @IBAction func addToFavoriteLists(_ sender: UIBarButtonItem) {
            
            if let item = iTunes {
                let description = item.kind
                switch description {
                case "ebook":
                    favoriteBooks.append(item)
                    print(favoriteBooks)
                    
                case "software":
                    favoriteApps.append(item)
                    print(favoriteApps)
                    
                case "feature-movie":
                    favoriteMovies.append(item)
                    print(favoriteMovies)
                    
                case "song":
                    favoriteMusic.append(item)
                    print(favoriteMusic)
                    
                default:
                    print("ddeefaulttt")
                }
            }
            
            favoriteButton.badgeValue = "★"
            addToFavoriteButton.title = "Favorited"
            addToFavoriteButton.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        
        @IBAction func shareButton(_ sender: UIButton) {
            
            guard let image = imageView.image else {return}
            guard let name = iTunes?.name else {return}
            guard let artist = iTunes?.artist else {return}
            
            let activityController = UIActivityViewController(activityItems:
                [image,name,artist], applicationActivities: nil)
            
            activityController.popoverPresentationController?.sourceView = sender
            present(activityController, animated: true, completion: nil)
            
        }
        
        @IBAction func emailButton(_ sender: UIButton) {
            
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["Miad.mma@gmail.com"])
                mail.setMessageBody("<p>This is from iOS app!", isHTML: true)
                present(mail, animated: true, completion: nil)
            } else {
                print("mail service is not available")
            }
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error : Error?) {
            print("mail didFinishWith")
            dismiss(animated: true, completion: nil)
        }
    }

