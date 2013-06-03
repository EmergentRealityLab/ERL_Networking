using UnityEngine;
using System.Collections;

public class ERL_CameraMounter : MonoBehaviour {
	
	#region public vars
	public GameObject C_Mount;
	public GameObject L_Mount;
	public GameObject R_Mount;
	#endregion
	
	#region private vars
	int selGridInt = 0;
	int old_selGridInt = 0;
	
	string[] selStrings = new string[] {"Center", "Left", "Right"};
	bool menuFoldout = false;
	
	#endregion
	
	
    void OnGUI() {
		if(Network.peerType == NetworkPeerType.Client || Network.peerType == NetworkPeerType.Server) {
			if(menuFoldout){
				GUI.Label(new Rect(Screen.width-220,10,200,20), "Camera:");
				selGridInt = GUI.SelectionGrid(new Rect(Screen.width-220, 30, 100, 80), selGridInt, selStrings, 1);
				if(selGridInt != old_selGridInt)
				{
					old_selGridInt = selGridInt;
					SetCameras();
				}
				if(GUI.Button(new Rect(Screen.width - 110,10,100,20),"Menu")) {
				menuFoldout = false;
				}
			} else {
				if(GUI.Button(new Rect(Screen.width - 110,10,100,20),"Menu")) {
				menuFoldout = true;
				}
			}
		}
		
    }
	
	void OnDisconnectedFromServer(NetworkDisconnection info) {
        if (Network.isServer)
		{
            Debug.Log("Local server connection disconnected");
		transform.parent = null;
		Network.Destroy(GameObject.FindGameObjectWithTag("Player"));
		Network.Destroy(C_Mount.transform.parent.gameObject);
		}
		
        else
            if (info == NetworkDisconnection.LostConnection){
                Debug.Log("Lost connection to the server");
				transform.parent = null;
				Network.Destroy(C_Mount.transform.parent.gameObject);
			}
            else {
                Debug.Log("Successfully diconnected from the server");
		transform.parent = null;
		Network.Destroy(C_Mount.transform.parent.gameObject);
		}
    }
	
	/// <summary>
	/// Identify the camera mountpoints and attach itself as a child of the appropriate one.
	/// </summary>
	void SetCameras () {
		
		//first we find the camera mounts
		C_Mount = GameObject.Find("CenterCamMount");
		L_Mount = GameObject.Find("LeftCamMount");
		R_Mount = GameObject.Find("RightCamMount");
		
		
		//check the current role and attach to the correct mountpoint
		
		if(selGridInt == 0){
			transform.parent = C_Mount.transform;
			transform.localPosition = new Vector3(0,0,0);
			transform.localRotation = Quaternion.identity;
		} else if(selGridInt == 1) {
			transform.parent = L_Mount.transform;
			transform.localPosition = new Vector3(0,0,0);
			transform.localRotation = Quaternion.identity;
		} else if(selGridInt == 2){
			transform.parent = R_Mount.transform;
			transform.localPosition = new Vector3(0,0,0);
			transform.localRotation = Quaternion.identity;
		}
	}
		
}
