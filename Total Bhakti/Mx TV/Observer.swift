//
//  Observer.swift
//  Sanskar
//
//  Created by Warln on 07/02/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import Foundation

class Observable<T> {
    
    var value: T? {
        didSet {
            listner?(value)
        }
    }
    
    init(_ value: T? ) {
        self.value = value
    }
    
    
    private var listner: ((T?) -> Void)?
    
    func bind (_ closure: @escaping (T?) -> Void) {
        closure(value)
        listner = closure
    }
    
}
