using UnityEngine;

[RequireComponent(typeof(Camera))]
public class ImageEffectBase : MonoBehaviour
{
	public Material material;

	// OnRenderImage() is called when the camera has finished rendering.
	protected virtual void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		Graphics.Blit(src, dst, material);
	}
}
