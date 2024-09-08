Shader "Brave/Alpha Mask Mood Renderer" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {} // 添加默认纹理
    }
    SubShader {
        LOD 200
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

        Pass {
            // 使用标准的顶点和片段着色器
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            // 顶点着色器
            v2f vert(appdata_t v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); // 使用内置变换矩阵
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            // 片段着色器
            fixed4 frag(v2f i) : SV_Target {
                fixed4 texcol = tex2D(_MainTex, i.uv);
                // 实现 Alpha Mask 渲染逻辑
                fixed4 result = texcol * i.color;
                return result;
            }

            ENDCG
        }
    }
    Fallback "Transparent/Diffuse"
}
