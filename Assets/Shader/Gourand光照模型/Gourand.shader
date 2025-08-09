Shader "Learn/Gourand"
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
                    float3 Color : COLOR;
                };
            
                V2F Vertex(Attribute _Attr) {
                    V2F v2f;
                    v2f.VtxPos = UnityObjectToClipPos(_Attr.VtxPos);
                    float3 vtxPosWorld = UnityObjectToWorldDir(_Attr.VtxPos);
                    float3 normalWorld = UnityObjectToWorldNormal(_Attr.Normal);
                    float3 baseColor = tex2Dlod(_BaseColor_, float4(_Attr.UV, 0, 0)).rgb;
                    // 环境光
                    float3 ambient = baseColor * _Ambient_;
                    // 漫反射
                    float3 diffuse = baseColor * dot(normalize(_WorldSpaceLightPos0), normalWorld);
                    // 高光反射
                    float3 v = normalize(vtxPosWorld - _WorldSpaceCameraPos);  // 视线光
                    float3 r = normalize(reflect(_WorldSpaceLightPos0, normalWorld)); // 反射光
                    float3 specular = _SpecularColor_ * pow(max(0.0, dot(v, r)), _Glossiness_);
                    v2f.Color = ambient + _LightColor_ * ( diffuse + specular );
                    return v2f;
                }
            
                float3 Fragment(V2F _V2F) : SV_Target {
                    return _V2F.Color;
                }
            ENDHLSL
        }
        
    }
}
