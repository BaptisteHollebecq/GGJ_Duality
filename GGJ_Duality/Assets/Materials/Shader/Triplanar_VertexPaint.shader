// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplanar_VertexColor"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Albedo2("Albedo 2", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_MRAH("MRAH", 2D) = "white" {}
		_MRAH2("MRAH 2", 2D) = "white" {}
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
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal;
		uniform float _Tile;
		uniform float3 _Rotator;
		uniform float _Hardness;
		uniform float _ScaleNormal;
		uniform sampler2D _Albedo2;
		uniform sampler2D _Albedo;
		uniform sampler2D _MRAH2;
		uniform sampler2D _MRAH;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float tile16 = _Tile;
			float3 break2_g6 = ( ase_worldPos / tile16 );
			float2 appendResult45_g6 = (float2(break2_g6.x , break2_g6.y));
			float3 rotator17 = _Rotator;
			float3 break56_g6 = rotator17;
			float cos58_g6 = cos( break56_g6.x );
			float sin58_g6 = sin( break56_g6.x );
			float2 rotator58_g6 = mul( appendResult45_g6 - float2( 0,0 ) , float2x2( cos58_g6 , -sin58_g6 , sin58_g6 , cos58_g6 )) + float2( 0,0 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 worldNormal18 = ase_worldNormal;
			float hardness15 = _Hardness;
			float3 temp_cast_0 = ((5.0 + (hardness15 - 0.0) * (100.0 - 5.0) / (1.0 - 0.0))).xxx;
			float3 temp_output_27_0_g6 = pow( abs( worldNormal18 ) , temp_cast_0 );
			float3 break28_g6 = temp_output_27_0_g6;
			float3 break18_g6 = ( temp_output_27_0_g6 / ( break28_g6.x + break28_g6.y + break28_g6.z ) );
			float2 appendResult46_g6 = (float2(break2_g6.z , break2_g6.x));
			float cos57_g6 = cos( break56_g6.y );
			float sin57_g6 = sin( break56_g6.y );
			float2 rotator57_g6 = mul( appendResult46_g6 - float2( 0,0 ) , float2x2( cos57_g6 , -sin57_g6 , sin57_g6 , cos57_g6 )) + float2( 0,0 );
			float2 appendResult47_g6 = (float2(break2_g6.y , break2_g6.z));
			float cos51_g6 = cos( ( 1.4 + break56_g6.z ) );
			float sin51_g6 = sin( ( 1.4 + break56_g6.z ) );
			float2 rotator51_g6 = mul( appendResult47_g6 - float2( 0,0 ) , float2x2( cos51_g6 , -sin51_g6 , sin51_g6 , cos51_g6 )) + float2( 0,0 );
			float lerpResult51 = lerp( 0.0 , _ScaleNormal , i.vertexColor.r);
			o.Normal = UnpackScaleNormal( ( ( tex2D( _Normal, rotator58_g6 ) * break18_g6.z ) + ( tex2D( _Normal, rotator57_g6 ) * break18_g6.y ) + ( tex2D( _Normal, rotator51_g6 ) * break18_g6.x ) ), lerpResult51 );
			float3 break2_g8 = ( ase_worldPos / tile16 );
			float2 appendResult45_g8 = (float2(break2_g8.x , break2_g8.y));
			float3 break56_g8 = rotator17;
			float cos58_g8 = cos( break56_g8.x );
			float sin58_g8 = sin( break56_g8.x );
			float2 rotator58_g8 = mul( appendResult45_g8 - float2( 0,0 ) , float2x2( cos58_g8 , -sin58_g8 , sin58_g8 , cos58_g8 )) + float2( 0,0 );
			float3 temp_cast_2 = ((5.0 + (hardness15 - 0.0) * (100.0 - 5.0) / (1.0 - 0.0))).xxx;
			float3 temp_output_27_0_g8 = pow( abs( worldNormal18 ) , temp_cast_2 );
			float3 break28_g8 = temp_output_27_0_g8;
			float3 break18_g8 = ( temp_output_27_0_g8 / ( break28_g8.x + break28_g8.y + break28_g8.z ) );
			float2 appendResult46_g8 = (float2(break2_g8.z , break2_g8.x));
			float cos57_g8 = cos( break56_g8.y );
			float sin57_g8 = sin( break56_g8.y );
			float2 rotator57_g8 = mul( appendResult46_g8 - float2( 0,0 ) , float2x2( cos57_g8 , -sin57_g8 , sin57_g8 , cos57_g8 )) + float2( 0,0 );
			float2 appendResult47_g8 = (float2(break2_g8.y , break2_g8.z));
			float cos51_g8 = cos( ( 1.4 + break56_g8.z ) );
			float sin51_g8 = sin( ( 1.4 + break56_g8.z ) );
			float2 rotator51_g8 = mul( appendResult47_g8 - float2( 0,0 ) , float2x2( cos51_g8 , -sin51_g8 , sin51_g8 , cos51_g8 )) + float2( 0,0 );
			float3 break2_g7 = ( ase_worldPos / tile16 );
			float2 appendResult45_g7 = (float2(break2_g7.x , break2_g7.y));
			float3 break56_g7 = rotator17;
			float cos58_g7 = cos( break56_g7.x );
			float sin58_g7 = sin( break56_g7.x );
			float2 rotator58_g7 = mul( appendResult45_g7 - float2( 0,0 ) , float2x2( cos58_g7 , -sin58_g7 , sin58_g7 , cos58_g7 )) + float2( 0,0 );
			float3 temp_cast_3 = ((5.0 + (hardness15 - 0.0) * (100.0 - 5.0) / (1.0 - 0.0))).xxx;
			float3 temp_output_27_0_g7 = pow( abs( worldNormal18 ) , temp_cast_3 );
			float3 break28_g7 = temp_output_27_0_g7;
			float3 break18_g7 = ( temp_output_27_0_g7 / ( break28_g7.x + break28_g7.y + break28_g7.z ) );
			float2 appendResult46_g7 = (float2(break2_g7.z , break2_g7.x));
			float cos57_g7 = cos( break56_g7.y );
			float sin57_g7 = sin( break56_g7.y );
			float2 rotator57_g7 = mul( appendResult46_g7 - float2( 0,0 ) , float2x2( cos57_g7 , -sin57_g7 , sin57_g7 , cos57_g7 )) + float2( 0,0 );
			float2 appendResult47_g7 = (float2(break2_g7.y , break2_g7.z));
			float cos51_g7 = cos( ( 1.4 + break56_g7.z ) );
			float sin51_g7 = sin( ( 1.4 + break56_g7.z ) );
			float2 rotator51_g7 = mul( appendResult47_g7 - float2( 0,0 ) , float2x2( cos51_g7 , -sin51_g7 , sin51_g7 , cos51_g7 )) + float2( 0,0 );
			float4 lerpResult48 = lerp( ( ( tex2D( _Albedo2, rotator58_g8 ) * break18_g8.z ) + ( tex2D( _Albedo2, rotator57_g8 ) * break18_g8.y ) + ( tex2D( _Albedo2, rotator51_g8 ) * break18_g8.x ) ) , ( ( tex2D( _Albedo, rotator58_g7 ) * break18_g7.z ) + ( tex2D( _Albedo, rotator57_g7 ) * break18_g7.y ) + ( tex2D( _Albedo, rotator51_g7 ) * break18_g7.x ) ) , i.vertexColor.r);
			o.Albedo = lerpResult48.rgb;
			float3 break2_g9 = ( ase_worldPos / tile16 );
			float2 appendResult45_g9 = (float2(break2_g9.x , break2_g9.y));
			float3 break56_g9 = rotator17;
			float cos58_g9 = cos( break56_g9.x );
			float sin58_g9 = sin( break56_g9.x );
			float2 rotator58_g9 = mul( appendResult45_g9 - float2( 0,0 ) , float2x2( cos58_g9 , -sin58_g9 , sin58_g9 , cos58_g9 )) + float2( 0,0 );
			float3 temp_cast_5 = ((5.0 + (hardness15 - 0.0) * (100.0 - 5.0) / (1.0 - 0.0))).xxx;
			float3 temp_output_27_0_g9 = pow( abs( worldNormal18 ) , temp_cast_5 );
			float3 break28_g9 = temp_output_27_0_g9;
			float3 break18_g9 = ( temp_output_27_0_g9 / ( break28_g9.x + break28_g9.y + break28_g9.z ) );
			float2 appendResult46_g9 = (float2(break2_g9.z , break2_g9.x));
			float cos57_g9 = cos( break56_g9.y );
			float sin57_g9 = sin( break56_g9.y );
			float2 rotator57_g9 = mul( appendResult46_g9 - float2( 0,0 ) , float2x2( cos57_g9 , -sin57_g9 , sin57_g9 , cos57_g9 )) + float2( 0,0 );
			float2 appendResult47_g9 = (float2(break2_g9.y , break2_g9.z));
			float cos51_g9 = cos( ( 1.4 + break56_g9.z ) );
			float sin51_g9 = sin( ( 1.4 + break56_g9.z ) );
			float2 rotator51_g9 = mul( appendResult47_g9 - float2( 0,0 ) , float2x2( cos51_g9 , -sin51_g9 , sin51_g9 , cos51_g9 )) + float2( 0,0 );
			float3 break2_g5 = ( ase_worldPos / tile16 );
			float2 appendResult45_g5 = (float2(break2_g5.x , break2_g5.y));
			float3 break56_g5 = rotator17;
			float cos58_g5 = cos( break56_g5.x );
			float sin58_g5 = sin( break56_g5.x );
			float2 rotator58_g5 = mul( appendResult45_g5 - float2( 0,0 ) , float2x2( cos58_g5 , -sin58_g5 , sin58_g5 , cos58_g5 )) + float2( 0,0 );
			float3 temp_cast_6 = ((5.0 + (hardness15 - 0.0) * (100.0 - 5.0) / (1.0 - 0.0))).xxx;
			float3 temp_output_27_0_g5 = pow( abs( worldNormal18 ) , temp_cast_6 );
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
			float4 lerpResult49 = lerp( ( ( tex2D( _MRAH2, rotator58_g9 ) * break18_g9.z ) + ( tex2D( _MRAH2, rotator57_g9 ) * break18_g9.y ) + ( tex2D( _MRAH2, rotator51_g9 ) * break18_g9.x ) ) , ( ( tex2D( _MRAH, rotator58_g5 ) * break18_g5.z ) + ( tex2D( _MRAH, rotator57_g5 ) * break18_g5.y ) + ( tex2D( _MRAH, rotator51_g5 ) * break18_g5.x ) ) , i.vertexColor.r);
			float4 break13 = lerpResult49;
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
				half4 color : COLOR0;
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
				o.color = v.color;
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
				surfIN.vertexColor = IN.color;
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
262;73;1242;642;752.9982;-517.6602;1.244108;True;False
Node;AmplifyShaderEditor.Vector3Node;7;-1910.32,127.8807;Inherit;False;Property;_Rotator;Rotator;7;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;5;-1913.047,4.052427;Inherit;False;Property;_Tile;Tile;6;0;Create;True;0;0;0;False;0;False;0.1;0;0.1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1916.674,-126.1356;Inherit;False;Property;_Hardness;Hardness;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;8;-1922.814,302.9548;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-1573.96,304.7995;Inherit;False;worldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-1580.978,128.308;Inherit;False;rotator;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1584.081,0.7476349;Inherit;False;tile;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-1587.626,-126.9082;Inherit;False;hardness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-633.3566,1899.842;Inherit;False;16;tile;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-676.2101,969.0356;Inherit;True;Property;_MRAH;MRAH;3;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;42;-603.3574,2069.835;Inherit;False;18;worldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-618.357,1806.513;Inherit;False;15;hardness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-625.0236,1989.839;Inherit;False;17;rotator;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;41;-624.6171,1604.86;Inherit;True;Property;_MRAH2;MRAH 2;4;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;31;-676.6165,1354.014;Inherit;False;17;rotator;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-669.95,1170.688;Inherit;False;15;hardness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-654.9504,1434.01;Inherit;False;18;worldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-684.9495,1264.017;Inherit;False;16;tile;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;46;-327.3477,1828.764;Inherit;False;TriPlanarRotator_Func;-1;;9;9451cd5228c71e946aaaef00fea59976;0;5;40;SAMPLER2D;0,0,0,0;False;38;FLOAT;0;False;44;FLOAT;1;False;55;FLOAT3;1,0,0;False;39;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;50;-241.9477,1447.924;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;28;-378.9409,1192.939;Inherit;False;TriPlanarRotator_Func;-1;;5;9451cd5228c71e946aaaef00fea59976;0;5;40;SAMPLER2D;0,0,0,0;False;38;FLOAT;0;False;44;FLOAT;1;False;55;FLOAT3;1,0,0;False;39;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-673.366,770.3467;Inherit;False;17;rotator;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;36;-674.1175,-355.5645;Inherit;True;Property;_Albedo2;Albedo 2;1;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;49;2.52736,1312.681;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;52;-185.0156,987.8369;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;24;-666.6996,587.0211;Inherit;False;15;hardness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-676.2047,390.532;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;34;-307.6664,888.3227;Inherit;False;Property;_ScaleNormal;Scale Normal;8;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-649.0305,76.77729;Inherit;False;17;rotator;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-627.3646,156.774;Inherit;False;18;worldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-651.7001,850.3434;Inherit;False;18;worldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-645.3531,-583.9193;Inherit;False;17;rotator;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-623.6873,-503.9226;Inherit;False;18;worldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-681.6991,680.3505;Inherit;False;16;tile;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-653.6863,-673.9155;Inherit;False;16;tile;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-642.3641,-106.5484;Inherit;False;15;hardness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-657.3636,-13.21889;Inherit;False;16;tile;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-638.6868,-767.245;Inherit;False;15;hardness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-670.4402,-1016.261;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;40;-351.3557,-84.29769;Inherit;False;TriPlanarRotator_Func;-1;;8;9451cd5228c71e946aaaef00fea59976;0;5;40;SAMPLER2D;0,0,0,0;False;38;FLOAT;0;False;44;FLOAT;1;False;55;FLOAT3;1,0,0;False;39;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;2;-347.678,-744.9944;Inherit;False;TriPlanarRotator_Func;-1;;7;9451cd5228c71e946aaaef00fea59976;0;5;40;SAMPLER2D;0,0,0,0;False;38;FLOAT;0;False;44;FLOAT;1;False;55;FLOAT3;1,0,0;False;39;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;13;120.1218,1008.077;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;51;28.73306,784.1075;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;23;-375.6909,609.2717;Inherit;False;TriPlanarRotator_Func;-1;;6;9451cd5228c71e946aaaef00fea59976;0;5;40;SAMPLER2D;0,0,0,0;False;38;FLOAT;0;False;44;FLOAT;1;False;55;FLOAT3;1,0,0;False;39;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;47;-126.8797,156.7145;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;48;152.1637,-271.365;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;14;439.064,1032.15;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;33;167.6517,596.4488;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;824.4566,631.6682;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Triplanar_VertexColor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;8;0
WireConnection;17;0;7;0
WireConnection;16;0;5;0
WireConnection;15;0;4;0
WireConnection;46;40;41;0
WireConnection;46;38;45;0
WireConnection;46;44;44;0
WireConnection;46;55;43;0
WireConnection;46;39;42;0
WireConnection;28;40;10;0
WireConnection;28;38;29;0
WireConnection;28;44;30;0
WireConnection;28;55;31;0
WireConnection;28;39;32;0
WireConnection;49;0;46;0
WireConnection;49;1;28;0
WireConnection;49;2;50;1
WireConnection;40;40;36;0
WireConnection;40;38;35;0
WireConnection;40;44;37;0
WireConnection;40;55;38;0
WireConnection;40;39;39;0
WireConnection;2;40;3;0
WireConnection;2;38;19;0
WireConnection;2;44;20;0
WireConnection;2;55;21;0
WireConnection;2;39;22;0
WireConnection;13;0;49;0
WireConnection;51;1;34;0
WireConnection;51;2;52;1
WireConnection;23;40;12;0
WireConnection;23;38;24;0
WireConnection;23;44;25;0
WireConnection;23;55;26;0
WireConnection;23;39;27;0
WireConnection;48;0;40;0
WireConnection;48;1;2;0
WireConnection;48;2;47;1
WireConnection;14;0;13;1
WireConnection;33;0;23;0
WireConnection;33;1;51;0
WireConnection;0;0;48;0
WireConnection;0;1;33;0
WireConnection;0;3;13;0
WireConnection;0;4;14;0
WireConnection;0;5;13;2
ASEEND*/
//CHKSM=1FBEA1533E232870226E67F19D7CF3A8AD109DFE