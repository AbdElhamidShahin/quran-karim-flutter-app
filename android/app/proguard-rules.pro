# Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# For Firebase (لو بتستخدمه)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Optional: لحذف unused code من okhttp أو dio
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }
