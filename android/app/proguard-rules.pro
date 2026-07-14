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

# Google ML Kit pose detection (release builds otherwise return empty poses)
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_** { *; }
-keep class com.google.android.gms.internal.mlkitvision** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_** { *; }
-keepclassmembers class * {
    @com.google.android.gms.common.annotation.KeepName *;
}
-keepclasseswithmembernames class * {
    native <methods>;
}
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**

# Flutter / plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google_mlkit_** { *; }

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

# Flutter deferred components / Play Core (optional APIs not used by this app)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
