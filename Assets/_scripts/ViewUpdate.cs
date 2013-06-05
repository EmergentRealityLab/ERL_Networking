using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ViewUpdate : MonoBehaviour {
	
	public Vector3 trackerPosition = new Vector3(0f,1.5f,0f);
	public bool stereo = false;
	public float interpupillaryDistance = 0.1f;

	// Use this for initialization
	void Start () {
	    OSCHandler.Instance.Init(); //init OSC
	}
	
	// Update is called once per frame
	void Update () {
		OSCHandler.Instance.UpdateLogs();
		List<string> server_messages = OSCHandler.Instance.Servers["HeadTracker"].log;
		foreach (string msg in server_messages){

			//parse message and update tracker position
			string[] words = msg.Split(' ');
			
			//convert Vicon coordinates to Unity coordinates
			trackerPosition.x = -float.Parse(words[5]);
			trackerPosition.y = float.Parse(words[7]); 
			trackerPosition.z = -float.Parse(words[6]);
		}
	}
}
