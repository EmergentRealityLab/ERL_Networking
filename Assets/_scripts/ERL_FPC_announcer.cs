using UnityEngine;
using System.Collections;

public class ERL_FPC_announcer : MonoBehaviour {

	void OnNetworkInstantiate(NetworkMessageInfo info)
	{
		GameObject.Find("Camera").SendMessage("SetCameras");
	}
}
