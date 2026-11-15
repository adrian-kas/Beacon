# Beacon

Beacon is an iOS app built with SwiftUI. It helps users explore nearby restaurants, cafes, and hotels on a map or in a list, and save favorite places on their device.

## Features

- Find nearby restaurants, cafes, and hotels
- Browse places on a map or in a list
- Search results and adjust the search radius
- Use the device's location or a default location
- Save and remove favorite places locally with SwiftData

## Requirements

- Xcode 26 or newer
- iOS 26 or newer (the deployment target configured for this project)
- A Geoapify API key to fetch places

## Configure the API key

The app uses the Geoapify Places API. Create a key in your Geoapify account, then copy `Secrets.xcconfig.example` to `Secrets.xcconfig` in the project root and replace the example value with your key. `Secrets.xcconfig` is ignored by Git and should not be committed.

Client app keys are included in the installed app and cannot be kept secret from its users. Use a key with suitable restrictions and usage limits. Rotate any key that has already been published.

## Run in Xcode

1. Open `Beacon.xcodeproj` in Xcode.
2. Configure the Geoapify key as described above.
3. Select an iOS simulator or connected device.
4. Select the `Beacon` scheme and click **Run**.

Allow location access when prompted to search around your current location. Without location access, the app uses its default map location.

## Build from the command line

From the project root, build for the iOS Simulator with:

```bash
xcodebuild -project Beacon.xcodeproj -scheme Beacon -destination 'generic/platform=iOS Simulator' build
```
