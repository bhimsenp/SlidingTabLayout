import UIKit

@IBDesignable
public class SlidingTabView: UIView {
    
    public let layout: SlidingTabLayout
    
    @IBInspectable public var isFixedMode: Bool = true { didSet { layout.setHeaderMode(isFixedMode ? .fixed : .free) } }
    
    @IBInspectable public var activeTitleColor: UIColor = .black { didSet { layout.header.activeTitleColor = activeTitleColor } }
    
    @IBInspectable public var inactiveTitleColor: UIColor = .darkGray { didSet { layout.header.inactiveTitleColor = inactiveTitleColor } }
    
    @IBInspectable public var activeBackgroundColor: UIColor = .clear { didSet { layout.header.activeBackgroundColor = activeBackgroundColor } }
    
    @IBInspectable public var inactiveBackgroundColor: UIColor = .clear { didSet { layout.header.inactiveBackgroundColor = inactiveBackgroundColor } }
    
    @IBInspectable public var activeFont: UIFont = .boldSystemFont(ofSize: 15) { didSet { layout.header.activeFont = activeFont } }
    
    @IBInspectable public var inactiveFont: UIFont = .systemFont(ofSize: 15) { didSet { layout.header.inactiveFont = inactiveFont } }
    
    @IBInspectable public var buttonWidth: CGFloat = 100 { didSet { layout.header.buttonWidth = buttonWidth } }
    
    @IBInspectable public var sliderColor: UIColor = .black { didSet { layout.header.sliderColor = sliderColor } }
    
    @IBInspectable public var sliderHeight: CGFloat = 5.0 { didSet { layout.header.sliderHeight = sliderHeight } }
    
    @IBInspectable public var headerHeight: CGFloat = 40 { didSet { headerHeightConstraint.constant = headerHeight } }
    
    @IBInspectable private var headerHeightConstraint: NSLayoutConstraint!
    
    public override init(frame: CGRect) {
        let items = [
            SlidingTabItem(title: "First", viewController: UIViewController()),
            SlidingTabItem(title: "Second", viewController: UIViewController())
        ]
        self.layout = SlidingTabLayout(items: items)
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        let items = [
            SlidingTabItem(title: "First", viewController: UIViewController()),
            SlidingTabItem(title: "Second", viewController: UIViewController())
        ]
        self.layout = SlidingTabLayout(items: items)
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(layout.header)
        addSubview(layout.contentView)
        layout.header.translatesAutoresizingMaskIntoConstraints = false
        layout.contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutHeader()
        layoutContentView()
    }
    
    private func layoutHeader() {
        let top = NSLayoutConstraint(item: layout.header, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: layout.header, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: layout.header, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        headerHeightConstraint = NSLayoutConstraint(item: layout.header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: headerHeight)
        NSLayoutConstraint.activate([top, right, left, headerHeightConstraint])
    }
    
    private func layoutContentView() {
        let top = NSLayoutConstraint(item: layout.contentView, attribute: .top, relatedBy: .equal, toItem: layout.header, attribute: .bottom, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: layout.contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: layout.contentView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: layout.contentView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([top, bottom, right, left])
    }
    
}
