//
//  DHFPSLabel.swift
//  FPS指示器
//  Powered by YYKit
//
//  Created by qhhuang on 2017/10/25.
//  Copyright © 2017年 qhhuang. All rights reserved.
//

import UIKit

class DHFPSLabel: UILabel {
    
    lazy var link: CADisplayLink = {
        let link = CADisplayLink(target: self, selector: #selector(DHFPSLabel.tick))
        return link
    }()
    
    var count: Int = 0
    lazy var lastTime: TimeInterval = TimeInterval()
    lazy var mainfont: UIFont = UIFont(name: "Menlo", size: 14)!
    lazy var subFont: UIFont = UIFont(name: "Menlo", size: 5)!
    lazy var llll: TimeInterval = TimeInterval()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if frame.size.width == 0 && frame.size.height == 0 {
            self.frame = CGRect(origin: CGPoint.init(x: 10, y: 20), size: CGSize.init(width: 55, height: 20)) 
        }
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textAlignment = NSTextAlignment.center
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.7)
        
        link.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    @objc func tick(link: CADisplayLink) {
        
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        
        print("timeStamp\(link.timestamp)")
        
        count = count + 1
        let delta = link.timestamp - lastTime
        if delta < 1 {
            return
        }
        lastTime = link.timestamp
        let fps:CGFloat = CGFloat(count) / CGFloat(delta)
        count = 0
        
        let progress = fps / 60.0
        let color = UIColor.init(hue: 0.27 * (progress - 0.2), saturation: 1, brightness: 0.9, alpha: 1)
        
        let attrString = NSMutableAttributedString(string: "\(Int(fps)) FPS")
        attrString.addAttributes([NSAttributedStringKey.foregroundColor: color], range: NSRange(location: 0, length: attrString.length - 3))
        attrString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], range: NSRange(location: attrString.length - 3, length: 3))
        
        attrString.addAttributes([NSAttributedStringKey.font: mainfont], range: NSRange.init(location: 0, length: attrString.length))
        attrString.addAttributes([NSAttributedStringKey.font: subFont], range: NSRange.init(location: attrString.length - 4, length: 1))
        
        self.attributedText = attrString;
        
    }
    
    deinit {
        link.invalidate()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: 50, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
