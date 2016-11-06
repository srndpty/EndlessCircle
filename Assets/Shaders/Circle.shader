Shader "Custom/Circle"
{
	Properties
	{
		_MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		_MipLevel("Mip Level", Float)  = 0
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
			};
			
			fixed4 _Color;
			sampler2D _MainTex;
			half _MipLevel;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;

				return OUT;
			}

			// taken from: http://www.chilliant.com/rgb2hsv.html
			float3 HUEtoRGB(in float H)
			{
				float R = abs(H * 6 - 3) - 1;
				float G = 2 - abs(H * 6 - 2);
				float B = 2 - abs(H * 6 - 4);
				return saturate(float3(R, G, B));
			}

			float3 HSVtoRGB(in float3 HSV)
			{
				float3 RGB = HUEtoRGB(HSV.x);
				return ((RGB - 1) * HSV.y + 1) * HSV.z;
			}

			fixed4 frag(v2f IN) : SV_Target
			{
				fixed4 c = tex2D(_MainTex, IN.texcoord) * IN.color;

				int factor = pow(2, _MipLevel);
				half coeff = _ScreenParams.y / 120000.0 * factor;
				// shape circle by clipping
				//clip(-distance(0.5, IN.texcoord) + 0.5);
				//clip(distance(0.5, IN.texcoord) - 0.5 + coeff);

				// shape circle by alpha
				c.a *= 1 - saturate(abs(distance(0.5, IN.texcoord) + coeff - 0.5) - 0.1 * coeff) * 300 / factor;

				// neon
				//c.rgb *= HSVtoRGB(float3(frac(_Time.y + _MipLevel * 0.18), 1, 1));
				
				// rainbow
				//c.rgb *= HSVtoRGB(float3((atan2(IN.texcoord.y - 0.5, IN.texcoord.x - 0.5) + 3.14159) / 6.283, 1, 1));

				return c;
			}
		ENDCG
		}
	}
}
