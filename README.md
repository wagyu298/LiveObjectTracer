# LiveObjectTracer
Library to notice you when the NSObject or subclass object was deallocated

I was tried to let some actions when the object was deallocated.
LiveObjectTracer is one of the solution for it.

It triggers a delegate method when the NSObject or subclass object was deallocated.
The object includes all of the NSObject subclasses,
your made and third party made and Apple made.
You can use this library to any situations.

I got core concept of LiveObjectTracer from
[Want to perform action when \_\_weak ivar is niled](http://stackoverflow.com/questions/14957382/want-to-perform-action-when-weak-ivar-is-niled).
Thank you stackoverflow and users!

[![Version](https://img.shields.io/cocoapods/v/LiveObjectTracer.svg?style=flat)](http://cocoapods.org/pods/LiveObjectTracer)
[![License](https://img.shields.io/cocoapods/l/LiveObjectTracer.svg?style=flat)](http://cocoapods.org/pods/LiveObjectTracer)
[![Platform](https://img.shields.io/cocoapods/p/LiveObjectTracer.svg?style=flat)](http://cocoapods.org/pods/LiveObjectTracer)

## Requirements

iOS12 or later

## Installation

LiveObjectTracer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LiveObjectTracer', :git => 'https://github.com/wagyu298/LiveObjectTracer.git'
```

## Author

wagyu298

## License

LiveObjectTracer is available under the MIT license. See the LICENSE file for more info.
