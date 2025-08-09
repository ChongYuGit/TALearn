Shader "Learn/FlowMap"
{
    Properties
    {
        _BaseColor_ ("BaseColor", 2D) = "black" {}
        _FlowMap_ ("FLowMap", 2D) = "black" {}
    }
    SubShader
    {
        Pass {
            HLSLPROGRAM
                #include "UnityCG.cginc"
                #pragma vertex Vertex
                #pragma fragment Fragment
                sampler2D _BaseColor_;
                sampler2D _FlowMap_;

                struct Attribute {
                    float4 VtxPos : POSITION;
                    float2 UV : TEXCOORD0;
                };
                
                struct V2F {
                    float4 VtxPos : SV_POSITION;
                    float2 UV : TEXCOORD0;
                };
            
                V2F Vertex(Attribute _Attr) {
                    V2F v2f;
                    v2f.VtxPos = UnityObjectToClipPos(_Attr.VtxPos);
                    v2f.UV = _Attr.UV;
                    return v2f;
                }
            
                float3 Fragment(V2F _V2F) : SV_Target {
                    float time = _Time.g * 0.1;
                    float2 flow = tex2D(_FlowMap_, _V2F.UV).rg * 2.0 - 1.0;
                    float2 uv1 = _V2F.UV + flow * frac(time);   // FlowMap偏移UV
                    float2 uv2 = _V2F.UV + flow * frac(time + 0.5);
                    float3 color1 = tex2D(_BaseColor_, uv1);
                    float3 color2 = tex2D(_BaseColor_, uv2);
                    float3 baseColor = lerp(color1, color2, abs(frac(time) - 0.5) / 0.5);   // 循环
                    
                    float3 color = baseColor;
                    return color;
                }
            ENDHLSL
        }
        
    }
}
