//
//  JXTopBarView.swift
//  FBSnapshotTestCase
//
//  Created by 杜进新 on 2018/6/28.
//

import UIKit

public class JXTopBarView: UIView {
    var rect = CGRect()
    
    public var titles = Array<String>()
    public var delegate : JXTopBarViewDelegate?
    public var selectedIndex = 0
    public var attribute = TopBarAttribute()
    
    public var isBottomLineEnabled : Bool = false {
        didSet{
            if isBottomLineEnabled {
                for v in subviews {
                    if v is UIButton && v.tag == self.selectedIndex{
                        addSubview(self.bottomLineView)
                        self.bottomLineView.frame = CGRect(x: CGFloat(self.selectedIndex) * v.bounds.width, y: v.bounds.height - 1, width: v.bounds.width, height: 1)
                    }
                }
            }
        }
    }
    public lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        return view
    }()
    
    public init(frame: CGRect,titles:Array<String>) {
        
        selectedIndex = 0
        isBottomLineEnabled = false
        
        super.init(frame: frame)
        
        self.rect = frame
        self.titles = titles
        backgroundColor = UIColor.white
        
        let width = frame.size.width / CGFloat(titles.count)
        let height = frame.size.height
        
        
        for i in 0..<titles.count {
            let title = titles[i]
            
            let button = UIButton()
            button.frame = CGRect.init(x: (width * CGFloat(i)), y: 0, width: width, height: height)
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setTitleColor(attribute.normalColor, for: UIControlState.normal)
            button.setTitleColor(attribute.highlightedColor, for: UIControlState.selected)
            button.tag = i
            button.setTitle(title, for: UIControlState.normal)
            button.addTarget(self, action: #selector(tabButtonAction(button:)), for: UIControlEvents.touchUpInside)
            
            addSubview(button)
            
            if i == 0 {
                button.isSelected = true
                button.setTitle(title, for: .selected)
            }else{
                button.setTitle(title, for: UIControlState.normal)
            }
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tabButtonAction(button : UIButton) {
        print(button.tag)
        
        selectedIndex = button.tag
        button.isSelected = true
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomLineView.frame = CGRect(x: CGFloat(self.selectedIndex) * button.bounds.width, y: self.bounds.height - 1, width: button.bounds.width, height: 1)
        }) { (finished) in
            //
        }
        
        subviews.forEach { (v : UIView) -> () in
            
            if (v is UIButton){
                
                if (v.tag != button.tag){
                    let btn = v as! UIButton
                    btn.isSelected = false
                }
            }
        }
        
        if self.delegate != nil {
            self.delegate?.jxTopBarView(topBarView: self, didSelectTabAt: button.tag)
        }
    }
}
public protocol JXTopBarViewDelegate {
    func jxTopBarView(topBarView : JXTopBarView,didSelectTabAt index:Int) -> Void
}

public class TopBarAttribute: NSObject {
    var normalColor = UIColor.darkGray
    var highlightedColor = UIColor.darkText
    var separatorColor = UIColor.darkGray
    
    override init() {
        normalColor = UIColor.darkGray
        highlightedColor = UIColor.darkText
        separatorColor = UIColor.darkGray
    }
}
