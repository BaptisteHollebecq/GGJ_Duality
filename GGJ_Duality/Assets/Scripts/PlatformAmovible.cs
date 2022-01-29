using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlatformAmovible : Mecanismes
{
    public float movementSpeed = 3f;
    public Transform platform;
    public Transform pos1;
    public Transform pos2;
    public Transform interupteur;

    Transform target;
    Mecanismes detection;

    private void Start()
    {
        detection = interupteur.GetComponent<Mecanismes>();
        target = pos1;
    }

    private void Update()
    {
        lookedAt = detection.lookedAt;

        if (!lookedAt)
        {
            Vector3 direction = (target.position - platform.position).normalized;

            platform.Translate(direction * movementSpeed * Time.deltaTime);

            if (Vector3.Distance(platform.position, target.position) < .5f)
            {
                if (target == pos1)
                    target = pos2;
                else
                    target = pos1;
            }
        }
    }
}
