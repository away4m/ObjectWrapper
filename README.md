# Object Wrapper

[![Travis](https://img.shields.io/travis/away4m/ObjectWrapper?style=for-the-badge)](https://travis-ci.org/github/away4m/ObjectWrapper)
[![Cocoapods](https://img.shields.io/cocoapods/v/ObjectWrapper?style=for-the-badge)](https://cocoapods.org/pods/ObjectWrapper)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=for-the-badge)](https://github.com/away4m/ObjectWrapper/releases)
[![License](https://img.shields.io/cocoapods/l/ObjectWrapper.svg?style=for-the-badge)](https://raw.githubusercontent.com/away4m/ObjectWrapper/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/ObjectWrapper.svg?style=for-the-badge)](https://cocoapods.org/pods/ObjectWrapper)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```swift
 let dictWrapper: Wrap = [1, 2.0, "3.0", ["All", ["the": ["way"]], true]]
 
 print(dictWrapper[3][1]["the"].first ?? "")
 
 let string = """
  [1, 2.0, "3.0", ["All", {"the": ["way"]}, true]]
 """
 
 guard let jsonWrapper = Wrap(usingJSON: string) else {
     return true
 }
 
 print(jsonWrapper[3][1]["the"].first ?? "")
```

## Requirements

## Installation

ObjectWrapper is available through [CocoaPods](https://cocoapods.org/pods/ObjectWrapper). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ObjectWrapper'
```

## Author

alikiran, away4m@gmail.com

## License

ObjectWrapper is available under the MIT license. See the LICENSE file for more info.
