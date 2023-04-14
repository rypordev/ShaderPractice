//Written in Shader Lab
Shader "rypor/MyLit"{
	// Properties are set per material in inspector
	Properties{
		[Header(Surface options)]
		// _variableName( "Label in inspector", var type) = default value
		// [MainTexture] and [MainColor] Allow these to be referenced through Material.mainTexture and Material.color
		[MainTexture] _ColorMap("Color", 2D) = "white" {}
		[MainColor] _ColorTint("Tint", Color) = (1,1,1,1)
	}

	//Subshaders : Different code for different pipelines
	SubShader{
		// Tags apply to this subshader
		Tags{"RenderPipeline" = "UniversalPipeline"}

		//Each Pass has its own vertex/fragment functions
		Pass{
			Name "ForwardLit" // For Debugging
			Tags{"LightMode" = "UniversalForward"} // "UniversalForward is the main lighting pass"


			//Rendering Pipeline:
			//	Input Assembler
			//  Vertex Func
			//	Rasterizer
			//	Fragment Func
			//  Presentation

			HLSLPROGRAM
			#pragma vertex Vertex
			#pragma fragment Fragment

			#include "MyLitForwardLitPass.hlsl"
			ENDHLSL
		}
	}
}