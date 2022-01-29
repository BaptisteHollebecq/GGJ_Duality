using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class MecanismeSwitch : MonoBehaviour
{
    public bool lookedAt = false;

    public abstract void Switch(Transform caller);
}
