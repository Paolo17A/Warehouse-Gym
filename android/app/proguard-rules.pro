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

# Dio / OkHttp (release networking)
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keep class okio.** { *; }

# flutter_secure_storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }
