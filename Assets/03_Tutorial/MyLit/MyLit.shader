//Written in Shader Lab
Shader "rypor/MyLit"{
	// Properties are set per material in inspector
	Properties{
		[Header(Surface options)]
		// _variableName( "Label in inspector", var type) = default value
		// [MainTexture] and [MainColor] Allow these to be referenced through Material.mainTexture and Material.color
		[MainTexture] _MainTex("Color", 2D) = "white" {}
		[MainColor] _ColorTint("Tint", Color) = (1,1,1,1)
		_Smoothness("Smoothness", Float) = 0
	}

	//Subshaders : Different code for different pipelines
	SubShader{
		// Tags apply to this subshader
		Tags{"RenderPipeline" = "UniversalPipeline"}

		//Each Pass has its own vertex/fragment functions
		Pass{
			Name "ForwardLit" // For Debugging
			Tags{"LightMode" = "UniversalForward"} // "UniversalForward is the main lighting pass"


			//Rendering Pipeline: - runs per pass
			//	Input Assembler
			//  Vertex Func
			//	Rasterizer
			//	Fragment Func
			//  Presentation

			HLSLPROGRAM

			#define _SPECULAR_COLOR
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS	// Compiles a version of this pass with each arg enabled separately
														// These are called variants. _ = no keyword
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE	// This implies _MAIN_LIGHT_SHADOWS. In the future, add _MAIN_LIGHT_SHADOWS_CASCADE
																// to the above multi_compile instead
			#pragma multi_compile_fragment _ _SHADOWS_SOFT	//_SHADOW_SOFT only works on fragment shader. multi_compile_fragment shares vertex
															// func between variants

			#pragma vertex Vertex
			#pragma fragment Fragment

			#include "MyLitForwardLitPass.hlsl"
			ENDHLSL
		}

		// This pass is actually run before the forward lit pass. Unity handles calling passes in order
		// This pass draws our object to the shadowmap texture, so we can cast shadows.
		Pass{
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster"}

			ColorMask 0	// Metadata. Turns off color, since this pass only needs the depth buffer. Small optimization. Default = rbga

			HLSLPROGRAM
			#pragma vertex Vertex
			#pragma fragment Fragment

			#include "MyLitShadowCasterPass.hlsl"
			ENDHLSL
		}
	}
}