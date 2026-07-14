# The Warehouse Gym (Flutter)

Mobile client for **The Warehouse Gym** — a multi-role fitness app for clients, trainers, and admins. Clients follow assigned workouts with camera-based pose estimation, track BMI, message their trainer, and manage profiles. Trainers prescribe workouts and manage clients. Admins manage trainers and clients.

The app talks to the [warehouse-gym-backend](../Fitnessco-Backend) REST + Socket.IO API.

## Architecture

Clean architecture by feature:

- **Presentation** — pages, widgets, Riverpod viewmodels  
- **Domain** — entities, repository contracts, use cases  
- **Data** — API services, models, repository implementations  

Shared auth/session, networking, routing, and UI live under `lib/core`.

## File structure

```
warehouse_gym/
├── android/                 # Android host + ProGuard rules for ML Kit release builds
├── ios/                     # iOS host
├── assets/
│   ├── app.env              # Bundled API config (preferred in release)
│   ├── audio/               # Workout sound effects
│   └── images/
│       ├── backgrounds/
│       ├── gifs/            # Exercise demos
│       ├── icons/
│       └── warmups/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── config/          # AppConfig (API / Socket URLs)
│   │   ├── constants/       # Colors, options
│   │   ├── di/              # GetIt modules
│   │   ├── errors/          # Failure types
│   │   ├── network/         # Dio ApiClient, secure storage, connectivity
│   │   ├── providers/       # Session, camera, network providers
│   │   ├── router/          # go_router
│   │   ├── seeds/           # muscles.json
│   │   ├── session/         # Session restore / logout
│   │   ├── theme/
│   │   ├── utils/
│   │   └── widgets/         # Shared backgrounds, auth UI, loading
│   └── features/
│       ├── admin/           # Admin home, trainers, clients
│       ├── client/
│       │   ├── account/     # Profile, complete profile, trainer profile
│       │   ├── bmi/         # BMI history
│       │   ├── home/
│       │   ├── messaging/   # Chat (Socket.IO)
│       │   ├── users/       # Browse trainers
│       │   └── workout/     # Plans, warm-up, start, camera pose workout, history
│       ├── shared/
│       │   ├── account/
│       │   ├── auth/        # Welcome, sign-in, sign-up, forgot password
│       │   └── users/
│       └── trainer/
│           ├── account/
│           ├── home/
│           ├── users/       # Clients, schedule, requests
│           └── workout/     # Prescribe workout
├── pubspec.yaml
├── .env                     # Local/debug env (also listed as asset)
└── README.md
```

## Libraries used

### Runtime

| Package | Purpose |
|---------|---------|
| `hooks_riverpod` / `flutter_hooks` | State management |
| `get_it` | Dependency injection |
| `go_router` | Navigation & auth redirects |
| `dartz` | `Either` for use-case results |
| `dio` | HTTP API client |
| `flutter_dotenv` | Environment config |
| `flutter_secure_storage` | JWT / credentials |
| `socket_io_client` | Real-time chat |
| `connectivity_plus` | Network checks |
| `freezed_annotation` / `json_annotation` | Immutable state & serialization |
| `google_mlkit_pose_detection` / `google_mlkit_commons` | On-device pose estimation |
| `camera` | Live camera preview / frames |
| `permission_handler` | Camera permissions |
| `toastification` | Toasts |
| `google_fonts` | Typography |
| `dropdown_search` | Searchable dropdowns |
| `flutter_calendar_carousel` | Calendar UI |
| `carousel_slider` | Exercise carousels |
| `intl` | Dates / formatting |
| `flutter_tts` | Warm-up speech |
| `audioplayers` | Workout audio cues |
| `image_picker` | Profile photos |
| `path_provider` | File paths |
| `gap` | Spacing helpers |
| `cupertino_icons` | Icons |

### Dev

| Package | Purpose |
|---------|---------|
| `flutter_lints` | Linting |
| `freezed` / `json_serializable` / `build_runner` | Code generation |
| `flutter_launcher_icons` | App icon |

## Getting started

1. Ensure the backend is running (or use the hosted Render URL).
2. Copy/update `.env` and `assets/app.env`:

```env
API_BASE_URL=https://your-backend-host
SOCKET_URL=https://your-backend-host
SOCKET_PATH=/socket.io
```

3. Install and run:

```bash
flutter pub get
flutter run
```

Release Android builds use R8; `android/app/proguard-rules.pro` keeps ML Kit / Play Core stubs so pose overlays work in release.
