//
//  YouTubeVideoPlayerViewController.swift
//  Flicks
//
//  Created by Rajjwal Rawal on 2/12/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YouTubeVideoPlayerViewController: UIViewController, YTPlayerViewDelegate {

    
    @IBOutlet weak var youTubeVideoPlayer: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        youTubeVideoPlayer.delegate = self
        youTubeVideoPlayer.load(withVideoId: "iywaBOMvYLI")
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
