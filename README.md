# aico_technical_assessment

You can find my implementation and .apk here:  
https://drive.google.com/drive/folders/12QcrMF-wDpXc7IC3BmF13m_jK9wD0jis?usp=sharing



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


#  Architectural Decisions / Implementation Notes
1. Modular architecture - I could have put the project in a single package given its size. However to ensure ease of extensibility I have broken it down into individual packages so new features, dependencies and services can be added.

2. I have used imperitive navigation for internal feature navigation using ``FlowBuilder``, isolated to each (just one at the moment) feature. I have used declarative navigation using ``GoRouter``. This is redundant right now due to the size of the app and being single-screen but allows ease of additional feature integration when / if needed. 

3. In our local data source I have added try / catches and throws an empty alert if the data is malformed or we are unable to fetch our alert. I understand in real-world deployment this is a safety-critical system and this would not suffice. We would need to retry fetching and have client-server communication to ensure client's data is fully updated with the most recent data in the database, having immediate consistency of data and implementing structured retry logic with manual (user triggered via a dialog saying fetching failed) retry coupled with internal retry logic. 

4. Right now I have the alert data source in the feature package. Should this service be required app wide, I would restructure and put it in ``core/services/alert_data_service`` - thus exposing it to any feature that requires it via import in ``pubspec.yaml``. 

5. BLoC - I have chosen BLoC to handle our state, which takes in our data service repo as an argument, which can be swapped for any implementation satisying our abtract declaration. The key here is I have a thin state, which could be replaced with cubit. But as the app grows, BLoC handles this in a cleaner fashion with event dipatches. 

6. In BLoC I have also added an ephermeral cached which stores our incoming / unseen alerts, and shows them to the user accordingly. To make this more robust, I would have this actually saved in local storage, such that if the user closes the app and loses signal the user still has access to them and can act accordingly. 

7. I have added clear implementation of which actions are available to each alert and map them within BLoC. As such we can tailor which actions the user can take based on alert type:  ie Call the fire brigade or call a plumber for fire or leak alerts respectively. This means we can add actions where needed and route them accordingly but extending our BLoC logic. Should we want, we could add a path to each alert, taking them to the appropriate screen via our GoRouter to handle the next action outside of our direct responder feature. Here I would expose an ``handleAction`` callback in our ``registrar.dart`` and pass it to our BLoC and expose it at the app level so we can call the appropriate route. 

8. Top Bar / Bottom Bar : here I have used custom widgets to ensure visual continuity. Given more time I would explore using Flutter's AppBar and BottomBar accordingly. 

9. More smaller details - I have used BlocBuilder that only builds when our currentAlert changes. Thus reducing rebuilds when we recieve data va our stream and add alerts to our queue. 

10. Animations - Here I have used ``AnimatedOpacity``, ``AnimatedSlide`` and ``AnimatedSwitcher`` for our card animations with a custom curve to match our vibe of the confirmation button. However should we want more granular and custom animations I would of course use ``AnimationController``, ``Animation`` and ``SingleTickerProviderMixin`` should we have animations that are nuanced and coupled (such as scrolling on a screen and causing the animation to progess based on our scroll %)

11. Testing - I have used Codex to write our tests and I have verified them manually. Right now only testing our UI and BLoC. However for a full testing suite I would aim for 90%+ business logic coverage with widget, unit, integration tests and golden tests for our UI on various screens. Integration and Golden Tests are especially important here due to the safety-critical nature of the alerts, we must ensure users always get the alerts in a timely manner and they can actually see the alerts on any device they have can access the app on - especially the card UI must remain clearly visible if we plan on extending or modifying our features. 

12. UI Tweaks - right now the expanded card view is single size and is scrollable - however I would ensure that the expanded version always fits the amount of action buttons that are available to ensure visual consistency. As code architecture and implementation details are the priority here I have omitted this refactor. 

13. Stream v Future - initially I used a Future to fetch a single alert, however it made more sense to use a stream, as I'd anticipate the user wanting to receive updates automatically instead of having to manually refresh. Note our UI only updates when the current alert is updated, not whenever we receive an alert, thus minimising rebuilds and ensuring performance. 

---

## ⚠️ Android Video Playback Note

The confirmation animation in this app relies on the Flutter `video_player` package, which in turn uses Media3 / ExoPlayer under the hood.

For testing, I used the standard Android emulator. Please note that the emulator’s software decoder (`c2.goldfish.h264.decoder`) failed to render video playback correctly—showing corrupted frames and frequent codec/configuration errors. This is a known limitation with the Android emulator’s media stack and does **not** necessarily reflect how things work on real Android devices.

Unfortunately, at this time I do not have access to a physical Android device for direct verification. The animation video included is a standard H.264 MP4, which is well-supported by hardware media decoders on real devices, so it should play smoothly on actual Android phones/tablets. However, please keep in mind this caveat if you encounter playback issues in emulators.

---
