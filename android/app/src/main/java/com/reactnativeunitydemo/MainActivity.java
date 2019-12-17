package com.reactnativeunitydemo;

import android.content.Intent;
import android.os.Bundle;

import com.facebook.react.ReactActivity;

public class MainActivity extends ReactActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    Intent intent = new Intent(this, MainUnityActivity.class);
    startActivity(intent);
  }

  /**
   * Returns the name of the main component registered from JavaScript. This is used to schedule
   * rendering of the component.
   */
  @Override
  protected String getMainComponentName() {
    return "ReactNativeUnityDemo";
  }
}

//package com.reactnativeunitydemo;
//
//import android.content.Intent;
//import android.graphics.Color;
//import android.os.Bundle;
//import androidx.appcompat.app.AppCompatActivity;
//import android.view.View;
//import android.widget.Toast;
//
//public class MainActivity extends AppCompatActivity {
//
//  @Override
//  protected void onCreate(Bundle savedInstanceState) {
//    super.onCreate(savedInstanceState);
//
//    onUnityLoad(null);
//  }
//
//  public void onUnityLoad(View v) {
//    Intent intent = new Intent(this, MainUnityActivity.class);
//    startActivity(intent);
//  }
//
//  public void onUnityUnload(View v) {
//    if(MainUnityActivity.instance != null)
//      MainUnityActivity.instance.finish();
//    else showToast("Show Unity First");
//  }
//
//  public void showToast(String message) {
//    CharSequence text = message;
//    int duration = Toast.LENGTH_SHORT;
//    Toast toast = Toast.makeText(getApplicationContext(), text, duration);
//    toast.show();
//  }
//}
