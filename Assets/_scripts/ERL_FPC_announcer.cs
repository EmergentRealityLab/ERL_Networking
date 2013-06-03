/// <summary>
/// This script tells the local camera that there is a FPS object ready for it to connect to. 
/// </summary>

using UnityEngine;
using System.Collections;

public class ERL_FPC_announcer : MonoBehaviour {

	void OnNetworkInstantiate(NetworkMessageInfo info)
	{
		GameObject cam  = GameObject.Find("Camera");
		if(cam) {
			cam.SendMessage("SetCameras");
		}
	}
}
