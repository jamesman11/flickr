//
//  DetailViewController.swift
//  Flicks
//
//  Created by James Man on 3/31/17.
//  Copyright © 2017 James Man. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var infoView: UIView!
    let baseUrl = "https://image.tmdb.org/t/p/w500"
    
    @IBOutlet var scrollView: UIScrollView!
    var movie: NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: infoView.frame.origin.y + infoView.frame.size.height + 60)
        let title = movie?["title"] as! String
        let overview = movie?["overview"] as! String
        titleLabel.text = title
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        if let posterPath = movie?["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)
            posterImageView.setImageWith(imageUrl!)
        }
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
