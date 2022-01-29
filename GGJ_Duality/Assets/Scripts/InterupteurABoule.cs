using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InterupteurABoule : MonoBehaviour
{
    public bool triggered = false;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.TryGetComponent<Bouboule>(out Bouboule b))
        {
            Debug.Log("bouboule detected");
            triggered = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.TryGetComponent<Bouboule>(out Bouboule b))
        {
            Debug.Log("bouboule left");
            triggered = false;
        }
    }
}
