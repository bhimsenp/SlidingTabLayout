import Foundation

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
    
    public var activeTitleColor: UIColor = UIColor.black { didSet { refreshButtons() } }
    
    public var inactiveTitleColor: UIColor = UIColor.darkGray { didSet { refreshButtons() } }
    
    public var activeFont: UIFont = UIFont.boldSystemFont(ofSize: 15) { didSet { refreshButtons() } }
    
    public var inactiveFont: UIFont = UIFont.systemFont(ofSize: 15) { didSet { refreshButtons() } }
    
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

protocol SlidingTabHeaderDelegate: class {
    func didTapOnItem(withIndex index: Int)
}
