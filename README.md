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

Xib

Добавить на вью UIView
В Identity Inspector в качетсве Custom Class указать GBKProgressButton
В Attributes Inspector указать необходимые параметры

Для отработки нажатия на кнопку, добавить @IBAction, со значением <b>TouchUpInside</b> (по умолчанию стоит ValueChanged)
<br>
<img src="/Media/ibAction.png" width="270px">
## Author

Roman Mizin, mizin.re@gbksoft.com

## License

GBKProgressButton is available under the MIT license. See the LICENSE file for more info.
