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
		_StepShape("Step Shape", Range( 0 , 1)) = 0
		_HardnessShape("Hardness Shape", Range( 0 , 1)) = 0
		_StepColor("Step Color", Range( 0 , 1)) = 0
		_HardnessColor("Hardness Color", Range( 0 , 1)) = 0

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
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 appendResult29 = (float2(ase_screenPosNorm.xy));
				float2 screenPos82 = appendResult29;
				float2 lerpResult286 = lerp( float2( 0,0 ) , float2( 0.25,0 ) , _Transi);
				float temp_output_295_0 = saturate( ( _StepColor + ( 1.0 - _Transi ) ) );
				float2 temp_cast_1 = (temp_output_295_0).xx;
				float2 temp_cast_2 = (( temp_output_295_0 + _HardnessColor )).xx;
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
				float smoothstepResult247 = smoothstep( _StepShape , ( _StepShape + _HardnessShape ) , ( min( temp_output_238_0 , temp_output_239_0 ) - ( temp_output_271_0 * temp_output_271_0 * _PolynomialSmooth * 0.25 ) ));
				float2 break255 = ( ( 1.0 - smoothstepResult256 ) * ( 1.0 - smoothstepResult247 ) );
				float2 lerpResult288 = lerp( float2( 0,0 ) , float2( -0.25,0 ) , _Transi);
				float lerpResult282 = lerp( 0.5 , 1.0 , _Transi);
				float4 temp_cast_3 = (lerpResult282).xxxx;
				

				finalColor = (float4( 0,0,0,0 ) + (( ( tex2D( _RTLeft, (screenPos82*float2( 1,1 ) + lerpResult286) ) * break255.x ) + ( tex2D( _RTRight, (screenPos82*float2( 1,1 ) + lerpResult288) ) * break255.y ) ) - float4( 0,0,0,0 )) * (temp_cast_3 - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 )));

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18912
196;687;1399;778;3267.934;1710.613;1.3;True;False
Node;AmplifyShaderEditor.ScreenPosInputsNode;24;-3844.597,-2428.858;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;29;-3637.969,-2408.257;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;39;-3037.73,-1841.681;Inherit;False;Constant;_L2;L 2;5;0;Create;True;0;0;0;False;0;False;1.77,1,-0.33,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-3502.96,-2417.685;Inherit;False;screenPos;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;264;-2705.006,-1370.998;Inherit;False;Property;_Transi;Transi;0;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-2752.668,-2152.249;Inherit;False;82;screenPos;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-2818.731,-1851.681;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;263;-2541.779,-1680.852;Inherit;False;Constant;_Vector1;Vector 1;8;0;Create;True;0;0;0;False;0;False;0.2,0.5;0.2,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;241;-2547.182,-1544.575;Inherit;False;Constant;_Dist1;Dist 1;7;0;Create;True;0;0;0;False;0;False;0.05,0.5;0.05,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;262;-2551.135,-1225.326;Inherit;False;Constant;_Vector2;Vector 2;6;0;Create;True;0;0;0;False;0;False;0.8,0.5;0.8,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;242;-2540.374,-1087.385;Inherit;False;Constant;_Dist2;Dist 2;5;0;Create;True;0;0;0;False;0;False;1.05,0.5;1.05,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;41;-2804.731,-1751.682;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;261;-2088.695,-1231.525;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;260;-2208.698,-1485.489;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;35;-2516.793,-1871.162;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;238;-1855.187,-1549.696;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;239;-1843.673,-1280.275;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;274;-1890.341,-807.8812;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;269;-1655.642,-906.9919;Inherit;False;Property;_PolynomialSmooth;Polynomial Smooth;3;0;Create;True;0;0;0;False;0;False;0.1301147;0.233;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;273;-1483.729,-753.8839;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;265;-1296.476,-953.769;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;-930.2603,-1391.274;Inherit;False;Property;_StepColor;Step Color;6;0;Create;True;0;0;0;False;0;False;0;0.205;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;294;-1080.746,-1338.484;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;272;-1125.325,-856.8912;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;271;-968.7744,-755.1986;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;293;-572.2383,-1384.369;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;266;-985.7623,-571.0492;Inherit;False;Constant;_Float5;Float 5;8;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;270;-756.6174,-697.6114;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;249;-4.258977,-923.91;Inherit;False;Property;_StepShape;Step Shape;4;0;Create;True;0;0;0;False;0;False;0;0.248;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;295;-439.7821,-1407.038;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;267;-1248.963,-1202.124;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;257;-927.2673,-1263.376;Inherit;False;Property;_HardnessColor;Hardness Color;7;0;Create;True;0;0;0;False;0;False;0;0.367;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;251;8.340482,-785.0284;Inherit;False;Property;_HardnessShape;Hardness Shape;5;0;Create;True;0;0;0;False;0;False;0;0.12;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;250;330.4933,-882.1465;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;253;-1383.08,-1596.3;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;258;-285.474,-1362.492;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;268;-257.0983,-1153.741;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;229;-1591.313,-2401.249;Inherit;False;Constant;_1;1;3;0;Create;True;0;0;0;False;0;False;0.25,0;0.25,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;231;-1730.326,-1920.135;Inherit;False;Constant;_2;2;4;0;Create;True;0;0;0;False;0;False;-0.25,0;-0.25,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;247;511.8477,-1133.657;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;256;-80.19012,-1545.894;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;280;217.1871,-1534.237;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;286;-1386.378,-2428.131;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;288;-1409.774,-1920.098;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;248;780.0595,-1136.605;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;254;1076.98,-1280.979;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;227;-1170.462,-2594.093;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;230;-1236.213,-2054.588;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;4;-815.3149,-2593.264;Inherit;True;Property;_RTLeft;RT Left;1;0;Create;True;0;0;0;False;0;False;-1;55fdb60583a671f42bf659f5e7facfa0;638ce794f973974438c09159157b34aa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;255;1273.698,-1531.71;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;5;-842.7546,-2109.573;Inherit;True;Property;_RTRight;RT Right;2;0;Create;True;0;0;0;False;0;False;-1;None;ca88cc159153169419e45a74f2075a73;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;1605.948,-2139.239;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;284;2002.204,-1788.476;Inherit;False;Constant;_Float0;Float 0;19;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;1906.204,-1701.476;Inherit;False;Constant;_Float4;Float 4;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;237;1621.592,-1874.797;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;226;1964.957,-2122.781;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;282;2133.494,-1689.474;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;281;2360.859,-2115.161;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;27;2592.987,-2114.171;Float;False;True;-1;2;ASEMaterialInspector;0;2;PostEffect;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;29;0;24;0
WireConnection;82;0;29;0
WireConnection;40;0;39;1
WireConnection;40;1;39;2
WireConnection;41;0;39;3
WireConnection;41;1;39;4
WireConnection;261;0;262;0
WireConnection;261;1;242;0
WireConnection;261;2;264;0
WireConnection;260;0;263;0
WireConnection;260;1;241;0
WireConnection;260;2;264;0
WireConnection;35;0;83;0
WireConnection;35;1;40;0
WireConnection;35;2;41;0
WireConnection;238;0;35;0
WireConnection;238;1;260;0
WireConnection;239;0;35;0
WireConnection;239;1;261;0
WireConnection;274;0;238;0
WireConnection;274;1;239;0
WireConnection;273;0;274;0
WireConnection;265;0;269;0
WireConnection;265;1;273;0
WireConnection;294;0;264;0
WireConnection;272;0;265;0
WireConnection;271;0;272;0
WireConnection;271;1;269;0
WireConnection;293;0;259;0
WireConnection;293;1;294;0
WireConnection;270;0;271;0
WireConnection;270;1;271;0
WireConnection;270;2;269;0
WireConnection;270;3;266;0
WireConnection;295;0;293;0
WireConnection;267;0;238;0
WireConnection;267;1;239;0
WireConnection;250;0;249;0
WireConnection;250;1;251;0
WireConnection;253;0;238;0
WireConnection;253;1;239;0
WireConnection;258;0;295;0
WireConnection;258;1;257;0
WireConnection;268;0;267;0
WireConnection;268;1;270;0
WireConnection;247;0;268;0
WireConnection;247;1;249;0
WireConnection;247;2;250;0
WireConnection;256;0;253;0
WireConnection;256;1;295;0
WireConnection;256;2;258;0
WireConnection;280;0;256;0
WireConnection;286;1;229;0
WireConnection;286;2;264;0
WireConnection;288;1;231;0
WireConnection;288;2;264;0
WireConnection;248;0;247;0
WireConnection;254;0;280;0
WireConnection;254;1;248;0
WireConnection;227;0;83;0
WireConnection;227;2;286;0
WireConnection;230;0;83;0
WireConnection;230;2;288;0
WireConnection;4;1;227;0
WireConnection;255;0;254;0
WireConnection;5;1;230;0
WireConnection;236;0;4;0
WireConnection;236;1;255;0
WireConnection;237;0;5;0
WireConnection;237;1;255;1
WireConnection;226;0;236;0
WireConnection;226;1;237;0
WireConnection;282;0;284;0
WireConnection;282;1;285;0
WireConnection;282;2;264;0
WireConnection;281;0;226;0
WireConnection;281;4;282;0
WireConnection;27;0;281;0
ASEEND*/
//CHKSM=0F1C41C323D546DF82B082C8C4A7ECE2F6780964