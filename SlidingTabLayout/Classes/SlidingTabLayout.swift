import Foundation

public class SlidingTabLayout: SlidingTabHeaderDelegate, SlidingTabContentViewDelegate {
    
    private var items: [SlidingTabItem]
    public let header: SlidingTabHeaderView
    public let contentView: SlidingTabContentView
    private var selectedTabIndex = 0
    
    public init(items: [SlidingTabItem]) {
        assert(items.count > 0, "Should have non zero items")
        self.items = items
        self.header = SlidingTabHeaderView(items: items)
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

public class SlidingTabHeaderView: UIView {
    
    private var items: [SlidingTabItem]
    private var buttons: [UIButton] = []
    private let stackView = UIStackView()
    private let slider = UIView()
    private var sliderLeadingConstraint: NSLayoutConstraint!
    private var sliderHeightConstraint: NSLayoutConstraint!
    weak var delegate: SlidingTabHeaderDelegate?
    
    private var selectedIndex: Int {
        get {
            buttons.firstIndex(where: {$0.isSelected}) ?? 0
        }
    }
    
    public var activeTitleColor: UIColor = UIColor.black {
        didSet { refreshButtons() }
    }
    
    public var inactiveTitleColor: UIColor = UIColor.darkGray {
        didSet { refreshButtons() }
    }
    
    public var activeFont: UIFont = UIFont.boldSystemFont(ofSize: 15) {
        didSet { refreshButtons() }
    }
    
    public var inactiveFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet { refreshButtons() }
    }
    
    public var sliderColor: UIColor = UIColor.black {
        didSet { slider.backgroundColor = sliderColor }
    }
    
    public var sliderHeight: CGFloat = 5.0 {
        didSet { sliderHeightConstraint.constant = sliderHeight }
    }
    
    init(items: [SlidingTabItem]) {
        self.items = items
        super.init(frame: CGRect.zero)
        addSubviewWithMatchingConstraints(stackView)
        layoutTabs()
        layoutSlider()
        updateButtonStyle(selectedIndex: 0)
    }
    
    required init?(coder: NSCoder) {
        self.items = []
        super.init(coder: coder)
    }
    
    private func layoutTabs() {
        buttons = items.enumerated().map { (i, item) -> UIButton in
            let button = UIButton(type: .custom)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10)
            button.setTitle(item.title ?? item.viewController.title, for: .normal)
            button.setImage(item.icon, for: .normal)
            button.tag = i
            return button
        }
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        buttons.forEach { (button) in
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(SlidingTabHeaderView.buttonClicked(sender:)), for: .touchUpInside)
        }
    }
    
    private func layoutSlider() {
        slider.removeFromSuperview()
        let bottom = NSLayoutConstraint(item: slider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        sliderLeadingConstraint = NSLayoutConstraint(item: slider, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: slider, attribute: .width, relatedBy: .equal, toItem: buttons[0], attribute: .width, multiplier: 1, constant: 0)
        sliderHeightConstraint = NSLayoutConstraint(item: slider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: sliderHeight)
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(slider)
        NSLayoutConstraint.activate([bottom, width, sliderLeadingConstraint, sliderHeightConstraint])
    }
    
    func updateItems(_ items: [SlidingTabItem]) {
        let previouslySelected = selectedIndex
        self.items = items
        layoutTabs()
        layoutSlider()
        layoutIfNeeded()
        updateButtonStyle(selectedIndex: previouslySelected >= items.count ? items.count - 1 : previouslySelected)
    }
    
    func move(_ offset: CGFloat) {
        updateButtonStyle(selectedIndex: lround(Double(offset)))
        sliderLeadingConstraint.constant = slider.frame.width * offset
    }
    
    @objc func buttonClicked(sender: UIButton) {
        delegate?.didTapOnItem(withIndex: sender.tag)
    }
    
    private func refreshButtons() {
        updateButtonStyle(selectedIndex: selectedIndex)
    }
    
    private func updateButtonStyle(selectedIndex: Int) {
        select(buttons[selectedIndex])
        buttons.filter({$0.tag != selectedIndex}).forEach({self.unselect($0)})
    }
    
    func select(_ button: UIButton) {
        button.isSelected = true
        button.titleLabel?.font = activeFont
        button.setTitleColor(activeTitleColor, for: .normal)
    }
    
    func unselect(_ button: UIButton) {
        button.isSelected = false
        button.titleLabel?.font = inactiveFont
        button.setTitleColor(inactiveTitleColor, for: .normal)
    }
    
}

public class SlidingTabContentView: UIView, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    private var viewControllers: [UIViewController]
    private let pageViewController: UIPageViewController
    private var selectedTabIndex = 0
    weak var delegate: SlidingTabContentViewDelegate?
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        super.init(frame: CGRect.zero)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        addSubviewWithMatchingConstraints(self.pageViewController.view)
        if let first = viewControllers.first {
            pageViewController.setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
        (pageViewController.view.subviews.first as? UIScrollView)?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        self.viewControllers = []
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        super.init(coder: coder)
    }
    
    func updateItems(_ items: [SlidingTabItem]) {
        selectedTabIndex = selectedTabIndex >= items.count ? items.count - 1 : selectedTabIndex
        self.viewControllers = items.map({$0.viewController})
        move(selectedTabIndex, animated: false)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController), index > 0 {
            return viewControllers[index-1]
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 {
            return viewControllers[index+1]
        }
        return nil
    }
    
    func move(_ index: Int, animated: Bool) {
        for i in stride(from: selectedTabIndex, through: index, by: selectedTabIndex > index ? -1 : 1) {
            pageViewController.setViewControllers([viewControllers[i]], direction: selectedTabIndex > i ? .reverse : .forward, animated: animated, completion: nil)
        }
        if(!animated) {
            selectedTabIndex = index
            delegate?.didScroll(withOffset: (CGFloat)(index))
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.x != scrollView.frame.width) {
            let offset = (scrollView.contentOffset.x / scrollView.frame.width) - 1
            let isBouncingToRight = selectedTabIndex == viewControllers.count - 1 && scrollView.contentOffset.x >= scrollView.frame.width
            let isBouncingToLeft = selectedTabIndex == 0 && scrollView.contentOffset.x <= scrollView.frame.width
            if(!(isBouncingToLeft || isBouncingToRight)) {
                delegate?.didScroll(withOffset: CGFloat(selectedTabIndex) + offset)
                if(offset == 1) { selectedTabIndex += 1 }
                if(offset == -1) { selectedTabIndex -= 1 }
            }
        }
    }
    
}

protocol SlidingTabHeaderDelegate: class {
    func didTapOnItem(withIndex index: Int)
}

protocol SlidingTabContentViewDelegate: class {
    func didScroll(withOffset offset: CGFloat)
}

public extension UIView {
    
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
