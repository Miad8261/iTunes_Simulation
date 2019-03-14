        //
        //  FavoritesViewController.swift
        //  Miad_iTunes_iOS2FinalProject
        //
        //  Created by mobileapps on 2019-02-19.
        //  Copyright © 2019 mobileapps. All rights reserved.
        //

        import UIKit

        class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
            
            var segmentItems = "movie"
            
            @IBOutlet weak var tableView: UITableView!
            @IBOutlet weak var segmentedControlMedia: UISegmentedControl!
            @IBOutlet weak var searchBarSearch: UISearchBar!
            @IBOutlet weak var saveButton: UIBarButtonItem!
            @IBOutlet weak var editButton: UIBarButtonItem!
            
            override func viewDidLoad() {
                super.viewDidLoad()
                
                tableView.dataSource = self
                tableView.delegate = self
                searchBarSearch.delegate = self
                tableView.rowHeight = UITableView.automaticDimension
                tableView.estimatedRowHeight = 44.0
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                favoritesItems = favoriteMovies
            }
            
            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                
                if segmentedControlMedia.selectedSegmentIndex == 0 {
                    favoritesItems = favoriteMovies
                    
                } else if segmentedControlMedia.selectedSegmentIndex == 1 {
                    favoritesItems = favoriteMusic
                    
                } else if segmentedControlMedia.selectedSegmentIndex == 2 {
                    favoritesItems = favoriteApps
                    
                } else if segmentedControlMedia.selectedSegmentIndex == 3 {
                    favoritesItems = favoriteBooks
                    
                }
                tableView.reloadData()
            }
            
            @IBAction func SegmentSelected(_ sender: UISegmentedControl) {
                if sender.selectedSegmentIndex == 0 {
                    favoritesItems = favoriteMovies
                    
                } else if sender.selectedSegmentIndex == 1 {
                    favoritesItems = favoriteMusic
                    
                } else if sender.selectedSegmentIndex == 2 {
                    favoritesItems = favoriteApps
                    
                } else if sender.selectedSegmentIndex == 3 {
                    favoritesItems = favoriteBooks
                    
                }
                tableView.reloadData()
            }
            
            @IBAction func sortButton(_ sender: UIBarButtonItem) {
                
                favoritesItems = favoritesItems.sorted(by: {$0.name < $1.name})
                tableView.reloadData()
            }
            
            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return favoritesItems.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let favorites = favoritesItems[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! TableViewCell
                cell.update(with: favorites)
                return cell
            }
            
            @IBAction func editButtonTabbed(_ sender: UIBarButtonItem) {
                let tableViewEditingMode = tableView.isEditing
                tableView.setEditing(!tableViewEditingMode, animated: true)
                if editButton.title == "Edit" {
                    editButton.title = "Done"
                    editButton.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                } else if editButton.title == "Done" {
                    editButton.title = "Edit"
                    editButton.tintColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                }
            }
            
            func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
                return .delete
            }
            
            func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle == .delete {
                    favoritesItems.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    save()
                } else if editingStyle == .delete {
                }
            }
            
            func tableView(_ tableView: UITableView,
                           moveRowAt fromIndexPath: IndexPath,
                           to: IndexPath) {
                let moveItunes = favoritesItems.remove(at: fromIndexPath.row)
                favoritesItems.insert(moveItunes, at: to.row)
            }
            
            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 120
            }
            
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "editFavoritesCell" {
                    let indexPath = tableView.indexPathForSelectedRow!
                    let storeItem = favoritesItems[indexPath.row]
                    let navVC = segue.destination as! UINavigationController
                    let addEditiTunesTableViewController = navVC.viewControllers.first as! AddEditTableViewController
                    addEditiTunesTableViewController.iTunes = storeItem
                    let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
                    addEditiTunesTableViewController.myImage = cell.imageViewImage.image
                }
            }
            
            @IBAction func saveButton(_ sender: UIBarButtonItem) {
                save()
                saveButton.title = "Saved"
                saveButton.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            }
        }
