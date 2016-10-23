//
//  APAlbumInteractor.swift
//  AlbumPicker
//
//  Created by Yulian on 4/1/15.
//  Copyright (c) 2015 YulianMobile. All rights reserved.
//

import Foundation

class APAlbumInteractor: NSObject {
    class var sharedInstance: APAlbumInteractor {
        struct Static {
            static let instance: APAlbumInteractor = APAlbumInteractor()
        }
        return Static.instance
    }
    
    // Function: Make Album array with Album Entity
    func makeAlbums(dataArray: NSArray) -> [APAlbumEntity] {
        var albumArray = [APAlbumEntity]() // Create empty array
        
        if dataArray.count>0 {
            for dict in dataArray {
                var newAlbum = APAlbumEntity(data: dict as NSDictionary) // Make album entity
                albumArray.append(newAlbum) // Add to array
            }
        }
        return albumArray
    }
}
