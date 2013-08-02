using UnityEngine;
using System.Collections;

public class ClickOnThings : MonoBehaviour {
	private GameObject selected=null;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown(0)) 
		{
			Ray ray = Camera.main.ScreenPointToRay (Input.mousePosition);
			RaycastHit hit;
			if (Physics.Raycast(ray, out hit, 100.0f))
			{
				if (hit.collider != null)
				{
					Debug.Log(hit.collider);
					selected = hit.collider.gameObject;
					hit.collider.gameObject.BroadcastMessage ("OnClick", SendMessageOptions.DontRequireReceiver);	
				}
			}
		}
		
		if (Input.GetMouseButtonUp(0))
		{
			if (selected != null)
			{
				selected.BroadcastMessage("OnRelease",SendMessageOptions.DontRequireReceiver);
				selected=null;
			}
		}
		
		
	}
}