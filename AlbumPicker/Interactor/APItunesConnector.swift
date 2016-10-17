//
//  APItunesConnector.swift
//  AlbumPicker
//
//  Created by Yulian Simeonov on 4/1/15.
//  Copyright (c) 2015 YulianMobile. All rights reserved.
//

import Foundation

protocol APItunesConnectorDelegate {
    func didReceiveAPIResults(results: NSDictionary)
}

class APItunesConnector {
    
    var delegate: APItunesConnectorDelegate
    
    init(delegate: APItunesConnectorDelegate) {
        self.delegate = delegate
    }
    
    func get(path: String) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSArray = jsonResult["results"] as NSArray
            self.delegate.didReceiveAPIResults(jsonResult) // THIS IS THE NEW LINE!!
        })
        task.resume()
    }
    
    func feedRecentAlbums(limit: Int) {
        let urlPath = "https://itunes.apple.com/search?term=jack+johnson&USA&media=music&entity=album&limit=10&sort=recent"
        get(urlPath)
    }
    
    func searchItunesFor(searchTerm: String) {
        
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            get(urlPath)
        }
    }
    
    func lookupAlbum(collectionId: Int) {
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }
    
}