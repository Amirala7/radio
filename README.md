# Radio

A Flutter radio app consuming the RapidAPI Radio Stations API. Anonymous Firebase auth, Cloud-Functions-proxied station feeds, denormalised Firestore favorites, background playback with lock-screen controls.

The full architectural rules and design language live in [CLAUDE.md](CLAUDE.md). This README is just enough to get the project running locally.

---

## Stack

**Client (`client-app/`)**
- Flutter / Dart `^3.11.5`
- State: `provider` + `ChangeNotifier` ViewModels
- DI: `get_it`
- Models: `freezed` + `json_serializable`
- Audio: `just_audio` + `just_audio_background` (station) and `audioplayers` (SFX) — see CLAUDE.md for why two engines
- Firebase: `firebase_core`, `firebase_auth`, `cloud_functions`, `cloud_firestore`
- Connectivity: `connectivity_plus`

**Backend (`backend-service/`)**
- Firebase Functions (TypeScript), Firestore, Anonymous Auth
- Node `20`
- Region: `europe-west1`

**Platform minimums**
- iOS `15.0`+
- Android `minSdk` resolved from the Flutter SDK (currently 21+)

---

## Repo layout

```
radio/
  client-app/          # Flutter app
  backend-service/     # Firebase project (Functions + Firestore + rules)
  docs/superpowers/    # Design specs / ADRs
  CLAUDE.md            # Architecture, conventions, design language
  README.md            # This file
```

Inside `client-app/lib/` the structure is feature-based (`features/{stations, genres, favorites, player, home}`) with shared infrastructure under `core/`. See CLAUDE.md for the full layer rules.

---

## Prerequisites

| Tool | Version | Notes |
|---|---|---|
| Flutter SDK | `^3.11.5` | `flutter doctor` should be clean |
| Xcode | latest stable | iOS builds, simulator |
| CocoaPods | `1.14+` | Installed via `sudo gem install cocoapods` |
| Android Studio | Hedgehog+ | Android builds, SDK manager |
| Node.js | `20.x` | Backend |
| Firebase CLI | `13+` | `npm install -g firebase-tools` |
| FlutterFire CLI | latest | `dart pub global activate flutterfire_cli` |

---

## First-time setup

### 1. Clone and install client dependencies

```bash
git clone <repo-url> radio
cd radio/client-app
flutter pub get
```

For iOS:

```bash
cd ios && pod install && cd ..
```

### 2. Wire up Firebase (client)

The app expects `client-app/lib/firebase_options.dart` to exist. If you're starting from a fresh Firebase project:

```bash
firebase login
cd client-app
flutterfire configure --project <your-firebase-project-id>
```

This generates `firebase_options.dart` and the platform config files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS).

Make sure **Anonymous sign-in** is enabled in the Firebase Console (Authentication → Sign-in method).

### 3. Install backend dependencies

```bash
cd backend-service/functions
npm install
```

### 4. Set the RapidAPI secret

The backend proxies all RapidAPI calls so the key never ships to the client.

1. Subscribe to [50K Radio Stations](https://rapidapi.com/50k-radio-stations/api/50k-radio-stations) on RapidAPI and grab the key.
2. Set it as a Firebase Functions secret:

   ```bash
   firebase functions:secrets:set RAPIDAPI_KEY
   ```

   Paste the key when prompted.

### 5. Deploy Firestore rules + indexes (first time only)

```bash
cd backend-service
firebase deploy --only firestore:rules,firestore:indexes
```

---

## Running locally

### Backend (Functions emulator)

The cleanest way to develop is to run Functions + Firestore + Auth in the local emulator:

```bash
cd backend-service/functions
npm run serve
```

That builds the TS, then starts the emulators on `localhost`.

To point the client at the emulator, add this to `client-app/lib/main.dart` (already wired but commented out — uncomment for local development):

```dart
// FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
// FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
// FirebaseFunctions.instanceFor(region: 'europe-west1')
//     .useFunctionsEmulator('localhost', 5001);
```

### Client

```bash
cd client-app
flutter run
```

Pick a device with `flutter devices` first (or use `-d <device-id>`).

For background-audio testing on iOS you need a **physical device** — the simulator doesn't suspend the app the way real iOS does.

---

## Testing

### Client

```bash
cd client-app
flutter analyze              # static analysis, must be clean
flutter test                 # all unit + widget tests
```

Unit tests are required for **ViewModels, UseCases, Repositories**. Tests live under `test/` mirroring `lib/`.

### Backend

```bash
cd backend-service/functions
npx tsc --noEmit             # type-check
npm test                     # vitest
```

---

## Deploying

### Backend

```bash
cd backend-service
firebase deploy --only functions
```

The first deploy will prompt to create the `RAPIDAPI_KEY` secret if you haven't already.

### Client

Standard Flutter release builds:

```bash
cd client-app
flutter build apk --release          # Android
flutter build ipa --release          # iOS (requires signing setup)
```

Make sure `firebase_options.dart` and the platform config files are present; they're checked in but won't auto-update if you change Firebase project.

---

## Project conventions (one-screen summary)

- **Architecture:** CLEAN with strict layering (`View → ViewModel → UseCase → Repository → DataSource`). Dependencies point inward only — see [CLAUDE.md](CLAUDE.md).
- **State:** ViewModels are `ChangeNotifier`, expose immutable Freezed state, mutate via intent methods.
- **DI:** Wired in `core/di/dependencies.dart`, exposed to widgets via `MultiProvider` in `main.dart`.
- **Models:** Every model is Freezed. DTOs in `data/`, entities in `domain/`. Mapping is one-way through extension-method mappers.
- **Errors:** Sealed `AppFailure` hierarchy. Data sources catch and wrap; everything above just switches on the variant.
- **Design system:** Tokens in `core/theme/`. One accent colour. No inline color literals in widgets.

For everything else — feature contracts, audio architecture, design language, hard-no list — read [CLAUDE.md](CLAUDE.md).
