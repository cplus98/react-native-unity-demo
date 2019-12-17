package com.reactnativeunitydemo;

import android.content.Intent;

import com.company.product.OverrideUnityActivity;

public class MainUnityActivity extends OverrideUnityActivity {

	public static String setToColor = "default";
	@Override
	protected void showMainActivity(String aSetToColor) {
		Intent intent = new Intent(this, MainActivity.class);
		setToColor = aSetToColor;
		startActivity(intent);
	}

}
