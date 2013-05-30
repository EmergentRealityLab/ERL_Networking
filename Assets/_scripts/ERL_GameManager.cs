using UnityEngine;
using System.Collections;

public class ERL_GameManager : MonoBehaviour {
	
	public GameObject player;
	
	// Use this for initialization
	void Start () {
		
	}
	
	 void OnServerInitialized() {
		if(Network.peerType == NetworkPeerType.Server)
		{
			GameObject.Instantiate(player);
		}
	}
}
