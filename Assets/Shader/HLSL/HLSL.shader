Shader "Learn/HLSL" {
    Properties {
        _Color_ ("Color", Color) = (0, 0, 0, 0)
        _Light_ ("Light", Vector) = (0, 0, 0)
    }
    SubShader {
        HLSLINCLUDE
            // 在此编写要共享的 HLSL 代码
            #include "UnityShaderVariables.cginc"
            float3 _Light_;
            float4 _Color_;
        ENDHLSL
        Pass {
            // 在此编写设置渲染状态的 ShaderLab 命令
            HLSLPROGRAM
                // 此 HLSL 着色器程序自动包含上面的HLSLINCLUDE块的内容
                // 在此编写 HLSL 着色器代码，需要自己include需要的库
                #pragma vertex Vertex
                #pragma fragment Fragment
                
                struct Attribute {
                    float4 VtxPos : POSITION;
                    float2 UV : TEXCOORD0;
                    float3 Normal : NORMAL;
                };
        
                struct V2F {
                    float4 VtxPos : SV_POSITION;
                    float2 UV : TEXCOORD0;
                    float3 Normal : NORMAL;
                };
                
                V2F Vertex(Attribute _Attr) {
                    V2F v2f;
                    v2f.VtxPos = mul(UNITY_MATRIX_MVP, _Attr.VtxPos);
                    v2f.UV = _Attr.UV;
                    v2f.Normal = _Attr.Normal;
                    return v2f;
                }
        
                float4 Fragment(V2F _V2F) : SV_Target {
                    float4 color = mul(_V2F.Normal, _Light_) * _Color_;
                    return color;
                }
            ENDHLSL
        }
    }
}
