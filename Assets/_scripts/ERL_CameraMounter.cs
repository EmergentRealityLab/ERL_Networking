using UnityEngine;
using System.Collections;

public class ERL_CameraMounter : MonoBehaviour {
	
	enum camType {
		center,
		left,
		right
	};
	
	int selGridInt = 0;
	int old_selGridInt =0;
	
	string[] selStrings = new string[] { "Left", "Right"};
	
	public GameObject C_Mount;
	public GameObject L_Mount;
	public GameObject R_Mount;
	
	//camType role = camType.center;
	

	
	
    void OnGUI() {
		if(Network.peerType == NetworkPeerType.Client)
		{
        	selGridInt = GUI.SelectionGrid(new Rect((Screen.width/2)-150, 10, 300, 20), selGridInt, selStrings, 2);
			if(selGridInt != old_selGridInt)
			{
				old_selGridInt = selGridInt;
				SetCameras();
			}
		}
		
    }
	
	void SetCameras () {
		C_Mount = GameObject.Find("CenterCamMount");
		L_Mount = GameObject.Find("LeftCamMount");
		R_Mount = GameObject.Find("RightCamMount");
		
		if(Network.peerType == NetworkPeerType.Server)
		{
			transform.parent = C_Mount.transform;
			transform.localPosition = new Vector3(0,0,0);
			transform.localRotation = Quaternion.identity;
		}
		else if(Network.peerType == NetworkPeerType.Client)
		{
			if(selGridInt == 0)
			{
				transform.parent = L_Mount.transform;
				transform.localPosition = new Vector3(0,0,0);
				transform.localRotation = Quaternion.identity;
				
			}
			else if(selGridInt == 1)
			{
				transform.parent = R_Mount.transform;
				transform.localPosition = new Vector3(0,0,0);
				transform.localRotation = Quaternion.identity;
			}
		}
	}
	
	
}
