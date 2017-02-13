//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Rajjwal Rawal on 1/31/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
  
    
    var movies: [NSDictionary]?
    var allmovies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    var endpoint: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorView.isHidden = true
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        MBProgressHUD.showAdded(to: self.view, animated: true) // show loading state
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    // print(dataDictionary)
                    self.movies = (dataDictionary["results"] as! [NSDictionary]?)
                    
                    self.filteredData = self.movies
                    
                    self.tableView.reloadData()
                    
                    MBProgressHUD.hide(for: self.view, animated: true) // hide loading state
                    refreshControl.endRefreshing()
                }
            } else {
                self.errorView.isHidden = false
            }
        }
        task.resume()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // When there is no data, refresh tableView
        self.tableView.reloadData()
        
        // Tell the refreshControl to stop spinning
        refreshControl.endRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredData = filteredData {
            return filteredData.count
        } else {
            return 0
        }
    }
    



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseURL = "https://image.tmdb.org/t/p/original"
        let posterPath = movie["poster_path"] as? String
        let imageURL = NSURL(string: baseURL + posterPath!)
        
        

        
        
        
        
        
        let imageRequest = NSURLRequest(url: imageURL as! URL)
        
        cell.posterView.setImageWith(
            imageRequest as URLRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.posterView.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        
        
        cell.titleLabel.text = title
        cell.overViewLabel.text = overview
        cell.posterView.setImageWith(imageURL! as URL)
        
        
        
        
        let star = (movie["vote_average"] as! Float) / 2
        
        // show stars precisely, not only full stars
        cell.cosmosView.settings.fillMode = .precise
        
        // Change the cosmos view rating
        cell.cosmosView.rating = Double(star)
        
        
        // Change the text
        cell.cosmosView.text = " " + String(star)
        

        // Called when user finishes changing the rating by lifting the finger from the view.
        // This may be a good place to save the rating in the database or send to the server.
        // cell.cosmosView.didFinishTouchingCosmos = { rating in }
        
        // A closure that is called when user changes the rating by touching the view.
        // This can be used to update UI as the rating is being changed by moving a finger.
        // cell.cosmosView.didTouchCosmos = { rating in }
        
        
//        print ("row \(indexPath.row)")
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let searchurl = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchText)")!
        let request = URLRequest(url: searchurl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let dataDictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                
                //                    print(dataDictionary)
                
                self.allmovies = (dataDictionary["results"] as! [NSDictionary]?)
                
                //                    print(self.allmovies)
                self.filteredData = self.allmovies
                //
                self.tableView.reloadData()
                //            }
            }
        }
        task.resume()
        
        
        
        filteredData = searchText.isEmpty ? movies : allmovies?.filter({(movies: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            
            
            
            
            return (movies["title"] as? String)?.range(of: searchText, options: .caseInsensitive) != nil
            
        })
        
        tableView.reloadData()
        
        
        
        
        
    }
    
    func searchBarTextDidBeginEditing(_ search: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ search: UISearchBar) {
        search.showsCancelButton = false
        search.text = ""
        search.resignFirstResponder()
        
        // Reload data after user presses cancel in the search bar
        self.filteredData = self.movies
        tableView.reloadData()
    }
    
    
     // MARK: - Navigation		          
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = filteredData![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
         
        
        
        print ("Prepare for segue called")

    }
   
    
    
}

