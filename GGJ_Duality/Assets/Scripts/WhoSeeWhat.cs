using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WhoSeeWhat
{
    public Transform See;
    public MecanismeSwitch ms;

    public WhoSeeWhat(Transform t, MecanismeSwitch _ms)
    {
        See = t;
        ms = _ms;
    }
}
