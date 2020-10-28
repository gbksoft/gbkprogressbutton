# GBKProgressButton

<br>
<p align="center"> 
<!-- ![Preview](/Media/preview.png) -->
<img src="/Media/preview.gif" width="270px">
</p> 
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

GBKProgressButton is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GBKProgressButton', :git => 'git@gitlab.gbksoft.net:gbksoft-mobile-department/ios/gbkprogressbutton.git', :tag => '0.1.3'
```

## Usage 

XIB

- Add new <b>UIView</b>
- In Identity Inspector set GBKProgressButton as a Custom Class 
- Customize parameters In Attributes Inspector 

Для отработки нажатия на кнопку, добавить @IBAction, со значением <b>TouchUpInside</b> (по умолчанию стоит ValueChanged)
<br>
<img src="/Media/ibAction.png" width="270px">

## API

<b>Start Animation</b>
<br>
<img src="/Media/startAnimating.png" width="270px">
<br>
<b>Stop Animation</b>
<br>
<img src="/Media/stopAnimating.png" width="270px">
<br>
<b>Customizations</b>
<br>
<img src="/Media/inspectableCustomizations.png" width="270px">
<br>
You can also customize button title appearance (like <b>Font, Attributed Text etc.</b>) by accesing <b>titleLabel</b>
<br>
```swift
public private(set) lazy var titleLabel = ProgressTitleLabel(animationSettings: animationSettings)
```
## Author

Roman Mizin, mizin.re@gbksoft.com

## License

GBKProgressButton is available under the MIT license. See the LICENSE file for more info.
