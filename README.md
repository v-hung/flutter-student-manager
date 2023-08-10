# flutter_student_manager

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

keytool -genkey -v -keystore ./android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# build android
- flutter build appbundle

# build ios
- flutter clean
- delet Podfile, Podfile.lock
- flutter pub get
- cd ios  -> pod install
+ comment RunnerTests if three is an error
    # target 'RunnerTests' do
    #   inherit! :search_paths
    # end
- flutter build ios --no-tree-shake-icons
- Open xcode, product -> archive (Open list archive: Window -> Organizer)