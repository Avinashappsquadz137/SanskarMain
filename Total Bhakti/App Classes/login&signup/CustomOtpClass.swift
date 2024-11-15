//
//  CustomOtpClass.swift
//  Sanskar
//
//  Created by Warln on 05/03/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

protocol MyTextFieldDelegate: class {
    func textFieldDidDelete()
}

import UIKit
// 1. subclass UITextField and create protocol for it to know when the backButton is pressed
class MyTextField: UITextField {

    weak var myDelegate: MyTextFieldDelegate? // make sure to declare this as weak to prevent a memory leak/retain cycle

    override func deleteBackward() {
        super.deleteBackward()
        myDelegate?.textFieldDidDelete()
    }

    // when a char is inside the textField this keeps the cursor to the right of it. If the user can get on the left side of the char and press the backspace the current char won't get deleted
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
}
