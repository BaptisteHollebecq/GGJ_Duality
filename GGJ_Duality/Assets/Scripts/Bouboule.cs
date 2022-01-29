using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bouboule : MecanismeSwitch
{
    public LayerMask walkableLayer;
    public float movementSpeed = 10;
    public float maxDistance = 5;

    SphereCollider collider;
    Rigidbody _rb;
    Transform eye;
    Vector3 direction;

    private void Start()
    {
        collider = GetComponent<SphereCollider>();
        _rb = GetComponent<Rigidbody>();
    }

    public override void Switch(Transform caller)
    {
        lookedAt = !lookedAt;
        _rb.useGravity = !lookedAt;
        eye = null;
        if (lookedAt)
            eye = caller;

    }

    private void Update()
    {
        if (lookedAt)
        {
            RaycastHit hit;
            Ray ray = new Ray(eye.position, eye.forward);
            if (Physics.Raycast(ray, out hit, Mathf.Infinity, walkableLayer))
            {
                Vector3 TargetPos = hit.point + hit.normal * (collider.radius * transform.localScale.x);

                Debug.DrawLine(eye.position, TargetPos, Color.yellow);

                direction = TargetPos - transform.position;

                if ((TargetPos - transform.position).sqrMagnitude > maxDistance * maxDistance)
                {
                    Switch(null);
                }
            }
        }
    }

    private void FixedUpdate()
    {
        if (lookedAt)
        {
            _rb.velocity = direction * movementSpeed;
        }
    }
}
