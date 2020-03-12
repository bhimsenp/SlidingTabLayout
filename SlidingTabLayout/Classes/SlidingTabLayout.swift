import Foundation

public class SlidingTabLayout: SlidingTabHeaderDelegate, SlidingTabContentViewDelegate {
	
	let items: [SlidingTabItem]
	private let header: SlidingTabHeaderView
	private let contentView: SlidingTabContentView
	private var selectedTabIndex = 0
	
	public init(items: [SlidingTabItem]) {
		assert(items.count > 0, "Should have non zero items")
		self.items = items
		self.header = SlidingTabHeaderView(titles: items.map({$0.title}))
		self.contentView = SlidingTabContentView(viewControllers: items.map({$0.viewController}))
		header.delegate = self
		contentView.delegate = self
	}
	
	public func getHeader() -> SlidingTabHeaderView {
		header
	}
	
	public func getContentView() -> SlidingTabContentView {
		contentView
	}
	
	func didTapOnItem(withIndex index: Int) {
		contentView.move(index)
	}
	
	func didScroll(withOffset offset: CGFloat) {
		header.move(offset)
	}
}

public struct SlidingTabItem {
	let title: String
	let viewController: UIViewController
	
	public init(title: String, viewController: UIViewController) {
		self.title = title
		self.viewController = viewController
	}
}

public class SlidingTabHeaderView: UIView {
	
	private let titles: [String]
	private let slider: UIView
	private var sliderLeadingConstraint: NSLayoutConstraint!
	private let buttons: [UIButton]
	weak var delegate: SlidingTabHeaderDelegate?
	
	init(titles: [String]) {
		self.titles = titles
		buttons = titles.enumerated().map { (i, title) -> UIButton in
			let button = UIButton(type: .system)
			button.setTitle(title, for: .normal)
			button.tag = i
			return button
		}
		slider = UIView()
		super.init(frame: CGRect.zero)
		buttons.forEach({$0.addTarget(self, action: #selector(SlidingTabHeaderView.buttonClicked(sender:)), for: .touchUpInside)})
		let stackview = UIStackView(arrangedSubviews: buttons)
		stackview.axis = .horizontal
		stackview.distribution = .fillEqually
		addSubviewWithMatchingConstraints(stackview)
		slider.backgroundColor = .black
		let bottom = NSLayoutConstraint(item: slider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
		sliderLeadingConstraint = NSLayoutConstraint(item: slider, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
		let width = NSLayoutConstraint(item: slider, attribute: .width, relatedBy: .equal, toItem: buttons[0], attribute: .width, multiplier: 1, constant: 0)
		let height = NSLayoutConstraint(item: slider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 5)
		slider.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(slider)
		NSLayoutConstraint.activate([bottom, width, sliderLeadingConstraint, height])
	}
	
	required init?(coder: NSCoder) {
		self.titles = []
		self.buttons = []
		self.slider = UIView()
		super.init(coder: coder)
	}
	
	func move(_ offset: CGFloat) {
		sliderLeadingConstraint.constant = slider.frame.width * offset
	}
	
	@objc func buttonClicked(sender: UIButton) {
		delegate?.didTapOnItem(withIndex: sender.tag)
	}
	
}

public class SlidingTabContentView: UIView, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
	
	private let viewControllers: [UIViewController]
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
	
	func move(_ index: Int) {
		for i in stride(from: selectedTabIndex, through: index, by: selectedTabIndex > index ? -1 : 1) {
			pageViewController.setViewControllers([viewControllers[i]], direction: selectedTabIndex > i ? .reverse : .forward, animated: true, completion: nil)
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
