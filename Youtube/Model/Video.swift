//
//  Video.swift
//  Youtube
//
//  Created by Dake Aga on 11/29/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit

// Do not forget that names of instance of the struct model should MATCH the naming in the JSON

struct Video: Decodable {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: Int?
    var uploadDate: Date?
    
    var channel: Channel?
    
}

struct Channel: Decodable {
    var name: String?
    var profileImageName: String?
}

