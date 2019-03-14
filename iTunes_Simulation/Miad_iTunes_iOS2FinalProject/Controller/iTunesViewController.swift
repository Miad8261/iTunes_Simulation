
import UIKit
class iTunesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControlMedia: UISegmentedControl!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var searchBarSearch: UISearchBar! {
        didSet{
            searchBarSearch.delegate = self
        }
    }
    
    var iTunesItems = [StoreItem]()
    var segmentItems = "movie"
    var searchedText = "simpson"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBarSearch.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        updateUIOnce()
        loadFromFile()
    }
    
    func updateUIOnce() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        fetchItems{ (query) in
            if let items = query {
                self.iTunesItems = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func SegmentSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentItems = "movie"
            updateUIOnce()
            
        } else if sender.selectedSegmentIndex == 1 {
            segmentItems = "music"
            updateUIOnce()
            
        } else if sender.selectedSegmentIndex == 2 {
            segmentItems = "software"
            updateUIOnce()
            
        } else if sender.selectedSegmentIndex == 3 {
            segmentItems = "ebook"
            updateUIOnce()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchedText = searchBar.text ?? ""
        fetchDataFromiTunes(searchedText)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iTunesItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iTunes = iTunesItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! TableViewCell
        cell.update(with: iTunes)
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
            // Delete the row from the data source
            iTunesItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .delete {
        }
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt fromIndexPath: IndexPath,
                   to: IndexPath) {
        let moveItunes = iTunesItems.remove(at: fromIndexPath.row)
        iTunesItems.insert(moveItunes, at: to.row)
    }
    
    @IBAction func unwindToMaonVC(_ segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editiTunesCell" {
            let indexPath = tableView.indexPathForSelectedRow!
            let storeItem = iTunesItems[indexPath.row]
            let navVC = segue.destination as! UINavigationController
            let addEditiTunesTableViewController = navVC.viewControllers.first as! AddEditTableViewController
            addEditiTunesTableViewController.iTunes = storeItem
            let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
            addEditiTunesTableViewController.myImage = cell.imageViewImage.image
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func fetchDataFromiTunes(_ searchedText: String) {
        fetchItems { (item) in
            if let items = item {
                self.iTunesItems = items
                //print(self.iTunesItems)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchItems(completion: @escaping ([StoreItem]?) -> Void) {
        let query: [String: String] = [
            "term": searchedText,
            "media": segmentItems,
            "lang": "en_us",
            "limit": "103"]
        
        let baseURL = URL(string: "https://itunes.apple.com/search?")!
        guard let url = baseURL.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        print(url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data,
                let storeItems = try? decoder.decode(StoreItems.self, from: data) {
                completion(storeItems.results)
            } else {
                print("Either no data was returned, or data was not serialized.")
                completion(nil)
                return
            }
        }
        task.resume()
    }
}

extension iTunesViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ searchBarSearch: UITextField) -> Bool {
        // Dissmiss the keyboard by pressing enter
        // 1- Conform to UITextFieldDelegate
        // 2- In target text field didSet set the myTextField.delegate = self
        searchBarSearch.resignFirstResponder()
        return true
    }
}



