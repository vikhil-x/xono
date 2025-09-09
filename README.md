# Xono ♪

Xono is a sleek, modern music streaming application built with Flutter. It leverages YouTube Music to provide a seamless listening experience, complete with synchronized lyrics and dynamic queueing.

## Disclaimer ⚠︎
This project is created strictly for _**educational purposes only**_.  
I do not intend to monetize, distribute, or misuse copyrighted services (such as the YouTube Music API or any other third-party APIs).  
All development within this repository abides by copyright laws, and the app should not be considered a commercial product.  

## Features ✧˖°

- **Music on Demand:** Search and stream any song from the YouTube Music library.
- **Synced Lyrics:** View real-time, synchronized lyrics for the currently playing track.
- **Dynamic Queue:** Automatically generates a playlist of related songs based on the current artist or album.
- **Intuitive Player:** A clean music player with standard controls (play, pause, next, previous), a progress slider, and song details.
- **Modern UI:** A user-friendly interface featuring shimmer effects for loading states and a music visualizer for the active track.
- **Theme Support:** Toggle between light and dark modes for a personalized experience.

## Core Technologies ⚙︎

- **Framework:** Flutter
- **State Management:** `flutter_riverpod`
- **Audio Backend:** 
    - `just_audio` & `audio_service` for robust audio playback.
    - `youtube_explode_dart` & `dart_ytmusic_api` for sourcing audio streams and metadata from YouTube.
- **Lyrics:** Fetches synchronized lyrics from the `lrclib.net` API.
- **UI Components:** Utilizes `shimmer`, `blur`, and `glassmorphism` for a modern and polished user interface.

## Getting Started ✰

To run this project locally, follow these steps:

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/vikhil-x/xono.git
    cd xono
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Run the application:**
    ```sh
    flutter run
    ```

## Project Structure ⎙

The project is organized to separate business logic from the UI, making it easier to navigate and maintain.

-   `lib/main.dart`: The application's entry point, containing theme configuration and the root widget.
-   `lib/providers.dart`: Centralizes all `Riverpod` providers for efficient state management across the app.
-   `lib/tools/`: Contains the core application logic.
    -   `yt_scrape.dart`: A scraper class that interacts with YouTube Music APIs to search for songs and retrieve stream data.
    -   `player_control.dart`: Manages audio playback states (play, pause, next, etc.) and playlist queueing.
    -   `lyric_manager.dart`: Handles fetching and parsing of synchronized song lyrics.
-   `lib/ui/`: Contains all UI components, screens, and widgets.
    -   `search_page.dart`: The main screen for searching for music.
    -   `music_player.dart`: The primary music player interface.
    -   `lyric_widget.dart`: The component responsible for displaying synced lyrics.
    -   `queued_songs_page.dart`: Displays the current song queue.
