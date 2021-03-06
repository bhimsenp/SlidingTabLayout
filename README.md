# SlidingTabLayout

[![Version](https://img.shields.io/cocoapods/v/SlidingTabLayout.svg?style=flat)](https://cocoapods.org/pods/SlidingTabLayout)
[![Platform](https://img.shields.io/cocoapods/p/SlidingTabLayout.svg?style=flat)](https://cocoapods.org/pods/SlidingTabLayout)

## About

SlidingTabLayout is a library that can be used to add paging view controllers accompanied with Tabs at the top. You can place tab items in header separately from the content views as well as in a single view. It also allows to layout tabs is two modes:

1. Fixed (Used for small number of items): All tab items will be spread equally in a container with width equal to screen
2. Free (User for large number of items): All tab items will be have given hardcoded width and be scrollable horizontally.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SlidingTabLayout is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SlidingTabLayout'
```

## Adding SlidingTabLayout to your view

### 1. Continuous Header & Content

Use instance of 'SlidingTabView':

```
import SlidingTabLayout
.
.
.
func addSlidingTab() {
    let vc1 = UIViewController()
    let vc2 = UIViewController()
    let vc3 = UIViewController()
    vc1.view.backgroundColor = .red
    vc2.view.backgroundColor = .blue
    vc3.view.backgroundColor = .green

    let slidingTabView = SlidingTabView()
    slidingTabView.layout.setItems(items: [
                SlidingTabItem(title: "Red", viewController: vc1),
                SlidingTabItem(title: "Blue", viewController: vc2),
                SlidingTabItem(title: "Green", viewController: vc3)
            ])
    myView.addSubview(slidingTabView)
}

```

### 2. Disjoint Header & Content

Use instance of 'SlidingTabLayout':

```
let vc1 = UIViewController()
let vc2 = UIViewController()
let vc3 = UIViewController()
vc1.view.backgroundColor = .red
vc2.view.backgroundColor = .blue
vc3.view.backgroundColor = .green

self.slidingTabLayout = SlidingTabLayout(items: [
            SlidingTabItem(title: "Red", viewController: vc1),
            SlidingTabItem(title: "Blue", viewController: vc2),
            SlidingTabItem(title: "Green", viewController: vc3)
        ])
myView.addSubview(self.slidingTab.layout.header)
// Add constraints or frame for header
myView.addSubview(self.slidingTab.layout.contentView)
// Add constraints or frame for contentView
```

### 3. Adding from Storyboard/XIB

![Add From Storyboard](https://raw.githubusercontent.com/bhimsenp/SlidingTabLayout/0.1.0/images/add_storyboard.png)

## Changing appearance

Following properties can be changed:
1. Text color of active/inactive tab
2. Background color of active/inactive tab
3. Font of active/inactive tab
4. Color of slider
5. Height of slider

### Changing Programmatically

```
slidingTab.header.sliderColor = .green
slidingTab.header.activeTitleColor = .brown
slidingTab.header.sliderHeight = 5.0
```

### From storyboard
Few properties can be changed from storyboard:

![Change Properties From Storyboard](https://raw.githubusercontent.com/bhimsenp/SlidingTabLayout/0.1.0/images/change_properties.png)

## Author

Bhimsen Padalkar, bhim.padalkar@gmail.com

## License

SlidingTabLayout is available under the MIT license. See the LICENSE file for more info.
