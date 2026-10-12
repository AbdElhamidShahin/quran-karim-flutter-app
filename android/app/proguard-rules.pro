# ===== Flutter =====
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# ===== OkHttp / Dio =====
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# ===== Gson / JSON =====
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }

# ===== Geolocator =====
-keep class com.baseflow.geolocator.** { *; }

# ===== flutter_local_notifications =====
-keep class com.dexterous.** { *; }

# ===== workmanager =====
-keep class be.tramckrijte.workmanager.** { *; }

# ===== android_alarm_manager_plus =====
-keep class dev.fluttercommunity.plus.androidalarmmanager.** { *; }

# ===== permission_handler =====
-keep class com.baseflow.permissionhandler.** { *; }

# ===== flutter_background_service =====
-keep class id.flutter.flutter_background_service.** { *; }

# ===== share_plus =====
-keep class dev.fluttercommunity.plus.share.** { *; }

# ===== Kotlin Coroutines =====
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-dontwarn kotlinx.coroutines.**
