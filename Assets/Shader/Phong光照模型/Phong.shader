Shader "Learn/Phong"
{
    Properties
    {
        _BaseColor_ ("BaseColor", 2D) = "black" {}
        _Ambient_ ("Ambient", Float) = 0.1
        _SpecularColor_ ("SpecularColor", Color) = (1, 1, 1)
        _Glossiness_ ("Glossiness", Range(0.1, 1000)) =  1
        _LightColor_ ("LightColor", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Pass {
            HLSLPROGRAM
                #include "UnityCG.cginc"
                #pragma vertex Vertex
                #pragma fragment Fragment
                sampler2D _BaseColor_;
                float _Glossiness_;
                float _Ambient_;
                float3 _SpecularColor_;
                float3 _LightColor_;

                struct Attribute {
                    float4 VtxPos : POSITION;
                    float3 Normal : NORMAL;
                    float2 UV : TEXCOORD0;
                };
                
                struct V2F {
                    float4 VtxPos : SV_POSITION;
                    float3 Normal : NORMAL;
                    float2 UV : TEXCOORD0;
                    float3 VtxPosWorld : WORLD_POSITION;
                    float3 NormalWorld : WORLD_NORMAL;
                };
            
                V2F Vertex(Attribute _Attr) {
                    V2F v2f;
                    v2f.VtxPos = UnityObjectToClipPos(_Attr.VtxPos);
                    v2f.Normal = _Attr.Normal;
                    v2f.UV = _Attr.UV;
                    v2f.VtxPosWorld = UnityObjectToWorldDir(_Attr.VtxPos);
                    v2f.NormalWorld = UnityObjectToWorldNormal(_Attr.Normal);   // 将法线变换到世界空间
                    return v2f;
                }
            
                float3 Fragment(V2F _V2F) : SV_Target {
                    float4 baseColor = tex2D(_BaseColor_, _V2F.UV);
                    // 环境光
                    float3 ambient = baseColor * _Ambient_;
                    // 漫反射
                    float3 diffuse = baseColor * dot(normalize(_WorldSpaceLightPos0), _V2F.NormalWorld);
                    // 高光反射
                    float3 v = normalize(_V2F.VtxPosWorld - _WorldSpaceCameraPos);  // 视线光
                    float3 r = normalize(reflect(_WorldSpaceLightPos0, _V2F.NormalWorld)); // 反射光
                    float3 specular = _SpecularColor_ * pow(max(0.0, dot(v, r)), _Glossiness_);
                    float3 color = ambient + _LightColor_ * ( diffuse + specular );
                    return color;
                }
            ENDHLSL
        }
        
    }
}
