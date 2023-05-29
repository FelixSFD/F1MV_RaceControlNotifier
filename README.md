# RaceControlNotifier for "MultiViewer for F1"
Simple tool to let your Mac or iOS device read race-control-messages from [MultiViewer](https://multiviewer.app) aloud using Siri's voice.

Any message sent by Race Control will be read aloud using an English voice you've selected in the settings. By default, this will be a low quality voice. But you can download Premium or Enhanced voices in macOS/iOS settings.

You can also apply filters to exclude messages like blue flags and deleted lap-times.

# How it works

Every 2 seconds, the app will make a HTTP-request to the MultiViewer API `/v2/live-timing/state/RaceControlMessages`.
New messages will be filtered and if it is supposed to be read aloud, it will be parsed to help Siri a bit. For example lap-time will be split so make sure they are not detected as hours and minutes.
Driver's abbreviations like MSC will be replaced with their last name.

## Demo on macOS

https://user-images.githubusercontent.com/2721240/199205925-7d253991-c5a4-47cd-a283-a5c829a2a2c5.mov

## Demo on iOS

https://github.com/FelixSFD/F1MV_RaceControlNotifier/assets/2721240/5fc70e51-4a99-4180-8dde-fb8687ce997a




# Why do I need this?

You probably don't.

I started this project to have some fun with SwiftUI and TTS, but it turned out to be a nice gimmick for me, because when watching Formula 1 with [MultiViewer](https://multiviewer.app), I only have one small screen left for the Race Control messages and this application makes it easier to be informed about new messages.


# How can I run this?

As I'm not member of the Apple Developer program, I can't provide the binary of the app. You can clone the repository with Xcode and build it on your own machine.

## System Requirements

* Xcode 14.1+
* macOS 13.0+
* iOS 16+
* [MultiViewer](https://multiviewer.app) with an active subscription for F1TV Pro or Access
* Recommended: at least one Premium voice like `com.apple.voice.premium.en-GB.Malcolm` installed (Settings -> Accessibility -> Speech -> System voices -> Manage...)

If the proper voice is not installed, Siri will fall back to a low-quality voice.
