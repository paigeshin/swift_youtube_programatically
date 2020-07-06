//
//  Video.swift
//  Swift Youtube App Programmatically
//
//  Created by shin seunghyun on 2020/07/06.
//

import UIKit

class Video: NSObject {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    
    var channel: Channel?
    
}

class Channel: NSObject {
    
    var name: String?
    var profileImagename: String?
    
}
