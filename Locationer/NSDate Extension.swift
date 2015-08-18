//
//  NSDate Extension.swift
//  Locationer
//
//  Created by CSSE Department on 8/18/15.
//  Copyright (c) 2015 Rose-Hulman. All rights reserved.
//

import Foundation
public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }