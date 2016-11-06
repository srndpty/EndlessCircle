using UnityEngine;
using System.Collections;

public class SetMipLevel : MonoBehaviour {

    [SerializeField]
    int mipLevel;

    SpriteRenderer sr;

	// Use this for initialization
	void Start () {
        sr = GetComponent<SpriteRenderer>();
        sr.material = Instantiate(sr.material);
        sr.material.SetFloat("_MipLevel", mipLevel);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
