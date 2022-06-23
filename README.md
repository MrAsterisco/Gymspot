# Gymspot
Gymspot is an alternative workout tracker written in SwiftUI.

I decided to start working on it because:

1. I need an easy-to-use tracker for my workouts.
2. I want to use this project as a sandbox to learn how to build a complex app in SwiftUI.

## Goal
*Disclaimer: this section describes where I'd like to take Gymspot. The features listed here may not have been implemented yet.*

Gymspot wants to be your favorite workout tracker: configure your workout and run it in a matter of seconds. You can even start from an empty workout and add exercises as you go.

Gymspot also targets advanced users with support for warmups, time-based exercises, dynamic rest times, and more.

Gymspot works on all your Apple devices, providing feature parity, even on the Apple Watch.

Gymspot seamlessly syncs all your data across your devices with a simple and safe account connected to your Apple ID. Gymspot can also sync with Apple Health and automatically log your active and total calories.

## Download
Once we get to a point where Gymspot can be distributed, there will be a version released on the App Store. The App Store version will offer both a free tier (with limited functionalities) and a paid monthly subscription (for a very low fee).

The subscription will be used to pay Firebase. If you don't want to pay, you can clone this repository and create your own Firebase instance.

## Contribute
I am happy to accept contributions to Gymspot. Everybody is different at the gym and we all have different needs: if you see a ticket you'd like to work on, or even if you want to implement a new feature, you are welcome to fork this repo and push a PR.

[InerziaSoft](https://inerziasoft.eu) will publish Gymspot on the App Store and will manage the Firebase instance.

### Getting Started
After you forked or cloned the repo, you should be able to build the project just by opening the `Gymspot.xcodeproj` file with Xcode.

Gymspot requires Xcode 14.0 Beta 2 or higher.

### Configure Firebase
Gymspot uses Firebase to authenticate users and store data. Firebase has a free tier that allows unlimited users, but there are limitations on the amount of data you can store.

In order to configure Gymspot to use your own Firebase instance, follow these steps:

- Change the bundle identifier of Gymspot. The project uses `eu.inerziasoft.Gymspot` by default, because this project is published on the App Store thanks to [InerziaSoft](https://inerziasoft.eu). **You cannot reuse this bundle identifier**.
- Create a new project on the [Firebase Console](https://console.firebase.google.com/) using your own bundle identifier.
- Download the `GoogleService-Info.plist` and place it under `Gymspot/Supporting Files`.
- On Firebase, enable the Authentication service and add "Apple" as sign-in method.
- Also, enable Firestore Database. *You may need to configure the security settings: you can refer to the Firebase documentation for further details.*

### Project Structure
The Gymspot project is currently split into two parts:

1. The iOS and iPadOS app.
2. The Swift Package "GymspotKit".

While the app contains all the UI and related logic, all the protocols, business logic managers and repositories are in "GymspotKit".

If you are in doubt on where to add something, you may refer to this rule:

> If you're going to need it on Gymspot on another platform, it should go in "GymspotKit".

## Documentation
*At this time, there is no documentation provided. There might be documentation on specific classes in code. If you have questions, I am happy to answer: just open an issue.*

## Contributions
All contributions to expand the app are welcome. Fork the repo, make the changes you want, and open a Pull Request.

If you make changes to the codebase, I will ask you to comply with the existing code style, conventions and rules.

## Status
This app is in its early stages: most of the intended features are either very limited or not implemented at all.

You can follow the progress by looking at the open issues.

## License
The Gymspot source code is distributed under the MIT license. See LICENSE for details.