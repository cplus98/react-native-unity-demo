import React, { useEffect, useState } from 'react';
import { NativeEventEmitter, NativeModules, EmitterSubscription } from 'react-native';

const { Unity3D } = NativeModules;
const unity3DEmitter = new NativeEventEmitter(Unity3D);

let subscription: EmitterSubscription;

export interface Unity3DListenerProps {
	listener?: (data: any) => void;
	children?: React.ReactNode;
}

const Unity3DProvider = ({ listener, children }: Unity3DListenerProps) => {
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

	return <>{children}</>;
};

const pauseUnity3D = Unity3D.pause;

const sendMessageToUnity3D = Unity3D.sendMessage;

export { Unity3DProvider, pauseUnity3D, sendMessageToUnity3D };
