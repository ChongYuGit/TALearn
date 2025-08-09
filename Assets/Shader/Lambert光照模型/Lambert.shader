Shader"Learn/Lambert" {
  Properties {
    _BaseColor_ ("Color", 2D) = "white"{}
    _LightColor_ ("Color", Color) = (1, 1, 1)
  }
  SubShader {
    Pass {
      HLSLPROGRAM
        #include "UnityCG.cginc"
        #pragma vertex Vertex
        #pragma fragment Fragment

        sampler2D _BaseColor_;
        float3 _LightColor_;
        
        // 输入数据的结构体
        struct Attribute {
          // 属性语法：属性类型 属性名称 : 特定语义词
          float4 VtxPos : POSITION;
          float3 Normal : NORMAL;
          float2 UV : TEXCOORD0;
        };

        // 顶点Shader传递给片段着色器的结构体
        struct V2F {
          float4 VtxPos : SV_POSITION;
          float3 Normal : NORMAL;
          float2 UV : TEXCOORD0;
          float3 VtxPosWorld : WORLD_POSITION;
          float3 NormalWorld : WORLD_NORMAL;
        };

        // 顶点Shader
        V2F Vertex(Attribute _Attr) {
          V2F v2f;
          v2f.VtxPos = UnityObjectToClipPos(_Attr.VtxPos);  // MVP矩阵
          v2f.Normal = _Attr.Normal;
          v2f.UV = _Attr.UV;
          v2f.VtxPosWorld = UnityObjectToWorldDir(_Attr.VtxPos);
          v2f.NormalWorld = UnityObjectToWorldNormal(_Attr.Normal);
          return v2f;
        }

        // 片段Shader
        float3 Fragment(V2F _V2F) : SV_Target { // 渲染的目标SV_Target
          float3 color =  _LightColor_ * tex2D(_BaseColor_, _V2F.UV) * dot(_WorldSpaceLightPos0, _V2F.NormalWorld);
          return color;
        }
      ENDHLSL
    }
  }
}