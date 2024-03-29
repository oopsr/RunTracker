# RunTracker
Track your progress while running or walking in a simple way. Open the app and hit start to:
- Track your location and route in realtime on a map
- Accurately calculate calories using your latest weight entry from the Health app
- See details about distance, time, calories burned and current pace

Once you're finished your workout is automatically saved inside the Health app to access it even from other places. You can also see details of all your past workouts recorded inside the app and have a global statistics of total distance ran or walked and calories burned.

*Coming Soon on the AppStore*

## Project Setup
The framework `MBLibrary` referenced by this project is available [here](https://github.com/piscoTech/MBLibrary), version currently in use is [1.2.2](https://github.com/piscoTech/MBLibrary/releases/tag/v1.2.2(9)).

## Customization
General behaviour of the app can be configured via properties of `HealthKitManager` class:

* `authRequired`, `healthReadData` and `healthWriteData`: Used to save the latest authorization requested in `UserDefaults`, when `authRequired` is greater than the saved value the user will be promped for authorization upon next launch, increment this value when adding new data to be read or write to `healthReadData` or `healthWriteData`.

The algorithm that takes care of tracking workout route, distance, calories burned and pace can be tweaked via the properties `dropThreshold`, `moveCloserThreshold`, `thresholdSpeed`, `accuracyInfluence`, `routeTimeAccuracy`, `detailsTimePrecision` and `paceTimePrecision` of `RunBuilder` class. For additional details refer to in-code documentation.
![alt text](https://github.com/oopsr/RunTracker/blob/master/Image%20Files/Screenshots/en/1.png)


