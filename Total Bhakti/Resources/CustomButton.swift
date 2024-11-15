//
////  iContractor
////
////  Created by Shouaib Ahmed on 24/06/20.
////  Copyright © 2020 Shouaib Ahmed. All rights reserved.
////
//
import UIKit

 @IBDesignable open class CustomButton: UIButton {

        func setup() {
            layer.cornerRadius = 10
            clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
