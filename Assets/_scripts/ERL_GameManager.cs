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
	/*
	void OnDisconnectedFromServer(NetworkDisconnection info) {
        if (Network.isServer){
            	Debug.Log("Local server connection disconnected");
		//Network.RemoveRPCs(GameObject.FindGameObjectWithTag("Player"));
        	Network.Destroy(GameObject.FindGameObjectWithTag("Player"));
		}
        else
            if (info == NetworkDisconnection.LostConnection) {
                Debug.Log("Lost connection to the server");
		//Network.RemoveRPCs(GameObject.FindGameObjectWithTag("Player"));
        	Network.Destroy(GameObject.FindGameObjectWithTag("Player"));
		}
            else {
                Debug.Log("Successfully diconnected from the server");
		//Network.RemoveRPCs(GameObject.FindGameObjectWithTag("Player"));
        	Network.Destroy(GameObject.FindGameObjectWithTag("Player"));
		}
    }
	
	 */
	
	
}
