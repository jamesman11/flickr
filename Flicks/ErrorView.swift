//
//  ErrorView.swift
//  Flicks
//
//  Created by James Man on 3/31/17.
//  Copyright © 2017 James Man. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    override init(frame: CGRect){
        super.init(frame: frame)
        let cgrect = CGRect(x: 0, y: 0, width: frame.width, height: 20)
        let label = UILabel(frame: cgrect)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "Network Error"
        self.addSubview(label)
        self.backgroundColor = UIColor.blue
        self.alpha = 0.8
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
