//
//  DebugFile.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 25/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation

func debug_print<T>(object: T) {
    #if DEBUG
        print(object)
    #endif
}
