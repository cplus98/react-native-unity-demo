import React, { useState } from 'react';
import { SafeAreaView, StyleSheet, Button, StatusBar, NativeEventEmitter, NativeModules } from 'react-native';

import { Unity3DProvider, pauseUnity3D, sendMessageToUnity3D } from './react-unity-view';

const subscription = (data: any) => {
	console.log('the event fired!~~');
	console.log(data);
};

const App = () => {
	const [paused, setPause] = useState(false);

	return (
		<Unity3DProvider listener={subscription}>
			<StatusBar hidden />
			<SafeAreaView style={styles.container}>
				<Button
					title="Send Message To Unity3D"
					onPress={() => {
						const testData = {
							a: '1',
							b: '2',
							c: '3',
						};
						sendMessageToUnity3D(JSON.stringify(testData));
					}}
				/>
				<Button
					title={paused ? 'RESUME Unity' : 'PAUSE Unity'}
					onPress={() => {
						setPause(!paused);
						pauseUnity3D(!paused);
					}}
				/>
			</SafeAreaView>
		</Unity3DProvider>
	);
};

const styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
		backgroundColor: 'transparent',
	},
});

export default App;
