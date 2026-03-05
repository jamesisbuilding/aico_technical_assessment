# aico_technical_assessment

# Implementation Details

1. Modular architecture decomposed into [app] for interfacing with features via [GoRouter],
    - Each component is decomposed into its own package.
    - We remove tight coupling and keep ease of extension without breaking other parts of the app.

2. [feature/responder] holds our responder feature, widgets and logic.
    - Isolated feature package, containing our BLoC state management and all views (decomposed into flow / pages / widgets).
    - Flow is still a place holder here; using flowbuilder within features allows ease of growing the feature internally, without exposing that logic outside of package bounds.
    - [/domain] holds all of our 'what we want' from data. This includes [alert_entity.dart] and [responder_repository.dart].
    - [/data] holds all of our 'how we get data' implementations. [alert_model.dart] is our DTO between data source and internal [alert_entity.dart].
    - [/view] holds UI implementation and associated logic.
    - [/view/widgets/responder_card/] is still the bulk of the implementation, holding the main widget composition.

3. [core/design_system] contains all of our styling, fonts, icons and videos.
    - Here I have used [FlutterGen] with custom [designImage] extension to use typed asset paths rather than hard-coded strings.


# Architectural Decisions

1. Modular architecture
   - I could have put the project in a single package given the size.
   - However to keep extensibility high, I broke it down into individual packages so new features, dependencies and services can be added with less friction.

2. Navigation split
   - Imperitive internal feature navigation using [FlowBuilder], isolated to feature scope.
   - Declarative app-level navigation using [GoRouter].
   - This is slightly redundant right now given app size, but gives a cleaner path for adding more features/routes.

3. DI and wiring updates
   - Responder dependencies are now wired through `registerResponderAlertDependencies(getIt)` in app service locator.
   - Repository is constructor injected (`ResponderRepoImpl(getIt<AlertDataService>())`) rather than custom singleton lifecycle.
   - This made testing and dependency substitution cleaner.

4. Domain / presentation split
   - `AlertStatus` in domain is now a pure enum (no UI color/theme concerns).
   - UI-only mappings are now in view extension (`alert_status_ui.dart`) for color + confirmation labels.
   - This keeps domain more portable and less coupled to flutter / design-system concerns.

5. BLoC
   - BLoC still handles our core orchestration for current alert and pending queue.
   - We now also expose stream failure state through explicit `streamError` in state, rather than yielding synthetic “error alerts” as business data.

6. Local data source behavior
   - Local source emits deterministic first alert, then generated fire/water alerts.
   - `updateAlert` is intentionally no-op in this local impl (stubbed local datasource).

7. UI rebuild + animation behavior
   - We now use `BlocConsumer` (instead of `BlocBuilder` only) in responder card, so scheduling side effects (expand animation timing) live in listener rather than in build.
   - This avoids build-triggered side effects and keeps build focused on rendering.

8. Animations
   - Current implementation uses `AnimatedOpacity`, `AnimatedSlide`, `AnimatedSwitcher` as animation needs are fairly simple.
   - If we need more granular coupled animations later, we can shift to explicit controllers/mixins.
