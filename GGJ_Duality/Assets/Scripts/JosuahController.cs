using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class JosuahController : MonoBehaviour
{
    public enum State { MOVE, LOOK }

    [Header("Movement Settings")]
    public State state = State.MOVE;
    public LayerMask walkableLayer;
    public float movementSpeed = 3;
    public float adjustementSpeed = 10;
    public float transitionSpeed = 1.5f;

    [Header("Single Camera Settings")]
    public Transform cameraPivot;
    public float horizontalRotationSpeed = 10;
    public float verticalRotationSpeed = 10;
    public float verticalMovementThreshold = .5f;
    public float minVerticalAngle = 20;
    public float maxVerticalAngle = 45;

    [Header("Debug")]
    public Transform Up;

    float characterHeight = 1.5f;

    Rigidbody _rb;

    Vector3 _movementDirection;
    Vector3 _up { get { return (Up.position - transform.position).normalized; } }

    Vector2 _leftStickInput;
    Vector2 _rightStickInput;

    Vector3? _underContact = null;
    Vector3? _underNormal = null;
    Vector3 _lastKnownPos;

    bool _transi;


    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();
        characterHeight = GetComponent<SphereCollider>().radius;
    }

    private void FixedUpdate()
    {
        if (_underNormal.HasValue)
            Debug.DrawRay(transform.position, _underNormal.Value * 2, Color.green);

        Debug.DrawRay(transform.position, _up * 2, Color.red);


        if (state == State.MOVE)
        {
            CheckUnder();

            _rb.velocity = Vector3.zero;
            _movementDirection = Vector3.zero;
            _movementDirection += _leftStickInput.x * transform.right;
            _movementDirection += _leftStickInput.y * transform.forward;
            _movementDirection.Normalize();

            _rb.velocity = _movementDirection * movementSpeed;

            transform.Rotate(_up, (_rightStickInput.x * horizontalRotationSpeed), Space.World);

            if (_underContact.HasValue)
            {
                if (Vector3.Angle(_up, _underNormal.Value) > 1 && _transi)
                {
                    transform.rotation = Quaternion.Slerp(transform.rotation,
                        Quaternion.FromToRotation(transform.up, _underNormal.Value) * transform.rotation, transitionSpeed * Time.fixedDeltaTime);
                }
                else
                {
                    _transi = false;

                    if ((transform.position - _underContact.Value).magnitude > (characterHeight * 1.1f))
                        transform.position = Vector3.Lerp(transform.position,
                            _underContact.Value + (_underNormal.Value).normalized * (characterHeight), transitionSpeed/2 * Time.deltaTime);
                }
            }
            else
            {
                Vector3 testRotation = Vector3.Cross(transform.up, _movementDirection);
                Debug.DrawLine(transform.position, transform.position + testRotation, Color.red, 5);
                transform.Rotate(testRotation, (adjustementSpeed));
            }

            float angle = Vector3.Angle(transform.forward, cameraPivot.forward);
            if (Mathf.Abs(_rightStickInput.y) > verticalMovementThreshold)
            {
                if (cameraPivot.rotation.eulerAngles.x > 180 && angle > maxVerticalAngle && _rightStickInput.y > 0)
                    return;
                if (cameraPivot.rotation.eulerAngles.x < 180 && angle > minVerticalAngle && _rightStickInput.y < 0)
                    return;

                cameraPivot.Rotate(transform.right, (-_rightStickInput.y * verticalRotationSpeed), Space.World);
            }
        }
    }

    public void ResolveHeadPlacement(Vector3 Axis, Vector3 average)
    {
        if (Vector3.Angle(_movementDirection, average) < 90 && !_transi)
        {
            transform.Rotate(Axis, (adjustementSpeed), Space.World);
        }
    }

    void CheckUnder()
    {
        RaycastHit hit;
        if (Physics.Raycast(transform.position, -transform.up, out hit, 5, walkableLayer))
        {
            if ((_underNormal.HasValue && _underNormal.Value != hit.normal))
                _transi = true;
            _underContact = hit.point;
            _underNormal = hit.normal;
            _lastKnownPos = hit.point;
        }
        else
        {
            _transi = true;
            _underContact = null;
            _underNormal = null;
        }
    }

    void OnLeftStick(InputValue value)
    {
        _leftStickInput = value.Get<Vector2>();
    }

    void OnRightStick(InputValue value)
    {
        _rightStickInput = value.Get<Vector2>();
    }

}
