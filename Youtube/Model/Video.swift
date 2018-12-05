//
//  Video.swift
//  Youtube
//
//  Created by Dake Aga on 11/29/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var thumbnalImage: String?
    var title: String?
    var numberOfViews: NSNumber?
    var dateOfUpload: NSDate?
    
    var channel: Channel?
    
}


class Channel: NSObject {
    
    var name: String?
    var profileIamge: String?
    
}
