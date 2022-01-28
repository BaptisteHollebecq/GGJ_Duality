using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class JosuahController : MonoBehaviour
{
    public enum State { MOVE, LOOK }
    public State state = State.MOVE;


    public float movementSpeed = 3;

    [Header("Single Camera Settings")]
    public Transform cameraPivot;
    public float horizontalRotationSpeed = 10;
    public float verticalRotationSpeed = 10;
    public float verticalMovementThreshold = .5f;
    public float minVerticalAngle = 20;
    public float maxVerticalAngle = 45;

    Rigidbody _rb;

    Vector3 _movementDirection;
    Vector2 _leftStickInput;
    Vector2 _rightStickInput;

    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();
    }

    private void FixedUpdate()
    {
        if (state == State.MOVE)
        {
            // MOVEMENT 
            _movementDirection += _leftStickInput.x * GetCameraRight();
            _movementDirection += _leftStickInput.y * GetCameraForward();
            _movementDirection.Normalize();

            _rb.velocity = _movementDirection * movementSpeed;
            _movementDirection = Vector3.zero;

            transform.Rotate(Vector3.up, (_rightStickInput.x * horizontalRotationSpeed));
        }
    }

    private void LateUpdate()
    {
        Debug.Log(cameraPivot.rotation.eulerAngles.x);
        if (Mathf.Abs(_rightStickInput.y) > verticalMovementThreshold)
        {
            if (cameraPivot.rotation.eulerAngles.x < 360 - maxVerticalAngle && cameraPivot.rotation.eulerAngles.x > 180 && _rightStickInput.y < 0)
                cameraPivot.Rotate(Vector3.right, (-_rightStickInput.y * verticalRotationSpeed));
            else if (cameraPivot.rotation.eulerAngles.x > minVerticalAngle && cameraPivot.rotation.eulerAngles.x < 180 && _rightStickInput.y > 0)
                cameraPivot.Rotate(Vector3.right, (-_rightStickInput.y * verticalRotationSpeed));
            else
                cameraPivot.Rotate(Vector3.right, (-_rightStickInput.y * verticalRotationSpeed));
        }
    }
/*    if (cameraPivot.rotation.eulerAngles.x > 360 - maxVerticalAngle && cameraPivot.rotation.eulerAngles.x <= 360 ||
                cameraPivot.rotation.eulerAngles.x<minVerticalAngle && cameraPivot.rotation.eulerAngles.x >= 0)
            {
                cameraPivot.Rotate(Vector3.right, (-_rightStickInput.y* verticalRotationSpeed));
}*/
void OnLeftStick(InputValue value)
    {
        _leftStickInput = value.Get<Vector2>();
    }

    void OnRightStick(InputValue value)
    {
        _rightStickInput = value.Get<Vector2>();
    }

    private Vector3 GetCameraForward()
    {
        Vector3 forward = cameraPivot.transform.forward;
        forward.y = 0;
        return forward.normalized;
    }

    private Vector3 GetCameraRight()
    {
        Vector3 right = cameraPivot.transform.right;
        right.y = 0;
        return right.normalized;
    }

}
