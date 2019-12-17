# react-native-unity-demo
React Native + Unity3D Demo

Current version is iOS only.

# How to Build (iOS)
1. Run Unity3D and build project for iOS into "unity/build/ios" folder.
2. Run command "yarn install".
3. Run command "pod install" in ios folder.
4. Open ios workspace.
5. Import Unity-iPhone project into workspece.
6. Change "Unity-iPhone>Data" Target membership to "UnityFramework".
7. Change "Unity-iPhone>Libraries>Plugins>iOS>NativeCallProxy.h" Target membership to "UnityFramework (public)".
8. Import Unity-iPhone>Products>UnityFramework.framework file into Project Settings>Build Phases>Embeded Frameworks.
- Drag Unity-iPhone>Products>UnityFramework.framework to Project Settings>Frameworks, Libraries, and Embedded Content
- After remove UnityFramework.framework in Project Settings>Build Phases>Link Binary With Libraries.
9. Build project.
