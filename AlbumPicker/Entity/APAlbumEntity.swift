//
//  APAlbumEntity.swift
//  AlbumPicker
//
//  Created by Yulian on 4/1/15.
//  Copyright (c) 2015 YulianMobile. All rights reserved.
//

import Foundation

class APAlbumEntity {
    var title: NSString!
    var price: NSString!
    var albumImageURL: NSString!
    var albumLargeImageURL: NSString!
    var artistURL: NSString!
    
    init(data:NSDictionary)  {
        var albumTitle = data["trackName"] as? NSString // Get album name
        if albumTitle == nil {
            albumTitle = data["collectionName"] as? NSString
        }
        self.title = albumTitle
        
        self.albumImageURL = data["artworkUrl60"] as? NSString ?? "" // Album image url
        self.albumLargeImageURL = data["artworkUrl100"] as? NSString ?? ""
        
        self.artistURL = data["artistViewUrl"] as? NSString ?? "" // Artist image url
        
        var priceVal = data["formattedPrice"] as? String // Get album price
        if priceVal == nil {
            price = data["collectionPrice"] as? String
            if price == nil {
                var priceFloat: Float? = data["collectionPrice"] as? Float
                if priceFloat != nil {
                    priceVal = NSString(format: "$%.02f", priceFloat!)
                }
                
            }
        }
        self.price = priceVal
    }
}