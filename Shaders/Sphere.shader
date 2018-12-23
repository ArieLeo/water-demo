﻿Shader "Unlit/Sphere"
{
  Properties
  {
    _MainTex ("Texture", 2D) = "white" {}
    poolHeight ("Pool Height", Float) = 1
    sphereCenter ("Sphere Center", Vector) = (0, 0, 0, 0)
    sphereRadius ("Sphere Radius", Float) = 0.25
    light ("Light", Vector) = (0, -1, 0, 0)
    water ("Water", 2D) = "black" {}
  }
  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 100

    Pass
    {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      // make fog work
      #pragma multi_compile_fog

      #include "UnityCG.cginc"
      #include "HelperFunctions.cginc"

      struct appdata
      {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
      };

      struct v2f
      {
        float2 uv : TEXCOORD0;
        UNITY_FOG_COORDS(1)
        float4 vertex : SV_POSITION;
        float3 position : TEXCOORD1;
      };

      sampler2D _MainTex;
      float4 _MainTex_ST;

      v2f vert (appdata v)
      {
        v2f o;
        o.position = sphereCenter + v.vertex.xyz * sphereRadius;
        // o.vertex = UnityObjectToClipPos(v.vertex);
        o.vertex = UnityObjectToClipPos(o.position);
        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        // UNITY_TRANSFER_FOG(o,o.vertex);
        return o;
      }

      fixed4 frag (v2f i) : SV_Target
      {
        // sample the texture
        // fixed4 col = tex2D(_MainTex, i.uv);

        fixed4 col = fixed4(getSphereColor(i.position), 1.0);
        fixed4 info = tex2D(water, i.position.xz * 0.5 + 0.5);
        if (i.position.y < info.r) {
          col.rgb *= underwaterColor * 1.2;
        }
        // apply fog
        // UNITY_APPLY_FOG(i.fogCoord, col);
        return col;
      }
      ENDCG
    }
  }
}
