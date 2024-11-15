//
////  iContractor
////
////  Created by Shouaib Ahmed on 24/06/20.
////  Copyright © 2020 Shouaib Ahmed. All rights reserved.
////
//
import UIKit

 @IBDesignable open class customView: UIView {

        func setup() {
            layer.cornerRadius = 10
            layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            layer.borderWidth = 2
            clipsToBounds = true
            backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
