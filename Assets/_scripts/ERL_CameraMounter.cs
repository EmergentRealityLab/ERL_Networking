using UnityEngine;
using System.Collections;

public class ERL_CameraMounter : MonoBehaviour {
	
	enum camType {
		center,
		left,
		right
	};
	
	int selGridInt = 0;
	string[] selStrings = new string[] { "Left", "Right"};
	
	public Transform CenterCamMount;
	public Transform LeftCamMount;
	public Transform RightCamMount;
	
	//camType role = camType.center;
	
	// Use this for initialization
	void OnServerInitialized() {
	CenterCamMount = GameObject.Find("CenterCamMount").transform;
	LeftCamMount = GameObject.Find("LeftCamMount").transform;
	RightCamMount = GameObject.Find("RightCamMount").transform;
	}
	
	
    void OnGUI() {
		if(Network.peerType == NetworkPeerType.Client)
		{
        	selGridInt = GUI.SelectionGrid(new Rect((Screen.width/2)-150, 10, 300, 20), selGridInt, selStrings, 2);
		}
    }
	
	void Update () {
		if(Network.peerType == NetworkPeerType.Server)
		{
			transform.parent = CenterCamMount;
			transform.localPosition = new Vector3(0,0,0);
			transform.localRotation = Quaternion.identity;
		}
		else if(Network.peerType == NetworkPeerType.Client)
		{
			if(selGridInt == 0)
			{
				transform.parent = LeftCamMount;
				transform.localPosition = new Vector3(0,0,0);
				transform.localRotation = Quaternion.identity;
				
			}
			else if(selGridInt == 1)
			{
				transform.parent = RightCamMount;
				transform.localPosition = new Vector3(0,0,0);
				transform.localRotation = Quaternion.identity;
			}
		}
	}
	
	
}
