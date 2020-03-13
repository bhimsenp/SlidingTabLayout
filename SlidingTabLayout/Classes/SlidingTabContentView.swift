import Foundation

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

protocol SlidingTabContentViewDelegate: class {
    func didScroll(withOffset offset: CGFloat)
}
