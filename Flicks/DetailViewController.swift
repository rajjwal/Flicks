//
//  DetailViewController.swift
//  Flicks
//
//  Created by Rajjwal Rawal on 2/7/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit
import Cosmos

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var ratedImage: UIImageView!

    var movie: NSDictionary!
    var videoID: String!

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // trailer button
        trailerButton.layer.cornerRadius = 10;
        trailerButton.layer.borderWidth = 2;
        trailerButton.layer.borderColor = UIColor.orange.cgColor
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: viewInfo.frame.origin.y + viewInfo.frame.size.height)
        
        
        
        // Title
        let title = movie["title"] as? String
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        
        
        //Release Date
        let releaseDate = movie["release_date"] as? String
        releaseDateLabel.text = releaseDate
        
        // Overview
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        
        overviewLabel.sizeToFit() // grow label with text size
        
        
        // Poster Image
        let baseURL = "https://image.tmdb.org/t/p/original"
        let posterPath = movie["poster_path"] as! String
        let imageURL = NSURL(string: baseURL + posterPath)
        let imageRequest = NSURLRequest(url: imageURL as! URL)
        
        
        // R-rated
        ratedImage.isHidden = true
        if movie["adult"] as! Bool == true {
            ratedImage.isHidden = false
        }
        
        print (movie["adult"] as! Bool)
        
        
        // Star Rating
        
        let star = (movie["vote_average"] as! Float) / 2
        
        // show stars precisely, not only full stars
        cosmosView.settings.fillMode = .precise
        
        // Change the cosmos view rating
        cosmosView.rating = Double(star)
        
        
        // Change the text
        cosmosView.text = " " + String(star)
        
        
        
        // Called when user finishes changing the rating by lifting the finger from the view.
        // This may be a good place to save the rating in the database or send to the server.
        //cosmosView.didFinishTouchingCosmos = { rating in }
        
        // A closure that is called when user changes the rating by touching the view.
        // This can be used to update UI as the rating is being changed by moving a finger.
        // cosmosView.didTouchCosmos = { rating in }
        
        
        
        posterImageView.setImageWith(
            imageRequest as URLRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in self.posterImageView.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    self.posterImageView.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        
        getTrailers()
        
    

    }
    

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        

        let youtubePlayer = segue.destination as! YouTubePlayerViewController
        youtubePlayer.videoID = videoID
        
        
        
    }
    
    
    func getTrailers()
    {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let movieID = movie["id"] as! Int
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)")
        let request = URLRequest(url: url as! URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try? JSONSerialization.jsonObject(
                    with: data, options:[]) as! NSDictionary {
                    if let results = responseDictionary["results"] as? [NSDictionary] {
                        self.videoID = results[0]["key"] as? String
                    }
                }
            }
            
        });
        task.resume()
    }
}
