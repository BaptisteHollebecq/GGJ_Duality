using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionManager : MonoBehaviour
{
    public LayerMask walkableLayer;

    public Vector3 collisionAverage;

    Vector3 pos { get { return transform.parent.position; } }
    JosuahController controller;

    private void Awake()
    {
        controller = transform.parent.GetComponent<JosuahController>();
    }

    private void OnCollisionStay(Collision collision)
    {
        if (collision.collider.gameObject.layer == LayerMask.NameToLayer("Walkable"))
        {
            collisionAverage = pos;
            foreach (ContactPoint point in collision.contacts)
            {
                collisionAverage += (point.point - pos).normalized;
            }
            collisionAverage.Normalize();
            Vector3 tangent = Vector3.Cross(collisionAverage, transform.parent.up);

            controller.ResolveHeadPlacement(tangent, collisionAverage);
        }
    }
}
