using UnityEngine;
using System.Collections;

public class ERL_GameManager : MonoBehaviour {
	
	public GameObject player;
	public GameObject Cam;
	public Object netplayer;
	
	// Use this for initialization
	void Start () {
		
	}
	
	 void OnServerInitialized() {
		if(Network.peerType == NetworkPeerType.Server)
		{
			netplayer = Network.Instantiate(player,new Vector3(0,2,0),Quaternion.identity,1);
			//GameObject.Instantiate(player);
			Cam.SendMessage("SetCameras");
		}
		
	}

	
}
