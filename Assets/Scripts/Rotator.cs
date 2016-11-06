using UnityEngine;
using System.Collections;

public class Rotator : MonoBehaviour {

    [SerializeField]
    private float amount = 10;

    // Use this for initialization
    void Start () {
        amount = Random.value * amount;
    }
    
    // Update is called once per frame
    void Update () {
        transform.rotation = Quaternion.AngleAxis(amount * Time.time, Vector3.forward);
    }
}
