//
//  YouTubePlayerViewController.swift
//  Flicks
//
//  Created by Rajjwal Rawal on 2/12/17.
//  Copyright © 2017 Rajjwal Rawal. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YouTubePlayerViewController: UIViewController, YTPlayerViewDelegate {
    

    var videoID: String!
    @IBOutlet var videoPlayer: YTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print (videoID)
        videoPlayer.delegate = self
        videoPlayer.load(withVideoId: videoID)
        
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
