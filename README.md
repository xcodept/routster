# routster

This is a proof-of-concept application, that calculates different routes to tours planned with [komoot](https://www.komoot.com "komoot website").
**The app was implemented within 72 hours and does not always contain the best code solution.**  
**Things that could be done differently with more time.**
- Weigh exactly whether an external library makes sense or the corresponding component should rather be developed by yourself.
- Better & consistent use of code patterns.
- Auto-generate Swift code for resources to make them type-safe to use. (e.g. [SwiftGen](https://github.com/SwiftGen/SwiftGen)))
- Code documentation for Swift and Objective-C classes (e.g. [Jazzy](https://github.com/realm/jazzy))

## Installation
- Clone or download the repository.
	`git clone https://github.com/xcodept/routster.git`
- Change to the project directory.
	`cd <project-directory>`
- Make sure you have CocoaPods installed, then install all necessary Pods.
	`pod install`
- Afterwards open the workspace and run the application.

## Features
- User Authentication
- Select multiple tours planned before via komoot
- Calculate routes to selected tours
- In App Navigation (via Mapbox)

## Screenshots
### Login
![](https://raw.githubusercontent.com/xcodept/routster/master/screenshots/routster.6.png "Login")![](https://raw.githubusercontent.com/xcodept/routster/master/screenshots/routster.5.png "Login with Error")
### Map
![](https://raw.githubusercontent.com/xcodept/routster/master/screenshots/routster.4.png "Map-Without-Selected-Tours")![](https://raw.githubusercontent.com/xcodept/routster/master/screenshots/routster.2.png "Map-With-Selected-Tours")
### Tours
![](https://raw.githubusercontent.com/xcodept/routster/master/screenshots/routster.1.png "Tours-Unselected")![](https://raw.githubusercontent.com/xcodept/routster/master/screenshots/routster.3.png "Tours-Selected")
### Tour
![](https://raw.githubusercontent.com/xcodept/routster/master/screenshots/routster.7.png "Tour")
### Navigation
![](https://raw.githubusercontent.com/xcodept/routster/master/screenshots/routster.8.png "Navigation")

#### Test Account
_Komoot Demo Account_  
Email: routster@vomoto.com  
![Email](https://raw.githubusercontent.com/xcodept/routster/master/screenshots/qr/email.png "email qr")  
Username: routster  
Pwd: ybl9XHoHr9SbHMjRL1pmD0JG  
![Pwd](https://raw.githubusercontent.com/xcodept/routster/master/screenshots/qr/pwd.png "pwd qr")  
