//
//  MoviesViewController.swift
//  Flicks
//
//  Created by James Man on 3/30/17.
//  Copyright © 2017 James Man. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource {
    let API_KEY: String = "459931b79365755fe3728f7808a2d2b7"
    var movies: [NSDictionary] = []
    var endpoint: String = "now_playing"
    var title_end_point_map = [
        "now_playing" : "Now Playing",
        "top_rated": "Top Rated"
    ]
    var errorView: UIView!
    @IBOutlet var tableView: UITableView!
//    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let api = "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(self.API_KEY)&language=en-US&page=1"
        
        let url = URL(string:api)
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as! [NSDictionary]
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                        refreshControl.endRefreshing()
                        self.showOrHideErrorMessage(isHidden: true)
                    }
                } else {
                    refreshControl.endRefreshing()
                    self.showOrHideErrorMessage(isHidden: false)
                }
        });
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        collectionView.insertSubview(refreshControl, at: 0)
        refreshControlAction(refreshControl)
        
        // Add the warning message view
        let screenSize: CGRect = UIScreen.main.bounds
        errorView = ErrorView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 20))
        tableView.addSubview(errorView)
        
        toggleList(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func toggleList(_ isShowList:Bool){
        if(isShowList){
            tableView.isHidden = false
            collectionView.isHidden = true
        }else{
            tableView.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    func showOrHideErrorMessage(isHidden: Bool) {
        errorView.isHidden = isHidden
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionMovieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = self.movies[indexPath.row]
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)
            cell.gridImageView.setImageWith(imageUrl!)
        }
        // Configure the cell
        return cell
    }
    
    @IBAction func selectSegmentHandler(_ sender: UISegmentedControl) {
        let value = sender.titleForSegment(at: sender.selectedSegmentIndex)
        toggleList(value == "List")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = self.movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
       
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)
            cell.posterView.setImageWith(imageUrl!)
        }

        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPath(for: cell)
            let movie = self.movies[(indexPath?.row)!]
            let destination = segue.destination as! DetailViewController
            destination.movie = movie
        }
        if let cell = sender as? UICollectionViewCell {
            let indexPath = collectionView.indexPath(for: cell)
            let movie = self.movies[(indexPath?.row)!]
            let destination = segue.destination as! DetailViewController
            destination.movie = movie
        }
    }
}
