//
//  ExploreTableViewController.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 6.10.2024.
//

import UIKit

class ExploreTableVC: UITableViewController, UISearchResultsUpdating{
    
    //MARK: Properties
    var searchResults : [User] = []
    var users : [User] = []
    var searchController : UISearchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        
        fetchUser()
        setupSearch()
        
        navigationController?.navigationBar.tintColor = .black
        
        
    }
    
    //MARK: Setup Methods
    func setupSearch(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    
    func tableViewSetup(){
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        
        let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text = "Search for users"
        noDataLabel.textColor = .gray
        noDataLabel.textAlignment = .center
        tableView.backgroundView = noDataLabel
        tableView.separatorStyle = .none
        
    }
    
    //MARK: DATA Fetching
    
    func fetchUser(){
        Api.User.observeUsers { user in
            
            self.users.append(user)
            self.tableView.reloadData()
            
        }
    }
    
    //MARK: UI Searc Result Process
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text == nil || searchController.searchBar.text!.isEmpty {
            view.endEditing(true)
        } else {
            print(searchController.searchBar.text)
            let textLowercased = searchController.searchBar.text!.lowercased()
            filterContent(for: textLowercased)
            
        }
        tableView.reloadData()
    }
    
    func filterContent(for searchText: String){
        searchResults = self.users.filter {
            return $0.username!.lowercased().contains(searchText)
        }
        
        
    }
    
    
    // MARK: - Table View Data Source/Delegate
    
    //Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            tableView.backgroundView = nil
            return searchResults.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreCell", for: indexPath) as! ExploreTableViewCell
        
        let user = searchController.isActive ? searchResults[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
    //Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ExploreTableViewCell {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let userVC = storyboard.instantiateViewController(withIdentifier: "UserVC") as! UserVC
            userVC.userId = cell.user!.uid!
            self.navigationController?.pushViewController(userVC, animated: true)
        }
    }
    
    
    
    
    
}
