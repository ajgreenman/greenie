I want to build a mobile application for my summer golf league so we can track and compare our scores, as well as administrate the league.

The app should be built using Flutter and have the following features:

## League Home

The app should have a league home screen:

- Members should be able to see basic information about their league
- When there is an upcoming round scheduled, members should be able to see that and tap in to start a round
- Members should be able to access more detailed information if they need (list of members, schedule, etc.)
- League admins should be able to access the administrative portal from here

## Scorecard

The app should have a scorecard feature where you can input your round as you play:

- The scorecard should contain basic course information for that week of play (holes, pars, etc.)
- The scorecard should provide standard golf indicators for birdies, bogeys, etc.
- We want to also show skins and handicaps in a nice and simple way
- Scorecards should be tied to rounds

## Round

A round is a single week of golf league, typically a 9 hole round of golf:

- Members should be able to see past rounds as well as upcoming
- Members should be able to start a round and start filling it out with the scorecard
- Members should be able to see how others are doing
- Admin should be able to manipulate rounds if needed
- A public history of changes should be available to the owner of each round, as well as admins
- The history should have a verbose setting that is opt-in

## Functional requirements

At all times, we should use Flutter and Dart best practices to build our app.

### Dependency injection and state management

- The app uses Riverpod for state management as well as to inject dependencies
- We should always use the latest Riverpod versions as well as latest best practices

### Routing

- GoRouter is our navigator of choice
- We should always use the latest GoRouter version as well as latest best practices

### Theming

- The app should have both light and dark mode
- Theming should be done by setting the `theme` in `MaterialApp`, rather than hardcoding colors and sizes in the widgets themselves

### Code Style

- Always follow Dart best practices
- Prefer small composable widgets over large ones
- Ensure proper separation of concerns by using a suitable folder structure (eventually, we will want to use a modularized Dart workspace structure)
- Shared widgets should be broken out into their own files
- Prefer using flex values over hardcoded sizes when creating widgets inside rows/columns, ensuring the UI adapts to various screen sizes
- Use `log` from `dart:developer` rather than `print` or `debugPrint` for logging

### Tests

- We should write unit and widget tests for all production code
- A high code coverage threshold of 95% should be adhered to

### Linting

- We should have strong linting rules to prevent sloppy code
- We should always format and analyze our code to ensure we're adhering to guidelines