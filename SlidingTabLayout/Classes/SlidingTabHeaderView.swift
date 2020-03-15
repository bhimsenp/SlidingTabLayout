import Foundation

public class SlidingTabHeaderView: UIView {
    
    private var items: [SlidingTabItem]
    private let mode: SlidingTabMode
    private var buttons: [UIButton] = []
    private let stackView = UIStackView()
    private let slider = UIView()
    private let scrollView = UIScrollView()
    private var sliderLeadingConstraint: NSLayoutConstraint!
    private var sliderHeightConstraint: NSLayoutConstraint!
    weak var delegate: SlidingTabHeaderDelegate?
    
    private var selectedIndex: Int {
        get {
            buttons.firstIndex(where: {$0.isSelected}) ?? 0
        }
    }
    
    public var activeTitleColor: UIColor = .black { didSet { refreshButtons() } }
    
    public var inactiveTitleColor: UIColor = .darkGray { didSet { refreshButtons() } }
    
    public var activeBackgroundColor: UIColor = .clear { didSet { refreshButtons() } }
    
    public var inactiveBackgroundColor: UIColor = .clear { didSet { refreshButtons() } }
    
    public var activeFont: UIFont = .boldSystemFont(ofSize: 15) { didSet { refreshButtons() } }
    
    public var inactiveFont: UIFont = .systemFont(ofSize: 15) { didSet { refreshButtons() } }
    
    public var buttonWidth: CGFloat = 100 { didSet { updateButtonWidth() } }
    
    public var sliderColor: UIColor = .black {
        didSet { slider.backgroundColor = sliderColor }
    }
    
    public var sliderHeight: CGFloat = 5.0 {
        didSet { sliderHeightConstraint.constant = sliderHeight }
    }
    
    init(items: [SlidingTabItem], mode: SlidingTabMode) {
        self.items = items
        self.mode = mode
        super.init(frame: CGRect.zero)
        layoutScrollView()
        layoutTabs()
        layoutSlider()
        updateButtonStyle(selectedIndex: 0)
    }
    
    required init?(coder: NSCoder) {
        self.items = []
        self.mode = .fixed
        super.init(coder: coder)
    }
    
    private func layoutScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        addSubviewWithMatchingConstraints(scrollView)
        scrollView.addSubviewWithMatchingConstraints(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        let equalWidthConstraint = NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0)
        let equalHeightConstraint = NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([equalHeightConstraint])
        if(mode == .fixed) {
            NSLayoutConstraint.activate([equalWidthConstraint])
        }
    }
    
    private func layoutTabs() {
        buttons = items.enumerated().map { (i, item) -> UIButton in
            let button = UIButton(type: .custom)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            button.setTitle(item.title ?? item.viewController.title, for: .normal)
            button.setImage(item.icon, for: .normal)
            button.tag = i
            return button
        }
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        buttons.forEach { (button) in
            stackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(SlidingTabHeaderView.buttonClicked(sender:)), for: .touchUpInside)
        }
        updateButtonWidth()
    }
    
    private func layoutSlider() {
        slider.removeFromSuperview()
        let bottom = NSLayoutConstraint(item: slider, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        sliderLeadingConstraint = NSLayoutConstraint(item: slider, attribute: .leading, relatedBy: .equal, toItem: stackView, attribute: .leading, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: slider, attribute: .width, relatedBy: .equal, toItem: buttons[0], attribute: .width, multiplier: 1, constant: 0)
        sliderHeightConstraint = NSLayoutConstraint(item: slider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: sliderHeight)
        slider.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(slider)
        slider.backgroundColor = sliderColor
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
        let currentIndex = lround(Double(offset))
        updateButtonStyle(selectedIndex: currentIndex)
        scrollView.scrollRectToVisible(buttons[currentIndex].frame, animated: true)
        sliderLeadingConstraint.constant = slider.frame.width * offset
    }
    
    @objc func buttonClicked(sender: UIButton) {
        delegate?.didTapOnItem(withIndex: sender.tag)
    }
    
    private func updateButtonWidth() {
        if(mode == .free) {
            let constraints = buttons.map { (button) -> NSLayoutConstraint in
                NSLayoutConstraint.deactivate(button.constraints.filter({$0.firstAttribute == .width }))
                return NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: buttonWidth)
            }
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    private func refreshButtons() {
        updateButtonStyle(selectedIndex: selectedIndex)
    }
    
    private func updateButtonStyle(selectedIndex: Int) {
        select(buttons[selectedIndex])
        buttons.filter({$0.tag != selectedIndex}).forEach({self.unselect($0)})
    }
    
    func select(_ button: UIButton) {
        button.backgroundColor = activeBackgroundColor
        button.isSelected = true
        button.titleLabel?.font = activeFont
        button.setTitleColor(activeTitleColor, for: .normal)
    }
    
    func unselect(_ button: UIButton) {
        button.backgroundColor = inactiveBackgroundColor
        button.isSelected = false
        button.titleLabel?.font = inactiveFont
        button.setTitleColor(inactiveTitleColor, for: .normal)
    }
    
}

protocol SlidingTabHeaderDelegate: class {
    func didTapOnItem(withIndex index: Int)
}
