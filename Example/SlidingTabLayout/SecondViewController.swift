import UIKit
import SlidingTabLayout

class SecondViewController: UIViewController {

    @IBOutlet weak var slidingTabView: SlidingTabView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let vc3 = UIViewController()
        vc1.view.backgroundColor = .red
        vc2.view.backgroundColor = .blue
        vc3.view.backgroundColor = .green
        slidingTabView.layout.setItems(items: [
            SlidingTabItem(title: "Red", viewController: vc1),
            SlidingTabItem(title: "Blue", viewController: vc2),
            SlidingTabItem(title: "Green", viewController: vc3)
        ])
        slidingTabView.layout.select(tabIndex: 1, animated: true)
    }

}
