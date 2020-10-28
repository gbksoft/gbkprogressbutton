# GBKProgressButton

<br>
<p align="center"> 
<!-- ![Preview](/Media/preview.png) -->
<img src="/Media/preview.gif" width="270px">
</p> 

## Example

To run the <b>example project</b>, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

GBKProgressButton is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GBKProgressButton', :git => 'git@gitlab.gbksoft.net:gbksoft-mobile-department/ios/gbkprogressbutton.git', :tag => '0.1.4'
```

## Usage 

<b>XIB</b>

- Add new <b>UIView</b>
- In Identity Inspector set GBKProgressButton as a Custom Class 
- Customize parameters In Attributes Inspector 
- To handle button touch add @IBAction, with <b>TouchUpInside</b> value
- Call <b>animate()</b> method from previously added @IBAction

<br>
<img src="/Media/ibAction.png" width="270px">

## API

<b>Start Animation</b>
<br>
<img src="/Media/startAnimating.png" width="500px">
<br>
<br>
<b>Stop Animation</b>
<br>
<img src="/Media/stopAnimating.png" width="500px">
<br>
<br>
<b>Customizations</b>
<br>
<img src="/Media/inspectableCustomizations.png" width="500px">
<br>
<br>
<b>WHOLE PUBLIC API</b>
<br>
```swift
    @IBInspectable public var lineWidth: CGFloat

    @IBInspectable public var primaryColor: UIColor

    @IBInspectable public var downloadProgressColor: UIColor

    @IBInspectable public lazy var animationDuration: Double { get set }

    @IBInspectable public var titleText: String { get set }

    @IBInspectable public var titleColor: UIColor { get set }

    @IBInspectable public var titleImage: UIImage? { get set }

    @IBInspectable public lazy var cornerRadius: CGFloat { get set }

    public lazy var font: UIFont { get set }

    public var attributedText: NSAttributedString? { get set }

    public private(set) lazy var imageView: UIImageView { get set }

    public private(set) lazy var titleLabel: UILabel { get set }

    public var currentProgress: CGFloat { get }

    /// To reset button in UITableViewCell/UICollectionViewCell
    public func prepareForReuse()

    public func reset()

    public func animate(to newValue: CGFloat = 0.0, animated: Bool = true, downloaded: (() -> Void)? = nil)
```
## Author

Roman Mizin, mizin.re@gbksoft.com

## License

GBKProgressButton is available under the MIT license. See the LICENSE file for more info.
