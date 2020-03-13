//
//  SKToolbar.swift
//  SKPhotoBrowser
//
//  Created by keishi_suzuki on 2017/12/20.
//  Copyright © 2017年 suzuki_keishi. All rights reserved.
//

import Foundation

// helpers which often used
private let bundle = Bundle(for: SKPhotoBrowser.self)

class SKToolbar: UIToolbar {
    var toolActionButton: UIBarButtonItem!
//    var toolActionButtonReport: UIBarButtonItem!
//    var toolActionButtonSelect: UIBarButtonItem!
    fileprivate weak var browser: SKPhotoBrowser?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, browser: SKPhotoBrowser) {
        self.init(frame: frame)
        self.browser = browser
        
        setupApperance()
        setupToolbar()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            if SKMesurement.screenWidth - point.x < 50 { // FIXME: not good idea
                return view
            }
        }
        return nil
    }
}

private extension SKToolbar {
    func setupApperance() {
        backgroundColor = .clear
        clipsToBounds = true
        isTranslucent = true
        setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
    }
    
    func setupToolbar() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SKMesurement.screenWidth, height: 50))
        view.backgroundColor = .clear
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        btn.setTitle("Report", for: .normal)
        btn.addTarget(browser, action: #selector(SKPhotoBrowser.actionButtonPressed), for: .touchUpInside)
        view.addSubview(btn)
        
//        toolActionButton = UIBarButtonItem(barButtonSystemItem: .action, target: browser, action: #selector(SKPhotoBrowser.actionButtonPressed))
//        toolActionButton.tintColor = UIColor.white
//
//        toolActionButtonSelect = UIBarButtonItem(customView: view)
//        toolActionButtonSelect.setBackgroundImage(UIImage(named: "check"), for: .selected, barMetrics: .default)
//        toolActionButtonSelect.setBackgroundImage(UIImage(named: "unCheck"), for: .normal, barMetrics: .default)
//        toolActionButtonSelect.tintColor = UIColor.white
        
//        var items = [UIBarButtonItem]()
        
//        if SKPhotoBrowserOptions.displayAction {
//            items.append(toolActionButtonSelect)
//        }
//        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
//        items.append(toolActionButton)
//        items.append(toolActionButtonSelect)
        
       // setItems(items, animated: false)
        
    }
    
    func setupActionButton() {
    }
}
