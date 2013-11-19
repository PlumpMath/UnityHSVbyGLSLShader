Shader "Custom/SimplyShader"
{

    Properties
    {
    	_MainTex ("Texture", 2D) = "white" {}
    }
	    
	SubShader
	{
		Pass
		{
			GLSLPROGRAM
			

			#ifdef VERTEX
			
			varying vec4 position;	
			void main()
			{
				position = gl_Vertex + vec4(0.5, 0.5, 0.5, 0);
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
			}
			
			#endif
		
			
					
			#ifdef FRAGMENT
			
			varying vec4 position;	
			void main()
			{
				//gl_FragColor = vec4(2.0, 1.0, 0.0, 1.0);
				gl_FragColor = position;
			}
			
			#pragma surface surf Lambert
			struct Input
			{
				float uv_MainTex;
			};
			//sampler2D _MainTex;
			//void surf (Input IN, inout SurfaceOutput o)
			//{
			//	o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb + gl_FragColor;
			//}
			
			#endif
			
			ENDGLSL
		}
	}
}