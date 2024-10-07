//
//  ExploreTableViewController.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 6.10.2024.
//

import UIKit

class ExploreTableViewController: UITableViewController, UISearchResultsUpdating{
   
    
    var searchResults : [User] = []
    var users : [User] = []
    var searchController : UISearchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
      
        fetchUser()
        setupSearch()

 
    }
    func setupSearch(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }

    func fetchUser(){
        Api.User.observeUsers { user in
        
            self.users.append(user)
            self.tableView.reloadData()
            
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text == nil || searchController.searchBar.text?.isEmpty == true{
            view.endEditing(true)
        } else {
            let textLowercased = searchController.searchBar.text!.lowercased()
            filterContent(for: textLowercased)
            
        }
        tableView.reloadData()
    }
    
    func filterContent(for searchText: String){
        searchResults = self.users.filter{
            return $0.username?.lowercased().ranges(of: searchText) != nil
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return searchController.isActive ? searchResults.count : self.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreTableViewCell
     
        let user = searchController.isActive ? searchResults[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableViewSetup(){

        view.backgroundColor = .white
        
        tableView.backgroundColor = .white

    }

}
