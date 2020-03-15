import Foundation

public class SlidingTabLayout: SlidingTabHeaderDelegate, SlidingTabContentViewDelegate {
    
    private var items: [SlidingTabItem]
    public let header: SlidingTabHeaderView
    public let contentView: SlidingTabContentView
    private var selectedTabIndex = 0
    public weak var delegate: SlidingTabLayoutDelegate?
    
    public init(items: [SlidingTabItem], mode: SlidingTabMode = .fixed) {
        assert(items.count > 0, "Should have non zero items")
        self.items = items
        self.header = SlidingTabHeaderView(items: items, mode: mode)
        self.contentView = SlidingTabContentView(viewControllers: items.map({$0.viewController}))
        header.delegate = self
        contentView.delegate = self
    }
    
    public func select(tabIndex: Int, animated: Bool) {
        header.layoutIfNeeded()
        contentView.move(tabIndex, animated: animated)
    }
    
    public func updateItems(items: [SlidingTabItem]) {
        header.updateItems(items)
        contentView.updateItems(items)
    }
    
    func didTapOnItem(withIndex index: Int) {
        contentView.move(index, animated: true)
    }
    
    func didScroll(withOffset offset: CGFloat) {
        header.move(offset)
    }
    
    func didLandOnPage(withIndex index: Int) {
        delegate?.slidingTabLayout(self, didLandOnPageWithIndex: index)
    }
}

public struct SlidingTabItem {
    let title: String?
    let icon: UIImage?
    let viewController: UIViewController
    
    public init(title: String?, icon: UIImage? = nil, viewController: UIViewController) {
        self.title = title
        self.icon = icon
        self.viewController = viewController
    }
}

public enum SlidingTabMode {
    case fixed
    case free
}

extension UIView {
    
    func addSubviewWithMatchingConstraints(_ view: UIView) {
        addSubview(view)
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([top, bottom, right, left])
    }
    
}

public protocol SlidingTabLayoutDelegate: class {
    func slidingTabLayout(_ slidingTabLayout: SlidingTabLayout, didLandOnPageWithIndex index: Int)
}
