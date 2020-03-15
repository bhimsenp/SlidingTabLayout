import UIKit
import SlidingTabLayout

class ViewController: UIViewController {
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var contentContainer: UIView!
    
    var slidingTab: SlidingTabLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let vc3 = UIViewController()
        vc1.view.backgroundColor = .red
        vc2.view.backgroundColor = .blue
        vc3.view.backgroundColor = .green
        slidingTab = SlidingTabLayout(items: [
            SlidingTabItem(title: "Red", viewController: vc1),
            SlidingTabItem(title: "Blue", viewController: vc2),
            SlidingTabItem(title: "Green", viewController: vc3)
        ])
        headerContainer.addSubviewWithMatchingConstraints(slidingTab.header)
        contentContainer.addSubviewWithMatchingConstraints(slidingTab.contentView)
        slidingTab.header.sliderColor = UIColor.green
        slidingTab.header.activeTitleColor = .brown
        slidingTab.select(tabIndex: 2, animated: false)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let vc3 = UIViewController()
        vc1.view.backgroundColor = .red
        vc2.view.backgroundColor = .blue
        vc3.view.backgroundColor = .green
        slidingTab.updateItems(items: [
            SlidingTabItem(title: "Red", viewController: vc1),
            SlidingTabItem(title: "Blue", viewController: vc2)
        ])
    }
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
