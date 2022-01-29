// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PostEffect"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Transi("Transi", Range( 0 , 1)) = 0
		_RTLeft("RT Left", 2D) = "white" {}
		_RTRight("RT Right", 2D) = "white" {}
		_PolynomialSmooth("Polynomial Smooth", Range( 0 , 1)) = 0.1301147
		_StepShape("Step Shape", Range( 0 , 1)) = 0.2749459
		_HardnessShape("Hardness Shape", Range( 0 , 1)) = 0.1726097
		_StepColor("Step Color", Range( 0 , 1)) = 0
		_HardnessColor("Hardness Color", Range( 0 , 1)) = 0
		_eyeCloud("eyeCloud", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Saturation("Saturation", Float) = 0
		_Luminosity("Luminosity", Float) = 0.12
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _RTLeft;
			uniform float _Transi;
			uniform float _StepColor;
			uniform float _HardnessColor;
			uniform float _StepShape;
			uniform float _HardnessShape;
			uniform float _PolynomialSmooth;
			uniform sampler2D _RTRight;
			uniform float _Luminosity;
			uniform sampler2D _TextureSample0;
			uniform sampler2D _eyeCloud;
			uniform float4 _eyeCloud_ST;
			uniform float _Saturation;
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float4 color342 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 appendResult29 = (float2(ase_screenPosNorm.xy));
				float2 screenPos82 = appendResult29;
				float2 lerpResult286 = lerp( float2( 0,0 ) , float2( 0.25,0 ) , _Transi);
				float2 temp_cast_1 = (_StepColor).xx;
				float2 temp_cast_2 = (( _StepColor + _HardnessColor )).xx;
				float4 _L2 = float4(1.77,1,-0.33,0);
				float2 appendResult40 = (float2(_L2.x , _L2.y));
				float2 appendResult41 = (float2(_L2.z , _L2.w));
				float2 temp_output_35_0 = (screenPos82*appendResult40 + appendResult41);
				float2 lerpResult260 = lerp( float2( 0.2,0.5 ) , float2( 0.05,0.5 ) , _Transi);
				float temp_output_238_0 = distance( temp_output_35_0 , lerpResult260 );
				float2 lerpResult261 = lerp( float2( 0.8,0.5 ) , float2( 1.05,0.5 ) , _Transi);
				float temp_output_239_0 = distance( temp_output_35_0 , lerpResult261 );
				float2 appendResult253 = (float2(temp_output_238_0 , temp_output_239_0));
				float2 smoothstepResult256 = smoothstep( temp_cast_1 , temp_cast_2 , appendResult253);
				float temp_output_271_0 = ( max( ( _PolynomialSmooth - abs( ( temp_output_238_0 - temp_output_239_0 ) ) ) , 0.0 ) / _PolynomialSmooth );
				float temp_output_268_0 = ( min( temp_output_238_0 , temp_output_239_0 ) - ( temp_output_271_0 * temp_output_271_0 * _PolynomialSmooth * 0.25 ) );
				float smoothstepResult247 = smoothstep( _StepShape , ( _StepShape + _HardnessShape ) , temp_output_268_0);
				float temp_output_248_0 = ( 1.0 - smoothstepResult247 );
				float2 temp_output_254_0 = ( ( 1.0 - smoothstepResult256 ) * temp_output_248_0 );
				float2 break255 = temp_output_254_0;
				float4 lerpResult341 = lerp( color342 , tex2D( _RTLeft, (screenPos82*float2( 1,1 ) + lerpResult286) ) , break255.x);
				float2 lerpResult288 = lerp( float2( 0,0 ) , float2( -0.25,0 ) , _Transi);
				float4 lerpResult343 = lerp( color342 , tex2D( _RTRight, (screenPos82*float2( 1,1 ) + lerpResult288) ) , break255.y);
				float lerpResult282 = lerp( 0.75 , 1.0 , _Transi);
				float4 temp_cast_3 = (lerpResult282).xxxx;
				float grayscale357 = Luminance(float3( temp_output_254_0 ,  0.0 ));
				float temp_output_362_0 = ( ( 1.0 - step( grayscale357 , 0.0 ) ) - temp_output_248_0 );
				float4 color350 = IsGammaSpace() ? float4(0.02951098,0.09433961,0.01379494,0) : float4(0.002284132,0.009166724,0.00106772,0);
				float temp_output_296_0 = frac( ( temp_output_268_0 * 13.0 ) );
				float blendOpSrc340 = temp_output_296_0;
				float blendOpDest340 = ( 1.0 - temp_output_296_0 );
				float temp_output_320_0 = ( ( 1.0 - temp_output_268_0 ) * ( saturate( min( blendOpSrc340 , blendOpDest340 ) )) );
				float2 uv_eyeCloud = i.uv.xy * _eyeCloud_ST.xy + _eyeCloud_ST.zw;
				float blendOpSrc309 = temp_output_320_0;
				float blendOpDest309 = tex2D( _eyeCloud, uv_eyeCloud ).r;
				float2 appendResult312 = (float2(( saturate( ( 0.5 - 2.0 * ( blendOpSrc309 - 0.5 ) * ( blendOpDest309 - 0.5 ) ) )) , 0.0));
				float3 desaturateInitialColor316 = tex2D( _TextureSample0, appendResult312 ).rgb;
				float desaturateDot316 = dot( desaturateInitialColor316, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar316 = lerp( desaturateInitialColor316, desaturateDot316.xxx, _Saturation );
				

				finalColor = ( ( ( (float4( 0,0,0,0 ) + (( ( lerpResult341 * break255.x ) + ( lerpResult343 * break255.y ) ) - float4( 0,0,0,0 )) * (temp_cast_3 - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) * temp_output_248_0 ) + ( ( ( 1.0 - (0.0 + (temp_output_362_0 - 0.6) * (1.0 - 0.0) / (1.3 - 0.6)) ) * temp_output_362_0 ) * color350 ) ) + ( step( temp_output_248_0 , 0.0 ) * ( (0.0 + (temp_output_320_0 - 0.5) * (1.0 - 0.0) / (0.0 - 0.5)) * CalculateContrast(_Luminosity,float4( desaturateVar316 , 0.0 )) ) ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18912
1982;106;1779;964;-2375.231;1445.807;1;True;False
Node;AmplifyShaderEditor.ScreenPosInputsNode;24;-3844.597,-2428.858;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;29;-3637.969,-2408.257;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;39;-3037.73,-1841.681;Inherit;False;Constant;_L2;L 2;5;0;Create;True;0;0;0;False;0;False;1.77,1,-0.33,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-3502.96,-2417.685;Inherit;False;screenPos;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;264;-2705.006,-1370.998;Inherit;False;Property;_Transi;Transi;0;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-2804.731,-1751.682;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;241;-2547.182,-1544.575;Inherit;False;Constant;_Dist1;Dist 1;7;0;Create;True;0;0;0;False;0;False;0.05,0.5;0.05,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;262;-2551.135,-1225.326;Inherit;False;Constant;_Vector2;Vector 2;6;0;Create;True;0;0;0;False;0;False;0.8,0.5;0.8,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;263;-2541.779,-1680.852;Inherit;False;Constant;_Vector1;Vector 1;8;0;Create;True;0;0;0;False;0;False;0.2,0.5;0.2,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;40;-2818.731,-1851.681;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-2752.668,-2152.249;Inherit;False;82;screenPos;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;242;-2540.374,-1087.385;Inherit;False;Constant;_Dist2;Dist 2;5;0;Create;True;0;0;0;False;0;False;1.05,0.5;1.05,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;260;-2208.698,-1485.489;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;35;-2516.793,-1871.162;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;261;-2088.695,-1231.525;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;238;-1855.187,-1549.696;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;239;-1843.673,-1280.275;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;274;-1890.341,-807.8812;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;269;-1655.642,-906.9919;Inherit;False;Property;_PolynomialSmooth;Polynomial Smooth;3;0;Create;True;0;0;0;False;0;False;0.1301147;0.034;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;273;-1483.729,-753.8839;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;265;-1296.476,-953.769;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;272;-1125.325,-856.8912;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;266;-985.7623,-571.0492;Inherit;False;Constant;_Float5;Float 5;8;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;271;-968.7744,-755.1986;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;249;-4.258977,-923.91;Inherit;False;Property;_StepShape;Step Shape;4;0;Create;True;0;0;0;False;0;False;0.2749459;0.408;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;257;-927.2673,-1263.376;Inherit;False;Property;_HardnessColor;Hardness Color;7;0;Create;True;0;0;0;False;0;False;0;0.301;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;-930.2603,-1391.274;Inherit;False;Property;_StepColor;Step Color;6;0;Create;True;0;0;0;False;0;False;0;0.369;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;251;8.340482,-785.0284;Inherit;False;Property;_HardnessShape;Hardness Shape;5;0;Create;True;0;0;0;False;0;False;0.1726097;0.025;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;270;-756.6174,-697.6114;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;267;-1248.963,-1202.124;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;258;-285.474,-1362.492;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;253;-1383.08,-1596.3;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;250;330.4933,-882.1465;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;268;-340.5332,-1128.71;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;256;-80.19012,-1545.894;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;297;-478.4709,-326.4253;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;13;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;247;511.8477,-1133.657;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;296;-330.5295,-187.0005;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;248;780.0595,-1136.605;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;280;581.1111,-1805.651;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;231;-1730.326,-1920.135;Inherit;False;Constant;_2;2;4;0;Create;True;0;0;0;False;0;False;-0.25,0;-0.25,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;254;1055.205,-1397.112;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;229;-1591.313,-2401.249;Inherit;False;Constant;_1;1;3;0;Create;True;0;0;0;False;0;False;0.25,0;0.25,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;339;-282.5797,62.87231;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;357;1901.485,-989.3484;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;286;-1386.378,-2428.131;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;321;-184.4133,-355.3859;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;340;-74.57971,2.872314;Inherit;True;Darken;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;288;-1409.774,-1920.098;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;230;-1236.213,-2054.588;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;320;-14.83197,-308.3086;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;227;-1170.462,-2594.093;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;308;-53.17979,241.5893;Inherit;True;Property;_eyeCloud;eyeCloud;8;0;Create;True;0;0;0;False;0;False;-1;c2ffc68514112214ca67d8d852cb3bb8;c2ffc68514112214ca67d8d852cb3bb8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;359;2153.589,-961.1827;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-842.7546,-2109.573;Inherit;True;Property;_RTRight;RT Right;2;0;Create;True;0;0;0;False;0;False;-1;None;ca88cc159153169419e45a74f2075a73;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;255;1380.758,-1455.498;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;361;2409.71,-965.2735;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-815.3149,-2593.264;Inherit;True;Property;_RTLeft;RT Left;1;0;Create;True;0;0;0;False;0;False;-1;55fdb60583a671f42bf659f5e7facfa0;638ce794f973974438c09159157b34aa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;342;1249.595,-2548.479;Inherit;False;Constant;_Color0;Color 0;12;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;309;289.4052,164.4654;Inherit;True;Exclusion;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;312;641.4755,65.49591;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;343;1745.019,-2037.163;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;341;1706.021,-2474.53;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;362;2666.354,-1124.234;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;346;2670.409,-2040.404;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;310;760.4362,-249.2892;Inherit;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;0;False;0;False;-1;82974a8d6d1b67d4d981e1754fba04d5;82974a8d6d1b67d4d981e1754fba04d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;284;2845.992,-1771.63;Inherit;False;Constant;_Float0;Float 0;19;0;Create;True;0;0;0;False;0;False;0.75;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;317;940.7005,14.20239;Inherit;False;Property;_Saturation;Saturation;10;0;Create;True;0;0;0;False;0;False;0;-14.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;369;2877.231,-1262.807;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.6;False;2;FLOAT;1.3;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;2750.992,-1684.63;Inherit;False;Constant;_Float4;Float 4;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;2612.321,-2384.438;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;316;1178.781,-153.8301;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT;-2.8;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;282;2978.282,-1672.628;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;226;2965.773,-2216.148;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;319;1294.67,135.1183;Inherit;False;Property;_Luminosity;Luminosity;11;0;Create;True;0;0;0;False;0;False;0.12;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;366;3061.544,-1193.137;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;367;3200.652,-1089.953;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;323;1508.378,-437.1489;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;350;2859.802,-869.8887;Inherit;False;Constant;_Color1;Color 1;12;0;Create;True;0;0;0;False;0;False;0.02951098,0.09433961,0.01379494,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;281;3204.276,-2098.314;Inherit;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;318;1498.67,-97.88165;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;344;3328.382,-1565.347;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;349;3473.164,-969.7562;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;322;1864.38,-148.2388;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;305;1545.456,-783.3518;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;2385.11,-494.6737;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;353;3701.502,-1382.009;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;302;4079.977,-1168.833;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;27;4262.977,-1846.692;Float;False;True;-1;2;ASEMaterialInspector;0;2;PostEffect;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;29;0;24;0
WireConnection;82;0;29;0
WireConnection;41;0;39;3
WireConnection;41;1;39;4
WireConnection;40;0;39;1
WireConnection;40;1;39;2
WireConnection;260;0;263;0
WireConnection;260;1;241;0
WireConnection;260;2;264;0
WireConnection;35;0;83;0
WireConnection;35;1;40;0
WireConnection;35;2;41;0
WireConnection;261;0;262;0
WireConnection;261;1;242;0
WireConnection;261;2;264;0
WireConnection;238;0;35;0
WireConnection;238;1;260;0
WireConnection;239;0;35;0
WireConnection;239;1;261;0
WireConnection;274;0;238;0
WireConnection;274;1;239;0
WireConnection;273;0;274;0
WireConnection;265;0;269;0
WireConnection;265;1;273;0
WireConnection;272;0;265;0
WireConnection;271;0;272;0
WireConnection;271;1;269;0
WireConnection;270;0;271;0
WireConnection;270;1;271;0
WireConnection;270;2;269;0
WireConnection;270;3;266;0
WireConnection;267;0;238;0
WireConnection;267;1;239;0
WireConnection;258;0;259;0
WireConnection;258;1;257;0
WireConnection;253;0;238;0
WireConnection;253;1;239;0
WireConnection;250;0;249;0
WireConnection;250;1;251;0
WireConnection;268;0;267;0
WireConnection;268;1;270;0
WireConnection;256;0;253;0
WireConnection;256;1;259;0
WireConnection;256;2;258;0
WireConnection;297;0;268;0
WireConnection;247;0;268;0
WireConnection;247;1;249;0
WireConnection;247;2;250;0
WireConnection;296;0;297;0
WireConnection;248;0;247;0
WireConnection;280;0;256;0
WireConnection;254;0;280;0
WireConnection;254;1;248;0
WireConnection;339;0;296;0
WireConnection;357;0;254;0
WireConnection;286;1;229;0
WireConnection;286;2;264;0
WireConnection;321;0;268;0
WireConnection;340;0;296;0
WireConnection;340;1;339;0
WireConnection;288;1;231;0
WireConnection;288;2;264;0
WireConnection;230;0;83;0
WireConnection;230;2;288;0
WireConnection;320;0;321;0
WireConnection;320;1;340;0
WireConnection;227;0;83;0
WireConnection;227;2;286;0
WireConnection;359;0;357;0
WireConnection;5;1;230;0
WireConnection;255;0;254;0
WireConnection;361;0;359;0
WireConnection;4;1;227;0
WireConnection;309;0;320;0
WireConnection;309;1;308;1
WireConnection;312;0;309;0
WireConnection;343;0;342;0
WireConnection;343;1;5;0
WireConnection;343;2;255;1
WireConnection;341;0;342;0
WireConnection;341;1;4;0
WireConnection;341;2;255;0
WireConnection;362;0;361;0
WireConnection;362;1;248;0
WireConnection;346;0;343;0
WireConnection;346;1;255;1
WireConnection;310;1;312;0
WireConnection;369;0;362;0
WireConnection;345;0;341;0
WireConnection;345;1;255;0
WireConnection;316;0;310;0
WireConnection;316;1;317;0
WireConnection;282;0;284;0
WireConnection;282;1;285;0
WireConnection;282;2;264;0
WireConnection;226;0;345;0
WireConnection;226;1;346;0
WireConnection;366;0;369;0
WireConnection;367;0;366;0
WireConnection;367;1;362;0
WireConnection;323;0;320;0
WireConnection;281;0;226;0
WireConnection;281;4;282;0
WireConnection;318;1;316;0
WireConnection;318;0;319;0
WireConnection;344;0;281;0
WireConnection;344;1;248;0
WireConnection;349;0;367;0
WireConnection;349;1;350;0
WireConnection;322;0;323;0
WireConnection;322;1;318;0
WireConnection;305;0;248;0
WireConnection;300;0;305;0
WireConnection;300;1;322;0
WireConnection;353;0;344;0
WireConnection;353;1;349;0
WireConnection;302;0;353;0
WireConnection;302;1;300;0
WireConnection;27;0;302;0
ASEEND*/
//CHKSM=E39650DD55DA71FC25FC04F01F13CB6B59049ECD