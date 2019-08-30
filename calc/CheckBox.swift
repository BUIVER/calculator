//
//  CheckBox.swift
//  calc
//
//  Created by Ivan Ermak on 8/29/19.
//  Copyright © 2019 Ivan Ermak. All rights reserved.
//

import Foundation
import UIKit


class CheckBox: UIButton {
    // Images
//    let checkedImage = UIImage(named: "SelectedCheckBox")! as UIImage
//    let uncheckedImage = UIImage(named: "Non-selectedCheckBox")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.backgroundColor = .lightGray
                //self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.backgroundColor = .white
                //self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.layer.borderWidth = 1
        self.isChecked = true
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
