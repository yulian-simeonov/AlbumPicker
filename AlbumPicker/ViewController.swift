//
//  ViewController.swift
//  AlbumPicker
//
//  Created by Yulian on 4/1/15.
//  Copyright (c) 2015 YulianMobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController, APItunesConnectorDelegate, iCarouselDataSource, iCarouselDelegate {

    var kCardWid: CGFloat = 250
    var kCardHei: CGFloat = 400
    
    var albums: [APAlbumEntity] = []
    
    var itunesConnector : APItunesConnector?

    @IBOutlet var carousel : iCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.carousel.pagingEnabled = true
        self.carousel.type = .CoverFlow2
        // Connect itunes and get album data
        itunesConnector = APItunesConnector(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        itunesConnector!.feedRecentAlbums(10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Carousel DataSource, Delegate
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int) {
        self.performSegueWithIdentifier("ShowSummary", sender: nil)
    }
    
    func carouselDidEndScrollingAnimation(carousel: iCarousel!) {
        self.pageControl.currentPage = carousel.currentItemIndex
        // Set Album Title and Price
        if albums.count > 0 {
            let album = albums[carousel.currentItemIndex] as APAlbumEntity

            self.titleLabel.text = NSString(format: "Title: %@", album.title)
            self.priceLabel.text = NSString(format: "Price: %@", album.price)
        }
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
    {
        return albums.count
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView!
    {
        var label: UILabel! = nil
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            view = NSBundle.mainBundle().loadNibNamed("APAlbumCell", owner: nil, options: nil)[0] as UIView
            (view ).frame = (frame:CGRectMake(0, 0, 2 * self.carousel.bounds.size.width / 3, 300))
            view.layer.borderColor = UIColor .lightGrayColor().CGColor
            view.layer.borderWidth = 5.0
        }
        
        let album = albums[index] as APAlbumEntity
        
        // Set Album Image
        var image: UIImageView! = (view as APAlbumCell).image as UIImageView!
        image.sd_setImageWithURL(NSURL(string: album.albumLargeImageURL))
        image.contentMode = .ScaleAspectFill
        
        // Set Album Title
        (view as APAlbumCell).titleLabel.text = album.title
        
        
                
        return view
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 1.8
        }
        return value
    }
    
    // MARK: APIItunesConnectorDelegate
    func didReceiveAPIResults(response: NSDictionary) {
        println(response)
        var jsonArray: NSArray = response["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            for dict in jsonArray {
                self.albums.append(APAlbumEntity(data: dict as NSDictionary))
            }
            self.carousel .reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowSummary" {
            var destVC = segue.destinationViewController as SummaryViewController
            destVC.albumData = self.albums[self.carousel.currentItemIndex] // Send selected album data
        }
    }
}

