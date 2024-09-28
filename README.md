# Temperature Conversion App
A Flutter-based mobile application for converting temperatures between Fahrenheit and Celsius. The app provides an intuitive and user-friendly interface, allowing users to input temperatures and convert them, while keeping a record of all conversions in a "History" section.

## Table of Contents
- Features
- Technologies
- Getting Started
- Usage
- License

### Features
**- Convert Between Fahrenheit and Celsius:** The app allows users to convert temperatures between Fahrenheit and Celsius, supporting both directions.
**- Conversion History:** Each conversion is saved in a history list so users can see their previous calculations.
**- Light and Dark Mode:** The app is visually appealing with both light and dark mode options, ensuring a great experience in various lighting conditions.
**- Landscape and Portrait Orientation:** The app works smoothly in both portrait and landscape orientations.
- User-Friendly Interface: Clean, minimalistic, and easy-to-use interface built using Flutter.

### Technologies
- Flutter: A framework for building cross-platform mobile apps using Dart.
- Dart: The programming language used for Flutter development.
- SharedPreferences: Used for saving conversion history locally on the device.
- FontAwesome Icons: For adding visually appealing icons throughout the app.
- Responsive UI: Supports both light and dark modes and adjusts based on orientation.

## Getting Started
### Requirements
To get started with this app, you’ll need the following:

**- Flutter SDK:** Install Flutter
**- Android Studio/VSCode:** An IDE for running and testing the app.
- Dart: Included with the Flutter SDK, but make sure it's configured correctly.
**- Device/Emulator:** To run the app on either Android or iOS.

### Usage
- Select Conversion: Choose whether you want to convert from Fahrenheit to Celsius or Celsius to Fahrenheit by selecting the appropriate radio button.
- Enter Temperature: Input the temperature value you want to convert.
- Convert: Press the "Convert" button to display the result.
- History: View previous conversions in the history section.
- Clear History: Press the "Clear History" button if you want to reset your conversion history.
- Landscape and Portrait Support
- The app works flawlessly in both portrait and landscape modes, adjusting its layout dynamically to give a seamless experience. No need to worry about orientation changes — the UI remains clean and functional.

### Shared Preferences
The app uses SharedPreferences to store the conversion history locally on the device. This ensures that even if you close the app, your history will persist until manually cleared. Here’s how it works:

Saving History: Every conversion is added to a list and saved using SharedPreferences.
Loading History: On app startup, the history is loaded from SharedPreferences and displayed in the app.
Customization and Design
The app uses FontAwesome icons for a sleek and modern design. The color scheme has been carefully chosen to look great in both light and dark mode.

### License
This project is licensed under the MIT License - see the **LICENSE** file for details.


