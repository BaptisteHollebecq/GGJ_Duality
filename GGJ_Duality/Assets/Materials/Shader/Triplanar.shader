// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplanar"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_MRAH("MRAH", 2D) = "white" {}
		_Hardness("Hardness", Range( 0 , 1)) = 0
		_Tile("Tile", Range( 0.1 , 5)) = 0.1
		_Rotator("Rotator", Vector) = (0,0,0,0)
		_ScaleNormal("Scale Normal", Range( 0 , 2)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal;
		uniform float _Tile;
		uniform float3 _Rotator;
		uniform float _Hardness;
		uniform float _ScaleNormal;
		uniform sampler2D _Albedo;
		uniform sampler2D _MRAH;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float tile16 = _Tile;
			float3 break2_g4 = ( ase_worldPos / tile16 );
			float2 appendResult45_g4 = (float2(break2_g4.x , break2_g4.y));
			float3 rotator17 = _Rotator;
			float3 break56_g4 = rotator17;
			float cos58_g4 = cos( break56_g4.x );
			float sin58_g4 = sin( break56_g4.x );
			float2 rotator58_g4 = mul( appendResult45_g4 - float2( 0,0 ) , float2x2( cos58_g4 , -sin58_g4 , sin58_g4 , cos58_g4 )) + float2( 0,0 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 worldNormal18 = ase_worldNormal;
			float hardness15 = _Hardness;
			float3 temp_cast_0 = ((5.0 + (hardness15 - 0.0) * (100.0 - 5.0) / (1.0 - 0.0))).xxx;
			float3 temp_output_27_0_g4 = pow( abs( worldNormal18 ) , temp_cast_0 );
			float3 break28_g4 = temp_output_27_0_g4;
			float3 break18_g4 = ( temp_output_27_0_g4 / ( break28_g4.x + break28_g4.y + break28_g4.z ) );
			float2 appendResult46_g4 = (float2(break2_g4.z , break2_g4.x));
			float cos57_g4 = cos( break56_g4.y );
			float sin57_g4 = sin( break56_g4.y );
			float2 rotator57_g4 = mul( appendResult46_g4 - float2( 0,0 ) , float2x2( cos57_g4 , -sin57_g4 , sin57_g4 , cos57_g4 )) + float2( 0,0 );
			float2 appendResult47_g4 = (float2(break2_g4.y , break2_g4.z));
			float cos51_g4 = cos( ( 1.4 + break56_g4.z ) );
			float sin51_g4 = sin( ( 1.4 + break56_g4.z ) );
			float2 rotator51_g4 = mul( appendResult47_g4 - float2( 0,0 ) , float2x2( cos51_g4 , -sin51_g4 , sin51_g4 , cos51_g4 )) + float2( 0,0 );
			o.Normal = UnpackScaleNormal( ( ( tex2D( _Normal, rotator58_g4 ) * break18_g4.z ) + ( tex2D( _Normal, rotator57_g4 ) * break18_g4.y ) + ( tex2D( _Normal, rotator51_g4 ) * break18_g4.x ) ), _ScaleNormal );
			float3 break2_g1 = ( ase_worldPos / tile16 );
			float2 appendResult45_g1 = (float2(break2_g1.x , break2_g1.y));
			float3 break56_g1 = rotator17;
			float cos58_g1 = cos( break56_g1.x );
			float sin58_g1 = sin( break56_g1.x );
			float2 rotator58_g1 = mul( appendResult45_g1 - float2( 0,0 ) , float2x2( cos58_g1 , -sin58_g1 , sin58_g1 , cos58_g1 )) + float2( 0,0 );
			float3 temp_cast_2 = ((5.0 + (hardness15 - 0.0) * (100.0 - 5.0) / (1.0 - 0.0))).xxx;
			float3 temp_output_27_0_g1 = pow( abs( worldNormal18 ) , temp_cast_2 );
			float3 break28_g1 = temp_output_27_0_g1;
			float3 break18_g1 = ( temp_output_27_0_g1 / ( break28_g1.x + break28_g1.y + break28_g1.z ) );
			float2 appendResult46_g1 = (float2(break2_g1.z , break2_g1.x));
			float cos57_g1 = cos( break56_g1.y );
			float sin57_g1 = sin( break56_g1.y );
			float2 rotator57_g1 = mul( appendResult46_g1 - float2( 0,0 ) , float2x2( cos57_g1 , -sin57_g1 , sin57_g1 , cos57_g1 )) + float2( 0,0 );
			float2 appendResult47_g1 = (float2(break2_g1.y , break2_g1.z));
			float cos51_g1 = cos( ( 1.4 + break56_g1.z ) );
			float sin51_g1 = sin( ( 1.4 + break56_g1.z ) );
			float2 rotator51_g1 = mul( appendResult47_g1 - float2( 0,0 ) , float2x2( cos51_g1 , -sin51_g1 , sin51_g1 , cos51_g1 )) + float2( 0,0 );
			o.Albedo = ( ( tex2D( _Albedo, rotator58_g1 ) * break18_g1.z ) + ( tex2D( _Albedo, rotator57_g1 ) * break18_g1.y ) + ( tex2D( _Albedo, rotator51_g1 ) * break18_g1.x ) ).rgb;
			float3 break2_g5 = ( ase_worldPos / tile16 );
			float2 appendResult45_g5 = (float2(break2_g5.x , break2_g5.y));
			float3 break56_g5 = rotator17;
			float cos58_g5 = cos( break56_g5.x );
			float sin58_g5 = sin( break56_g5.x );
			float2 rotator58_g5 = mul( appendResult45_g5 - float2( 0,0 ) , float2x2( cos58_g5 , -sin58_g5 , sin58_g5 , cos58_g5 )) + float2( 0,0 );
			float3 temp_cast_4 = ((5.0 + (hardness15 - 0.0) * (100.0 - 5.0) / (1.0 - 0.0))).xxx;
			float3 temp_output_27_0_g5 = pow( abs( worldNormal18 ) , temp_cast_4 );
			float3 break28_g5 = temp_output_27_0_g5;
			float3 break18_g5 = ( temp_output_27_0_g5 / ( break28_g5.x + break28_g5.y + break28_g5.z ) );
			float2 appendResult46_g5 = (float2(break2_g5.z , break2_g5.x));
			float cos57_g5 = cos( break56_g5.y );
			float sin57_g5 = sin( break56_g5.y );
			float2 rotator57_g5 = mul( appendResult46_g5 - float2( 0,0 ) , float2x2( cos57_g5 , -sin57_g5 , sin57_g5 , cos57_g5 )) + float2( 0,0 );
			float2 appendResult47_g5 = (float2(break2_g5.y , break2_g5.z));
			float cos51_g5 = cos( ( 1.4 + break56_g5.z ) );
			float sin51_g5 = sin( ( 1.4 + break56_g5.z ) );
			float2 rotator51_g5 = mul( appendResult47_g5 - float2( 0,0 ) , float2x2( cos51_g5 , -sin51_g5 , sin51_g5 , cos51_g5 )) + float2( 0,0 );
			float4 break13 = ( ( tex2D( _MRAH, rotator58_g5 ) * break18_g5.z ) + ( tex2D( _MRAH, rotator57_g5 ) * break18_g5.y ) + ( tex2D( _MRAH, rotator51_g5 ) * break18_g5.x ) );
			o.Metallic = break13;
			o.Smoothness = ( 1.0 - break13.g );
			o.Occlusion = break13.b;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
262;73;1242;642;2258.342;225.0404;2.986438;True;False
Node;AmplifyShaderEditor.Vector3Node;7;-1910.32,127.8807;Inherit;False;Property;_Rotator;Rotator;5;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;5;-1913.047,4.052427;Inherit;False;Property;_Tile;Tile;4;0;Create;True;0;0;0;False;0;False;0.1;0;0.1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1916.674,-126.1356;Inherit;False;Property;_Hardness;Hardness;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;8;-1922.814,302.9548;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-1573.96,304.7995;Inherit;False;worldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-1580.978,128.308;Inherit;False;rotator;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1584.081,0.7476349;Inherit;False;tile;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-1587.626,-126.9082;Inherit;False;hardness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-676.2101,969.0356;Inherit;True;Property;_MRAH;MRAH;2;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;32;-654.9504,1434.01;Inherit;False;18;worldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-676.6165,1354.014;Inherit;False;17;rotator;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-684.9495,1264.017;Inherit;False;16;tile;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-669.95,1170.688;Inherit;False;15;hardness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-666.6996,587.0211;Inherit;False;15;hardness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-676.2047,390.532;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;26;-673.366,770.3467;Inherit;False;17;rotator;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;28;-378.9409,1192.939;Inherit;False;TriPlanarRotator_Func;-1;;5;9451cd5228c71e946aaaef00fea59976;0;5;40;SAMPLER2D;0,0,0,0;False;38;FLOAT;0;False;44;FLOAT;1;False;55;FLOAT3;1,0,0;False;39;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-681.6991,680.3505;Inherit;False;16;tile;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-651.7001,850.3434;Inherit;False;18;worldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-653.6461,-22.23257;Inherit;False;15;hardness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;23;-375.6909,609.2717;Inherit;False;TriPlanarRotator_Func;-1;;4;9451cd5228c71e946aaaef00fea59976;0;5;40;SAMPLER2D;0,0,0,0;False;38;FLOAT;0;False;44;FLOAT;1;False;55;FLOAT3;1,0,0;False;39;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-685.3996,-271.2488;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;20;-668.6456,71.09689;Inherit;False;16;tile;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-660.3125,161.0931;Inherit;False;17;rotator;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-638.6466,241.0898;Inherit;False;18;worldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-270.9283,819.8563;Inherit;False;Property;_ScaleNormal;Scale Normal;6;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;13;-97.58519,1001.48;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.UnpackScaleNormalNode;33;17.35969,618.1578;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;2;-362.6373,0.0180583;Inherit;False;TriPlanarRotator_Func;-1;;1;9451cd5228c71e946aaaef00fea59976;0;5;40;SAMPLER2D;0,0,0,0;False;38;FLOAT;0;False;44;FLOAT;1;False;55;FLOAT3;1,0,0;False;39;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;14;97.57784,1018.569;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;408.0407,594.7263;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Triplanar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;8;0
WireConnection;17;0;7;0
WireConnection;16;0;5;0
WireConnection;15;0;4;0
WireConnection;28;40;10;0
WireConnection;28;38;29;0
WireConnection;28;44;30;0
WireConnection;28;55;31;0
WireConnection;28;39;32;0
WireConnection;23;40;12;0
WireConnection;23;38;24;0
WireConnection;23;44;25;0
WireConnection;23;55;26;0
WireConnection;23;39;27;0
WireConnection;13;0;28;0
WireConnection;33;0;23;0
WireConnection;33;1;34;0
WireConnection;2;40;3;0
WireConnection;2;38;19;0
WireConnection;2;44;20;0
WireConnection;2;55;21;0
WireConnection;2;39;22;0
WireConnection;14;0;13;1
WireConnection;0;0;2;0
WireConnection;0;1;33;0
WireConnection;0;3;13;0
WireConnection;0;4;14;0
WireConnection;0;5;13;2
ASEEND*/
//CHKSM=B10046FFC4093AAE189C3DFEAAD8D23297118D61