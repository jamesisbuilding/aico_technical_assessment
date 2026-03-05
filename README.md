# aico_technical_assessment

You can find my implementation and .apk here:  
https://drive.google.com/drive/folders/12QcrMF-wDpXc7IC3BmF13m_jK9wD0jis?usp=sharing



# Implementation Details

### 1. Modular Architecture

The application is structured using a modular architecture, with the root `[app]` package responsible for interfacing with features through `GoRouter`.

* Each major component is separated into its own package.
* This approach removes tight coupling between features while maintaining clear boundaries and extensibility.
* New functionality can be introduced without impacting existing modules, reducing regression risk as the system grows.

### 2. Responder Feature Structure

The `[feature/responder]` package contains the full implementation of the responder feature, including its state management, UI, and domain logic.

* The feature is isolated as a self-contained package containing BLoC state management and all views, organised into `flow`, `pages`, and `widgets`.
* The `flow` layer currently acts as a placeholder. The intention is to use `FlowBuilder` for internal navigation within the feature, allowing the feature to expand internally without exposing its navigation logic outside the package boundary.

Feature layers are structured as follows:

**`/domain`**

* Defines *what the system requires from data*.
* Contains entities and contracts such as `alert_entity.dart` and `responder_repository.dart`.

**`/data`**

* Implements *how data is retrieved or stored*.
* Contains DTOs and data-layer implementations.
* `alert_model.dart` acts as a translation layer between the external data source and the internal `alert_entity.dart`.

**`/view`**

* Contains UI implementation and view-related logic.

**`/view/widgets/responder_card/`**

* Holds the primary widget composition used throughout the responder interface.

### 3. Design System

The `[core/design_system]` package centralises styling and shared UI assets.

* Includes fonts, colours, icons, and animation videos.
* `FlutterGen` is used to generate strongly-typed asset references.
* A custom `designImage` extension enables typed asset access rather than relying on hard-coded asset paths.

This ensures compile-time safety and simplifies asset management across the application.

---

# Architectural Decisions / Implementation Notes

### 1. Modularisation Strategy

Although the project could reasonably exist as a single package given its current size, it has been modularised from the outset to support future extensibility.

This allows new features, services, and dependencies to be added without restructuring the existing codebase.

### 2. Navigation Architecture

Two navigation approaches are used:

* **Declarative navigation** with `GoRouter` at the application level.
* **Imperative navigation** within features using `FlowBuilder`.

For the current scope this introduces redundancy, as the application only contains a single screen. However, it establishes a scalable structure where each feature can manage its own internal navigation while the app router handles cross-feature routing.

### 3. Local Data Source Error Handling

The local alert data source includes defensive error handling.

* `try / catch` blocks protect against malformed data or failed fetches.
* If parsing fails, an empty alert is returned to prevent runtime crashes.

In a production safety-critical system this would be insufficient. A robust implementation would require:

* structured retry logic
* client-server consistency checks
* confirmation that the client holds the latest alert state
* user-triggered retries (e.g. via a dialog when fetching fails)

### 4. Data Service Placement

The alert data source currently resides within the responder feature package.

If this service were required across multiple features, it would be moved to:

```
core/services/alert_data_service
```

This would expose the service as a shared dependency available to any feature via `pubspec.yaml`.

### 5. State Management (BLoC)

BLoC was selected for state management.

* The BLoC receives the repository as a dependency.
* Any implementation satisfying the repository contract can be injected, supporting flexibility and testability.

The current state model is intentionally minimal and could technically be handled by `Cubit`. However, as application complexity increases, BLoC provides clearer separation through explicit event dispatching.

The implementation uses:

* `BlocProvider` at the top level of the feature
* `BlocConsumer` to listen for and rebuild UI when `currentAlert` changes

### 6. Ephemeral Alert Cache

Within the BLoC an ephemeral cache stores incoming alerts that have not yet been presented to the user.

This allows alerts to be queued and displayed sequentially.

A more robust implementation would persist this cache in local storage so that alerts remain available even if the application is closed or the device temporarily loses connectivity.

### 7. Alert Action Mapping

Alert actions are explicitly mapped within the BLoC.

This allows behaviour to vary depending on alert type. Examples include:

* calling the fire brigade for fire alerts
* contacting a plumber for water leak alerts

Additional actions can be introduced by extending the BLoC logic.

If required, alerts could also trigger navigation to other parts of the application via `GoRouter`. This could be achieved by exposing a `handleAction` callback within `registrar.dart`, allowing the application layer to determine how actions are routed.

### 8. Custom Top and Bottom Bars

Custom widgets were used to implement the top and bottom bars in order to maintain strict visual consistency with the design system.

With additional time, it would be worth evaluating whether Flutter’s `AppBar` and `BottomNavigationBar` could be adapted without compromising the design requirements.

### 9. Rebuild Optimisation

`BlocBuilder` is configured to rebuild only when `currentAlert` changes.

Incoming alerts received from the stream are added to the internal queue without triggering unnecessary UI rebuilds. This reduces render overhead and improves performance.

### 10. Animations

Card transitions currently use implicit animations:

* `AnimatedOpacity`
* `AnimatedSlide`
* `AnimatedSwitcher`

A custom curve was applied to align the animations with the interaction style of the confirmation button.

If more granular or synchronised animations were required, the implementation would move to explicit animation control using:

* `AnimationController`
* `Animation`
* `SingleTickerProviderStateMixin`

This would be particularly useful for scroll-driven or multi-stage animation sequences.

### 11. Testing Strategy

Tests were initially generated with Codex and then manually verified.

The current test coverage includes:

* UI tests
* BLoC tests
• Service Tests

A production-grade test suite would target **90%+ business logic coverage**, including:

* unit tests
* widget tests
* integration tests
* golden tests

Golden and integration testing are especially important given the safety-critical nature of the alert system. Users must reliably receive and visually identify alerts on any supported device.

### 12. UI Layout Adjustment

The expanded alert card currently uses a fixed layout and scroll behaviour.

A refinement would dynamically size the expanded view based on the number of available action buttons to maintain visual balance and reduce unnecessary scrolling.

This refactor was deprioritised to focus on architecture and implementation structure.

### 13. Stream vs Future

The initial implementation used a `Future` to fetch a single alert.

This was later replaced with a `Stream` to support real-time updates, allowing alerts to be delivered automatically without manual refresh.

The UI updates only when `currentAlert` changes rather than on every incoming alert event, preventing unnecessary rebuilds while maintaining responsiveness.

---

# ⚠️ Android Video Playback Note

The confirmation animation relies on Flutter’s `video_player` package, which internally uses Media3 / ExoPlayer on Android.

During testing on the Android emulator, the software decoder (`c2.goldfish.h264.decoder`) failed to render the video correctly. The result was corrupted frames and repeated codec configuration errors.

This behaviour is a known limitation of the Android emulator’s software decoding pipeline and does not necessarily represent real device behaviour.

A physical Android device was not available for verification during development. The animation file included in the project is a standard H.264 MP4, which is widely supported by hardware decoders on Android devices and should play correctly on real phones or tablets.

If video playback issues appear in an emulator, they should therefore be considered an emulator limitation rather than a confirmed runtime defect on physical hardware.
