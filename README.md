# VIBEZ - Party Games

A fun Flutter-based party game application with multiple mini-games for social gatherings. VIBEZ brings the excitement of classic party games to your mobile device with a modern UI and seamless gameplay.

## Features

- **Multiple Games**: Includes Truth or Dare (Verdad o Reto), Spin the Bottle (La Botella), and Would You Rather (Qué Prefieres)
- **Player Management**: Add and manage multiple players with customizable names
- **Score Tracking**: Keep track of player scores across game sessions
- **Modern UI**: Beautiful, animated interface with vibrant colors and smooth transitions
- **Persistent Storage**: Player data is saved between app sessions

## Game Types

1. **Truth or Dare (Verdad o Reto)**: The classic party game with three difficulty levels: Normal, Spicy and Hot
2. **Spin the Bottle (La Botella)**: Let fate decide who gets the next question or challenge
3. **Would You Rather (Qué Prefieres)**: Choose between two difficult options and discover your friends' preferences
4. **Never Have I Ever (Yo Nunca Nunca)**: Find out what your friends have or haven't done

## Installation

### Android
1. Download the APK file from the [latest release](https://github.com/YOURGITHUBUSERNAME/VIBEZ/releases/latest)
2. Install the APK on your Android device
3. Open the app and start playing!

### iOS
Currently in development.

### Web
Coming soon!

## How to Build from Source

1. Ensure you have Flutter installed on your machine
2. Clone this repository: `git clone https://github.com/YOURGITHUBUSERNAME/VIBEZ.git`
3. Navigate to the project directory: `cd VIBEZ`
4. Run `flutter pub get` to install dependencies
5. Connect a device or start an emulator
6. Run `flutter run` to start the app

## Technical Details

- Built with Flutter
- Uses Provider for state management
- Implements shared_preferences for local storage
- Features animations with flutter_animate
- Supports multiple platforms: Android, iOS, Web

## Project Structure

```
vibez/
├── assets/
│   ├── audio/
│   └── images/
├── lib/
│   ├── models/
│   │   ├── game.dart
│   │   ├── player.dart
│   │   └── game_difficulty.dart
│   ├── providers/
│   │   ├── game_provider.dart
│   │   └── player_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── player_setup_screen.dart
│   │   ├── game_screen.dart
│   │   ├── difficulty_selection_screen.dart
│   │   ├── would_you_rather_screen.dart
│   │   └── never_have_i_ever_screen.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── widgets/
│   │   └── game_card.dart
│   └── main.dart
└── pubspec.yaml
```

## Future Improvements

- Add more games and game types
- Implement multiplayer functionality over local network
- Add customizable game settings
- Include more animations and sound effects
- Support for different languages

## Privacy Policy

VIBEZ does not collect any personal information from users. All game data is stored locally on your device.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details
