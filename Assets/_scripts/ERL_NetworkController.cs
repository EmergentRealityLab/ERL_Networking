using UnityEngine;
using System.Collections;

public class ERL_NetworkController : MonoBehaviour {
	
	#region public vars
	public string connectionIP = "127.0.0.1";
	public int connectionPort = 25001;
	
	#endregion
	

	
	void OnGUI() {
		if (Network.peerType == NetworkPeerType.Disconnected) 
		{
			GUI.Label(new Rect(10,10,200,20), "Status: Disconnected");
			if (GUI.Button(new Rect(10,30,120,20), "Client Connect")) 
			{
				Network.Connect(connectionIP, connectionPort);
			}
			if (GUI.Button(new Rect(10,50,120,20),"Initialize Server"))
			{
				Network.InitializeServer(8,connectionPort,false);
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
			GUI.Label(new Rect(10,10,300,20), "Status: Connected as Server");
			if (GUI.Button(new Rect(10,30,120,20), "Disconnect"))
			{
				Network.Disconnect(200);
			}
		}
	}
}
