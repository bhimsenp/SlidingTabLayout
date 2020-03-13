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
