using System.Runtime.InteropServices;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// using Newtonsoft.Json;

public class NativeAPI
{
	[DllImport("__Internal")]
	public static extern void unityMessage(string msg);
}

public class ReactDataClass
{
	public int a;
	public int b;
	public int c;
};

public class ReactEventReciver : MonoBehaviour
{
	public GameObject obj;

	void OnReactMessage(string msg)
	{
		Material mat = obj.GetComponent<Renderer>().material;
		mat.color = new Color(1.0f, 0.0f, 0.0f, 1.0f);

		var jsonObj = JsonUtility.FromJson<ReactDataClass>(msg);
		Debug.Log(jsonObj.a + ", " + jsonObj.b);
	}

	void OnGUI()
	{
		if (GUI.Button(new Rect(10, 10, 200, 100), "Send to React!"))
		{
			Material mat = obj.GetComponent<Renderer>().material;
			mat.color = Color.blue;
			NativeAPI.unityMessage("Message to React.");
		}
	}
}
