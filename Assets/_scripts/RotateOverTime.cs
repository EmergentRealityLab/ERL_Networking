using UnityEngine;
using System.Collections;

public class RotateOverTime : MonoBehaviour {
	
	public float speed = 10.0f;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		transform.Rotate(Time.deltaTime * speed, Time.deltaTime * speed, Time.deltaTime * speed);
	}
}
