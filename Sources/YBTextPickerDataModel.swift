//
//  YBTextPickerDataModel.swift
//  YBTextPicker
//
//  Created by Yahya Bagia on 14/03/19.
//  Copyright © 2019 Yahya. All rights reserved.
//

import Foundation

public class YBTextPickerDataModel : NSObject{
    
    public var title : String!
    public var identity : Int!
    
    public init(_ title:String, _ identity:Int) {
        super.init()
        self.title = title
        self.identity = identity
    }
    
}
