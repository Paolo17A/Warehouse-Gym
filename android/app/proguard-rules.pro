# R8 full mode strips reflection-used constructors for WorkManager / Room.
# Pulled in transitively (e.g. ML Kit). Without these, release installs crash
# at process start inside androidx.startup.InitializationProvider.

-keep class androidx.startup.** { *; }
-keep class * implements androidx.startup.Initializer { *; }

-keep class androidx.work.** { *; }
-keep class androidx.work.** { <init>(...); }
-keep interface androidx.work.** { *; }

-keep class * extends androidx.room.RoomDatabase { *; }
-keep class * extends androidx.room.RoomDatabase { <init>(...); }
-keep class androidx.room.** { *; }
-dontwarn androidx.room.paging.**
