using UnityEngine;
using System.Collections;


public class ERL_NetworkController : MonoBehaviour {
	
	#region public vars
	public string connectionIP = "127.0.0.1";
	public int connectionPort = 25001;
	
	#endregion
	void Start() {
		connectionIP = Network.player.ipAddress;
	}

	
	void OnGUI() {
		if (Network.peerType == NetworkPeerType.Disconnected) 
		{
			GUI.Label(new Rect(10,10,200,20), "Status: Disconnected");
			if (GUI.Button(new Rect(10,30,120,20),"Initialize Server"))
			{
				Network.InitializeServer(8,connectionPort,false);
			}
			GUI.Label(new Rect(150,30,200,20), "Current IP: "+Network.player.ipAddress);
			
			if (GUI.Button(new Rect(10,60,120,20), "Client Connect")) 
			{
				Network.Connect(connectionIP, connectionPort);
			}
			connectionIP = GUI.TextField(new Rect(150, 60, 200, 20), connectionIP, 15);
			if (GUI.Button(new Rect(Screen.width-110,10,100,100), "Exit")) 
			{
				Application.Quit();
			}
			
		}
		else if (Network.peerType == NetworkPeerType.Client)
		{
			GUI.Label(new Rect(10,10,300,20), "Status: Connected as Client");
			if (GUI.Button(new Rect(10,30,120,20), "Disconnect"))
			{
				Network.Disconnect(200);
			}
		}
		else if (Network.peerType == NetworkPeerType.Server)
		{
			GUI.Label(new Rect(10,10,300,20), "Status: Running as Server ( "+Network.player.ipAddress+" )");
			
			if (GUI.Button(new Rect(10,30,120,20), "Disconnect"))
			{
				Network.Disconnect(200);
			}
		}
		
		
	}
}
