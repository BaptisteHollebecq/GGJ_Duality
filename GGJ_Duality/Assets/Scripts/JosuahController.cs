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

    [Header("Bi Camera Settings")]
    public Transform leftPivot;
    public Transform leftCamera;
    public Transform rightPivot;
    public Transform rightCamera;
    public float biTransitionSpeed = 7;
    public float biRotationSpeed = 2;
    public float orientationMaxAngle = 170;

    float _characterHeight = 1.5f;

    List<Mecanismes> mecanismes = new List<Mecanismes>();
    List<WhoSeeWhat> mecanismeSwitch = new List<WhoSeeWhat>();
    List<Mecanismes> mecanismesLastFrame = new List<Mecanismes>();

    ImageEffectBase _ieb;
    Rigidbody _rb;

    Vector3 _movementDirection;
    Vector2 _leftStickInput;
    Vector2 _rightStickInput;

    Vector3? _underContact = null;
    Vector3? _underNormal = null;

    bool _canMove;
    bool _canLook;
    bool _transi;
    bool _collide;
    bool _activeMeca;

    Coroutine _timerCollide;


    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();
        _characterHeight = GetComponent<SphereCollider>().radius;
        _ieb = Camera.main.transform.GetComponent<ImageEffectBase>();
    }

    private void Update()
    {
        if (mecanismes.Count != 0)
            mecanismes.Clear();
        if (mecanismeSwitch.Count != 0)
            mecanismeSwitch.Clear();

        if (state == State.MOVE)
        {

            mecanismes.Clear();
            RaycastHit hit;
            if (Physics.Raycast(cameraPivot.position, cameraPivot.forward, out hit, Mathf.Infinity))
            {
                Debug.DrawLine(cameraPivot.position, hit.point, Color.green);
                if (hit.collider.gameObject.TryGetComponent<Mecanismes>(out Mecanismes m))
                {
                    if (!mecanismes.Contains(m))
                        mecanismes.Add(m);
                }
                else if (hit.collider.gameObject.TryGetComponent<MecanismeSwitch>(out MecanismeSwitch ms))
                {
                    Debug.Log("ms touché");
                    var tmp = new WhoSeeWhat(cameraPivot, ms);
                    if (!mecanismeSwitch.Contains(tmp))
                        mecanismeSwitch.Add(tmp);
                }
            }
        }
        else
        {
            Debug.DrawRay(leftCamera.position, leftCamera.forward * 5, Color.red);
            Debug.DrawRay(rightCamera.position, rightCamera.forward * 5, Color.red);
            RaycastHit hit;
            if (Physics.Raycast(leftCamera.position, leftCamera.forward, out hit, Mathf.Infinity))
            {
                if (hit.collider.gameObject.TryGetComponent<Mecanismes>(out Mecanismes m))
                {
                    if (!mecanismes.Contains(m))
                        mecanismes.Add(m);
                }
                else if (hit.collider.gameObject.TryGetComponent<MecanismeSwitch>(out MecanismeSwitch ms))
                {
                    var tmp = new WhoSeeWhat(leftCamera, ms);
                    if (!mecanismeSwitch.Contains(tmp))
                        mecanismeSwitch.Add(tmp);
                }
            }
            if (Physics.Raycast(rightCamera.position, rightCamera.forward, out hit, Mathf.Infinity))
            {
                if (hit.collider.gameObject.TryGetComponent<Mecanismes>(out Mecanismes m))
                {
                    if (!mecanismes.Contains(m))
                        mecanismes.Add(m);
                }
                else if (hit.collider.gameObject.TryGetComponent<MecanismeSwitch>(out MecanismeSwitch ms))
                {
                    var tmp = new WhoSeeWhat(rightCamera, ms);
                    if (!mecanismeSwitch.Contains(tmp))
                        mecanismeSwitch.Add(tmp);
                }
            }
        }

        if (_activeMeca)
        {
            _activeMeca = false;
            if (mecanismeSwitch.Count != 0)
            {
                foreach (var item in mecanismeSwitch)
                {
                    item.ms.Switch(item.See);
                }
            }
        }

        if (mecanismesLastFrame.Count != 0)
        {
            foreach (var item in mecanismesLastFrame)
            {
                if (!mecanismes.Contains(item))
                {
                    item.lookedAt = false;
                }
            }
            mecanismesLastFrame.Clear();
        }
        foreach (Mecanismes m in mecanismes)
        {
            m.lookedAt = true;
            mecanismesLastFrame.Add(m);
        }
    }

    private void FixedUpdate()
    {
        if (state == State.MOVE && _canMove)
        {
            CheckUnder();

            _rb.velocity = Vector3.zero;
            _movementDirection = Vector3.zero;
            _movementDirection += _leftStickInput.x * transform.right;
            _movementDirection += _leftStickInput.y * transform.forward;
            _movementDirection.Normalize();

            _rb.velocity = _movementDirection * movementSpeed;


            transform.Rotate(transform.up, (_rightStickInput.x * horizontalRotationSpeed), Space.World);

            if (_underContact.HasValue)
            {
                if (Vector3.Angle(transform.up, _underNormal.Value) > 1 && !_collide)
                {
                    transform.rotation = Quaternion.Slerp(transform.rotation,
                        Quaternion.FromToRotation(transform.up, _underNormal.Value) * transform.rotation, transitionSpeed * Time.fixedDeltaTime);
                }
                else
                {
                    _transi = false;

                    if ((transform.position - _underContact.Value).magnitude > (_characterHeight * 1.1f) && !_collide)
                        transform.position = Vector3.Lerp(transform.position,
                            _underContact.Value + (_underNormal.Value).normalized * (_characterHeight), transitionSpeed * Time.deltaTime);
                }
            }
            else
            {
                Vector3 testRotation = Vector3.Cross(transform.up, _movementDirection);
                transform.Rotate(testRotation, (adjustementSpeed));
            }

            float angle = Vector3.Angle(transform.forward, cameraPivot.forward);
            if (Mathf.Abs(_rightStickInput.y) > verticalMovementThreshold)
            {
                if (angle < maxVerticalAngle / 2)
                {
                    cameraPivot.Rotate(transform.right, (-_rightStickInput.y * verticalRotationSpeed), Space.World);
                    if (Vector3.Angle(transform.forward, cameraPivot.forward) > maxVerticalAngle / 2)
                        cameraPivot.Rotate(transform.right, (_rightStickInput.y * verticalRotationSpeed), Space.World);

                }
            }
        }
        else if (state == State.MOVE)
        {
            if (Vector3.Angle(cameraPivot.forward, leftPivot.forward) > 1)
            {
                cameraPivot.localRotation = Quaternion.Slerp(cameraPivot.localRotation, Quaternion.identity, biTransitionSpeed * Time.deltaTime);

                leftPivot.localRotation = Quaternion.Slerp(leftPivot.localRotation, Quaternion.identity, biTransitionSpeed * Time.deltaTime);
                rightPivot.localRotation = Quaternion.Slerp(rightPivot.localRotation, Quaternion.identity, biTransitionSpeed * Time.deltaTime);

                leftCamera.localRotation = Quaternion.Slerp(leftCamera.localRotation, Quaternion.identity, biTransitionSpeed * Time.deltaTime);
                rightCamera.localRotation = Quaternion.Slerp(rightCamera.localRotation, Quaternion.identity, biTransitionSpeed * Time.deltaTime);

                _ieb.transition = Mathf.Lerp(_ieb.transition, 0, biTransitionSpeed * Time.deltaTime);
            }
            else
            {
                _ieb.transition = 0;
                cameraPivot.localRotation = Quaternion.identity;
                rightPivot.localRotation = Quaternion.identity;
                leftPivot.localRotation = Quaternion.identity;
                rightCamera.localRotation = Quaternion.identity ;
                leftCamera.localRotation = Quaternion.identity;

                _canMove = true;
            }
        }
        else if (state == State.LOOK == _canLook)
        {
            float leftAngle = Vector3.Angle(leftPivot.forward, leftCamera.forward);
            if (_leftStickInput.magnitude > .2f)
            {
                if (leftAngle < orientationMaxAngle / 2)
                {
                    leftCamera.Rotate(leftCamera.right, -_leftStickInput.y * biRotationSpeed, Space.World);
                    if (Vector3.Angle(leftPivot.forward, leftCamera.forward) > orientationMaxAngle / 2)
                        leftCamera.Rotate(leftCamera.right, _leftStickInput.y * 1.0f * biRotationSpeed, Space.World);


                    leftCamera.Rotate(leftPivot.up, _leftStickInput.x * biRotationSpeed, Space.World);
                    if (Vector3.Angle(leftPivot.forward, leftCamera.forward) > orientationMaxAngle / 2)
                        leftCamera.Rotate(leftPivot.up, -_leftStickInput.x * 1.0f * biRotationSpeed, Space.World);
                }
            }
            float rightAngle = Vector3.Angle(rightPivot.forward, rightCamera.forward);
            if (_rightStickInput.magnitude > .2f)
            {
                if (rightAngle < orientationMaxAngle / 2)
                {
                    rightCamera.Rotate(rightCamera.right, -_rightStickInput.y * biRotationSpeed, Space.World);
                    if (Vector3.Angle(rightPivot.forward, rightCamera.forward) > orientationMaxAngle / 2)
                        rightCamera.Rotate(rightCamera.right, _rightStickInput.y * 1.0f * biRotationSpeed, Space.World);


                    rightCamera.Rotate(rightPivot.up, _rightStickInput.x * biRotationSpeed, Space.World);
                    if (Vector3.Angle(rightPivot.forward, rightCamera.forward) > orientationMaxAngle / 2)
                        rightCamera.Rotate(leftPivot.up, -_rightStickInput.x * 1.0f * biRotationSpeed, Space.World);
                }
            }
        }
        else if (state == State.LOOK)
        {
            if (Vector3.Angle(leftPivot.forward, -transform.right) > 1)
            {
                leftPivot.forward = Vector3.Lerp(leftPivot.forward, -cameraPivot.right, biTransitionSpeed * Time.deltaTime);
                rightPivot.forward = Vector3.Lerp(rightPivot.forward, cameraPivot.right, biTransitionSpeed * Time.deltaTime);

                _ieb.transition = Mathf.Lerp(_ieb.transition, 1, biTransitionSpeed * Time.deltaTime);
            }
            else
            {
                _ieb.transition = 1;
                _rb.velocity = Vector3.zero;
                _movementDirection = Vector3.zero;
                leftPivot.forward = -cameraPivot.right;
                rightPivot.forward = cameraPivot.right;
                _canLook = true;
            }
        }
    }

    public void ResolveHeadPlacement(Vector3 Axis, Vector3 average)
    {

        if (Vector3.Angle(_movementDirection, average) < 90 && !_transi && _movementDirection != Vector3.zero)
        {
            Debug.DrawLine(transform.position, transform.position + average * 2, Color.green);
            transform.Rotate(Axis, (adjustementSpeed), Space.World);
            _collide = true;
        }
        else
            Debug.DrawLine(transform.position, transform.position + average * 2, Color.red);
    }

    public void EndCollide()
    {
        if (_timerCollide != null)
            StopCoroutine(_timerCollide);
        _timerCollide = StartCoroutine(ResetCollide());
    }

    IEnumerator ResetCollide()
    {
        yield return new WaitForEndOfFrame();
        _collide = false;
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
        }
        else
        {
            _transi = true;
            _underContact = null;
            _underNormal = null;
        }
    }

    void OnActiveMecanismes()
    {
        _activeMeca = true;
    }

    void OnLeftStick(InputValue value)
    {
        _leftStickInput = value.Get<Vector2>();
    }

    void OnRightStick(InputValue value)
    {
        _rightStickInput = value.Get<Vector2>();
    }

    void OnSwitchMode()
    {
        if (state == State.MOVE)
        {
            _ieb.transition = 0;
            _canMove = false;
            _canLook = false;
            state = State.LOOK;
        }
        else
        {
            _ieb.transition = 1;
            _canMove = false;
            _canLook = false;
            state = State.MOVE;
        }
    }
}
