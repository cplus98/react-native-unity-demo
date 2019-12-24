import React, { useEffect, useState } from 'react';
import { requireNativeComponent, NativeEventEmitter, NativeModules, EmitterSubscription } from 'react-native';

const { Unity3D } = NativeModules;
const unity3DEmitter = new NativeEventEmitter(Unity3D);

const Unity3DComp = requireNativeComponent('Unity3DView');

let subscription: EmitterSubscription;

export interface Unity3DListenerProps {
	listener?: (data: any) => void;
}

const Unity3DView = ({ listener }: Unity3DListenerProps) => {
	useEffect(() => {
		if (listener) {
			subscription = unity3DEmitter.addListener('onUnityMessage', listener);
		}

		// Clean up
		return () => {
			// Unsubscribe messages
			subscription.remove();
		};
	}, [listener]);

	return <Unity3DComp style={{ flex: 1, position: 'absolute', left: 0, right: 0, top: 0, bottom: 0 }} />;
};

const pauseUnity3D = Unity3D.pause;

const sendMessageToUnity3D = Unity3D.sendMessage;

export { Unity3DView, pauseUnity3D, sendMessageToUnity3D };
