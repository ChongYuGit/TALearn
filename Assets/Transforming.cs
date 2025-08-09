using System;
using UnityEngine;

[ExecuteInEditMode]
public class Transforming : MonoBehaviour
{
    public Vector3 Position;
    public Vector3 Rotation;
    public Vector3 Scale;
    
    public void Update() {
        transform.position += Position * Time.deltaTime;
        transform.rotation *= Quaternion.Euler(Rotation * Time.deltaTime);
        transform.localScale += Scale * Time.deltaTime;
    }

    [ContextMenu("Reset")]
    public void Reset() {
        transform.position = Vector3.zero;
        transform.rotation = Quaternion.identity;
        transform.localScale = Vector3.one;
    }
}
