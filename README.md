# react-native-unity-demo
React Native + Unity3D Demo.
Supports iOS and Android both.

Requirements:
Android Studio 3.4.2+
Unity version 2019.3.0b4+

# How to Build (iOS)
1. Run Unity3D and build project for iOS into "unity/build/ios" folder.
2. Run command "yarn install".
3. Run command "pod install" in ios folder.
4. Open ios workspace.
5. Import Unity-iPhone project into workspece.
6. Change "Unity-iPhone>Data" Target membership to "UnityFramework".
<img width="500" src="https://user-images.githubusercontent.com/40209639/85844610-f5efa480-b7dd-11ea-9860-e9f339e76665.png">
7. Change "Unity-iPhone>Libraries>Plugins>iOS>NativeCallProxy.h" Target membership to "UnityFramework (public)".
<img width="500" src="https://user-images.githubusercontent.com/40209639/85844607-f5570e00-b7dd-11ea-8237-34c117e1b608.png">
8. Import Unity-iPhone>Products>UnityFramework.framework file into Project Settings>Build Phases>Embeded Frameworks.
- Drag Unity-iPhone>Products>UnityFramework.framework to Project Settings>Frameworks, Libraries, and Embedded Content
<img width="500" src="https://user-images.githubusercontent.com/40209639/85844606-f425e100-b7dd-11ea-9450-e13ca96abf70.png">
- After remove UnityFramework.framework in Project Settings>Build Phases>Link Binary With Libraries.
<img width="500" src="https://user-images.githubusercontent.com/40209639/85844590-eff9c380-b7dd-11ea-93ce-73d89a4fd9a2.png">
9. Build project.

# How to Build (Android)
1. Run Unity3D and build (* with Export Project option) project for Android into "unity/build/android" folder.
2. Run command "yarn install".
3. Open Android Studio and import the unity3D project into Android Studio.
4. Append the following lines to ```android/settings.gradle```:
```
...
include ':unityLibrary'
project(':unityLibrary').projectDir=new File('..\\unity\\build\\android\\unityLibrary')
```
4. Insert the following lines inside the dependencies block in ```android/app/build.gradle```:
```
  implementation project(':unityLibrary')
  implementation files("${project(':unityLibrary').projectDir}/libs/unity-classes.jar")
```


