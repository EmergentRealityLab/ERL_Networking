using UnityEngine;
using System.Collections;

public class ClickGrow : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	void OnClick () {
		transform.localScale= new Vector3(1.25f,1.25f,1.25f);	
	}
	
	void OnRelease () {
			transform.localScale= new Vector3(1.0f,1.0f,1.0f);
	
	}
}
