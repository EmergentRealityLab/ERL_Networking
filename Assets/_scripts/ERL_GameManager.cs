using UnityEngine;
using System.Collections;

public class ERL_GameManager : MonoBehaviour {
	
	#region public vars
	public GameObject player;
	public GameObject Cam;
	#endregion
	
	#region private vars
	//private Object netplayer;
	
	#endregion
	
	
	 void OnServerInitialized() {
		if(Network.peerType == NetworkPeerType.Server)
		{
			//netplayer = 
				Network.Instantiate(player,new Vector3(0,2,0),Quaternion.identity,1);
			//GameObject.Instantiate(player);
			Cam.SendMessage("SetCameras");
		}
		
	}
	void OnDisconnectedFromServer(NetworkDisconnection info) {
		//I don't know if this is strictly necessary but it seems like a good thing to do.
		//netplayer = null;
	}

	
	
}
