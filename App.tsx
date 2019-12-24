import React, { useState } from 'react';
import { View, StyleSheet, Button, StatusBar, Text } from 'react-native';

import { Unity3DView, pauseUnity3D, sendMessageToUnity3D } from './react-unity-view';

const subscription = (data: any) => {
	console.log('the event fired!~~');
	console.log(data);
};

const App = () => {
	const [paused, setPause] = useState(false);

	return (
		<>
			<StatusBar hidden />
			<Unity3DView listener={subscription}></Unity3DView>
			<View style={{ marginTop: 200 }}>
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
			</View>
		</>
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
