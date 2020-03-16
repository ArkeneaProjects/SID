//
//  SKPaginationView.swift
//  SKPhotoBrowser
//
//  Created by keishi_suzuki on 2017/12/20.
//  Copyright © 2017年 suzuki_keishi. All rights reserved.
//

import UIKit

private let bundle = Bundle(for: SKPhotoBrowser.self)

class SKPaginationView: UIView {
    var counterLabel: UILabel?
    var prevButton: UIButton?
    var nextButton: UIButton?
    var selectButton: UIButton?
    var reportButton: UIButton?
    
    var currentPage = 0
    private var margin: CGFloat = 100
    private var extraMargin: CGFloat = SKMesurement.isPhoneX ? 40 : 0
    
    fileprivate weak var browser: SKPhotoBrowser?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, browser: SKPhotoBrowser?) {
        self.init(frame: frame)
        self.frame = CGRect(x: 0, y: frame.height - margin - extraMargin, width: frame.width, height: 100)
        self.browser = browser
        
        setupApperance()
        setupCounterLabel()
        setupPrevButton()
        setupNextButton()
        
        if browser?.showReportButtons == true {
            setupSelectButton()
            setupReportButton()
        }
        
        update(browser?.currentPageIndex ?? 0)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            if let counterLabel = counterLabel, counterLabel.frame.contains(point) {
                return view
            } else if let prevButton = prevButton, prevButton.frame.contains(point) {
                return view
            } else if let nextButton = nextButton, nextButton.frame.contains(point) {
                return view
            } else if let selectButton = selectButton, selectButton.frame.contains(point) {
                return view
            } else if let reportButton = reportButton, reportButton.frame.contains(point) {
                return view
            }
            return nil
        }
        return nil
    }
    
    func updateFrame(frame: CGRect) {
        self.frame = CGRect(x: 0, y: frame.height - margin, width: frame.width, height: 100)
    }
    
    func updatedReportButton() {
        guard let browser = browser else { return }
        reportButton?.isHidden = browser.selectedImageArray.count < 1
    }
    
    func update(_ currentPageIndex: Int) {
        guard let browser = browser else { return }
        self.currentPage = currentPageIndex
        if browser.photos.count > 1 {
            counterLabel?.text = "\(currentPageIndex + 1) / \(browser.photos.count)"
        } else {
            counterLabel?.text = nil
        }
        
        guard let prevButton = prevButton, let nextButton = nextButton else { return }
        prevButton.isEnabled = (currentPageIndex > 0)
        nextButton.isEnabled = (currentPageIndex < browser.photos.count - 1)
        var contains: Bool = false
        for i in 0..<browser.selectedImageArray.count {
            if (browser.selectedImageArray[i] as! NSDictionary).value(forKey: "id") as! String == (browser.itemsImageData[currentPageIndex] as! ImageData).id {
                contains = true
            }
        }
        selectButton?.isSelected = contains
        reportButton?.isHidden = browser.selectedImageArray.count < 1
    }
    
    func setControlsHidden(hidden: Bool) {
        let alpha: CGFloat = hidden ? 0.0 : 1.0
        
        UIView.animate(withDuration: 0.35,
                       animations: { () -> Void in self.alpha = alpha },
                       completion: nil)
    }
}

private extension SKPaginationView {
    func setupApperance() {
        backgroundColor = .clear
        clipsToBounds = true
    }
    
    func setupCounterLabel() {
        guard SKPhotoBrowserOptions.displayCounterLabel else { return }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 50))
        label.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.shadowColor = SKToolbarOptions.textShadowColor
        label.shadowOffset = CGSize(width: 0.0, height: 1.0)
        label.font = SKToolbarOptions.font
        label.textColor = SKToolbarOptions.textColor
        label.translatesAutoresizingMaskIntoConstraints = true
        label.autoresizingMask = [.flexibleBottomMargin,
                                  .flexibleLeftMargin,
                                  .flexibleRightMargin,
                                  .flexibleTopMargin]
        addSubview(label)
        counterLabel = label
    }
    
    func setupPrevButton() {
        guard SKPhotoBrowserOptions.displayBackAndForwardButton else { return }
        guard browser?.photos.count ?? 0 > 1 else { return }
        
        let button = SKPrevButton(frame: frame)
        button.center = CGPoint(x: frame.width / 2 - 70, y: frame.height / 2)
        button.backgroundColor = .clear
        button.addTarget(browser, action: #selector(SKPhotoBrowser.gotoPreviousPage), for: .touchUpInside)
        addSubview(button)
        prevButton = button
    }
    
    func setupNextButton() {
        guard SKPhotoBrowserOptions.displayBackAndForwardButton else { return }
        guard browser?.photos.count ?? 0 > 1 else { return }
        
        let button = SKNextButton(frame: frame)
        button.center = CGPoint(x: frame.width / 2 + 70, y: frame.height / 2)
        button.backgroundColor = .clear
        button.addTarget(browser, action: #selector(SKPhotoBrowser.gotoNextPage), for: .touchUpInside)
        addSubview(button)
        nextButton = button
    }
    
    func setupReportButton() {
        guard SKPhotoBrowserOptions.displayBackAndForwardButton else { return }
        guard browser?.photos.count ?? 0 > 1 else { return }
        
        let button = SKReportButton(frame: frame)
        button.center = CGPoint(x: frame.width / 2 - 125, y: frame.height / 2)
        button.setTitle("Report", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(browser, action: #selector(SKPhotoBrowser.reportButtonPressed), for: .touchUpInside)
        addSubview(button)
        reportButton = button
    }
    
    func setupSelectButton() {
        guard SKPhotoBrowserOptions.displayBackAndForwardButton else { return }
        guard browser?.photos.count ?? 0 > 1 else { return }
        
        let button = SKSelectButton(frame: frame)
        button.center = CGPoint(x: frame.width / 2 + 125, y: frame.height / 2)
        button.backgroundColor = .clear
        button.addTarget(browser, action: #selector(SKPhotoBrowser.selectButtonPressed(_:)), for: .touchUpInside)
        addSubview(button)
        selectButton = button
    }
}

class SKPaginationButton: UIButton {
    let insets: UIEdgeInsets = UIEdgeInsets(top: 13.25, left: 17.25, bottom: 13.25, right: 17.25)
    
    func setup(_ imageName: String) {
        backgroundColor = .clear
        imageEdgeInsets = insets
        translatesAutoresizingMaskIntoConstraints = true
        autoresizingMask = [.flexibleBottomMargin,
                            .flexibleLeftMargin,
                            .flexibleRightMargin,
                            .flexibleTopMargin]
        contentMode = .center
        
        let image = UIImage(named: "SKPhotoBrowser.bundle/images/\(imageName)",
            in: bundle, compatibleWith: nil) ?? UIImage()
        setImage(image, for: .normal)
    }
    
    func setupcustom(_ imageName: String, _ selectedImageName: String) {
        backgroundColor = .clear
        //          imageEdgeInsets = insets
//        translatesAutoresizingMaskIntoConstraints = true
//        autoresizingMask = [.flexibleBottomMargin,
//                            .flexibleLeftMargin,
//                            .flexibleRightMargin,
//                            .flexibleTopMargin]
        contentMode = .center
        
        let image = UIImage(named: imageName,
                            in: bundle, compatibleWith: nil) ?? UIImage()
        setImage(image, for: .normal)
        
        let imageSelected = UIImage(named: selectedImageName,
                                    in: bundle, compatibleWith: nil) ?? UIImage()
        setImage(imageSelected, for: .selected)
    }
}

class SKPrevButton: SKPaginationButton {
    let imageName = "btn_common_back_wh"
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        setup(imageName)
    }
}

class SKNextButton: SKPaginationButton {
    let imageName = "btn_common_forward_wh"
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        setup(imageName)
    }
}

class SKReportButton: SKPaginationButton {
    let imageName = "report"
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 64, height: 44))
       // setupcustom(imageName, imageName)
    }
}

class SKSelectButton: SKPaginationButton {
    let imageName = "unchecked"
    let imageNameSelected = "checked"
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        setupcustom(imageName, imageNameSelected)
    }
}
