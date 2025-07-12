Shader "Learn/Shader" { // Shader名称
  Properties {
    // 属性语法：属性名称("显示名称", 参数类型) = 默认值
    // 使用时需要在Pass中声明相同类型、名称的变量
    _float("Float", Float) = 0.0  // 浮点数
    _Range("Range", Range(0.0, 1.0)) = 0.0  // 
    _Vector("Vector", Vector) = (1, 1, 1)  // 向量
    _Color("Color", Color) = (0.5, 0.5, 0.5, 0.5) // 颜色
    _Texture("Texture", 2D) = "black"{} // 贴图
  }
  // SubShader可以有多个，显卡运行效果时从第一个SubShader开始
  //如果一个SubShader无法运行完成，自动运行下一个SubShader
  SubShader {
    // 理解为一个GPU渲染管线
    // 在这里完成：获取模型数据；顶点Shader；图元装配及光栅化；片段Shader；输出合并等
    Pass {
      CGPROGRAM
        #pragma vertex Vert // 指定顶点Shader名称为vert
        #pragma fragment Frag // 指定片段Shader名称为frag
        #include "UnityCG.cginc"

        float3 _Vector;
        float4 _Color;
        
        // 输入数据的结构体
        struct Appdata {
          // 属性语法：属性类型 属性名称 : 特点语义词
          float4 Vertex : POSITION;
          float2 UV : TEXCOORD0;
          float3 Normal : NORMAL;
        };

        // 顶点Shader传递给片段着色器的结构体
        struct V2F {
          float4 Vertex : SV_POSITION;
          float2 UV : TEXCOORD0;
          float3 Normal : NORMAL;
        };

        // 顶点Shader
        V2F Vert(Appdata _data) {
          V2F v2f;
          float4 pos_world = mul(unity_ObjectToWorld, _data.Vertex);  // 模型转世界
          float4 pos_view = mul(unity_MatrixV, pos_world);  // 世界转视口
          float4 pos_clip = mul(UNITY_MATRIX_P, pos_view);  // 视口转裁剪
          // 等价于
          float4 pos = mul(unity_MatrixMVP, _data.Vertex);
          v2f.Vertex = pos;
          v2f.UV = _data.UV;
          v2f.Normal = _data.Normal;
          return v2f;
        }

        // 片段Shader
        float4 Frag(V2F _v2f) : SV_Target { // 渲染的目标SV_Target
          float4 color = dot(_v2f.Normal, _Vector) * _Color;
          return color;
        }
      ENDCG
    }
  }
}