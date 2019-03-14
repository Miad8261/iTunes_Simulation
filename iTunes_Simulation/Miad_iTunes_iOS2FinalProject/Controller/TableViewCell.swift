        //
        //  TableViewCell.swift
        //  Miad_iTunes_iOS2FinalProject
        //
        //  Created by mobileapps on 2019-02-14.
        //  Copyright © 2019 mobileapps. All rights reserved.
        //

        import UIKit

        class TableViewCell: UITableViewCell {

            @IBOutlet weak var imageViewImage: UIImageView!
            @IBOutlet weak var nameLabel: UILabel!
            @IBOutlet weak var artistLabel: UILabel!
            
            func update(with storeItem: StoreItem) -> Void {
                guard let url = storeItem.artworkURL.withHTTPS() else { return }
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data,
                        let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.nameLabel.text = storeItem.name
                            self.artistLabel.text = storeItem.artist
                            self.imageViewImage.image = image
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }
                }
                task.resume()
            }
        }
