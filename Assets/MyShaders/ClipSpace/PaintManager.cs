using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class PaintManager : MonoBehaviour
{
    public static PaintManager instance;
    public Shader texturePaint;

    int hardnessID = Shader.PropertyToID("_Hardness");
    int textureID = Shader.PropertyToID("_MainTex");
    int colorID = Shader.PropertyToID("_PaintColor");
    int positionID = Shader.PropertyToID("_PaintPosition");
    int radiusID = Shader.PropertyToID("_Radius");

    Material paintMaterial;
    CommandBuffer command;


    private void Awake()
    {
        if (instance != null)
        {
            Debug.LogError("Multiple Paint Managers");
            Destroy(this);
            return;
        }
        instance = this;

        paintMaterial = new Material(texturePaint);
        command = new CommandBuffer();
        command.name = "CommmandBuffer - " + gameObject.name;
    }

    public void InitTextures(PaintableObject paintableObject)
    {
        Paint(paintableObject, Vector3.zero, 99999, 1, new Color(0, 0, 0, 0));
        Paint(paintableObject, Vector3.zero, 0.5f, 0.8f, Color.red);
    }

    public void Paint(PaintableObject paintableObject, Vector3 pos, float rad, float hardness, Color color)
    {
        RenderTexture mask = paintableObject.getMask();
        Renderer rend = paintableObject.getRenderer();

        paintMaterial.SetFloat(radiusID, rad);
        paintMaterial.SetFloat(hardnessID, hardness);
        paintMaterial.SetColor(colorID, color);
        paintMaterial.SetVector(positionID, pos);

        paintMaterial.SetTexture(textureID, mask);

        command.SetRenderTarget(mask);
        command.DrawRenderer(rend, paintMaterial, 0);

        Graphics.ExecuteCommandBuffer(command);
        command.Clear();
    }
}