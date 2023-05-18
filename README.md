# RaceControlNotifier for "MultiViewer for F1"
Simple tool to let your Mac read race-control-messages from [MultiViewer](https://multiviewer.app) aloud using Siri's voice.

Any message sent by Race Control will be read aloud using the voice `com.apple.voice.premium.en-GB.Malcolm` (which has to be downloaded first and is only supported on macOS 13+).
You can apply filters to exclude messages like blue flags and deleted lap-times.

More voices will be selectable in the future.


# How it works

Every 2 seconds, the app will make a HTTP-request to the MultiViewer API `/v2/live-timing/state/RaceControlMessages`.
New messages will be filtered and if it is supposed to be read aloud, it will be parsed to help Siri a bit. For example lap-time will be split so make sure they are not detected as hours and minutes.
Driver's abbreviations like MSC will be replaced with their last name.


https://user-images.githubusercontent.com/2721240/199205925-7d253991-c5a4-47cd-a283-a5c829a2a2c5.mov


# Why do I need this?

You probably don't.

I started this project to have some fun with SwiftUI and TTS, but it turned out to be a nice gimmick for me, because when watching Formula 1 with [MultiViewer](https://multiviewer.app), I only have one small screen left for the Race Control messages and this application makes it easier to be informed about new messages.


# How can I run this?

As I'm not member of the Apple Developer program, I can't provide the binary of the app. You can clone the repository with Xcode and build it on your own machine.

## System Requirements

* Xcode 14.1+
* macOS 13.0+
* [MultiViewer](https://multiviewer.app) with an active subscription for F1TV Pro or Access
* Premium voice `com.apple.voice.premium.en-GB.Malcolm` installed (Settings -> Accessibility -> Speech -> System voices -> Manage...)

If the proper voice is not installed, Siri will fall back to a low-quality English voice.
