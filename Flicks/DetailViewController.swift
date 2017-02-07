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
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: viewInfo.frame.origin.y + viewInfo.frame.size.height)
        
        // Title
        let title = movie["title"] as? String
        titleLabel.text = title
        
        // Overview
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        
        overviewLabel.sizeToFit() // grow label with text size
        
        
        // Poster Image
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        let imageURL = NSURL(string: baseURL + posterPath)
        let imageRequest = NSURLRequest(url: imageURL as! URL)
        
        
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
        cosmosView.didFinishTouchingCosmos = { rating in }
        
        // A closure that is called when user changes the rating by touching the view.
        // This can be used to update UI as the rating is being changed by moving a finger.
        cosmosView.didTouchCosmos = { rating in }
        
        
        
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
        
        
        print (movie)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
