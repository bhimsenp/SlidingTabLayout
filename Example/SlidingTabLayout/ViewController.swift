//
//  ViewController.swift
//  SlidingTabLayout
//
//  Created by bhimsenp on 03/12/2020.
//  Copyright (c) 2020 bhimsenp. All rights reserved.
//

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
		headerContainer.addSubviewWithMatchingConstraints(slidingTab.getHeader())
		contentContainer.addSubviewWithMatchingConstraints(slidingTab.getContentView())
    }

}
