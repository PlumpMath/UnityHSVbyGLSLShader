Shader "Custom/SimplyShader"
{

    Properties
    {
    	_MainTex ("Texture", 2D) = "white" {}
    	_LC("LC", Color) = (1, 0, 0, 0)
    	//_hueAdjust ("hueAdjust", Float) = 1;
     	//_hueAdjust ("hueAdjust", Float) = 1.0
     	//_hueAdjust ("X", Float) = 1.0
     	_hueAdjust ("hueAdjust", Range(-3.14159265358, 3.14159265358)) = 0.0
    }
    
	SubShader
	{
    	Tags { "Queue" = "Geometry" }
    	
		Pass
		{
			GLSLPROGRAM
			

			#ifdef VERTEX
			
			varying vec4 position;
			varying vec2 TextureCoordinate;
			void main()
			{
				//position = gl_Vertex + vec4(0.5, 0.5, 0.5, 0);
				gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
				TextureCoordinate = gl_MultiTexCoord0.xy;
			}
			
			#endif
		
			
					
			#ifdef FRAGMENT
			
			varying vec4 position;
			varying vec2 TextureCoordinate;
			
			uniform sampler2D _MainTex;
			//sampler2D _MainTex;
			uniform vec4 _LC;
			uniform float _hueAdjust;
			//float _hueAdjust;
			
			const vec4 kRGBToYPrime = vec4 (0.299, 0.587, 0.114, 0.0);
			const vec4 kRGBToI = vec4 (0.595716, -0.274453, -0.321263, 0.0);
			const vec4 kRGBToQ = vec4 (0.211456, -0.522591, 0.31135, 0.0);
			
			const vec4 kYIQToR = vec4 (1.0, 0.9563, 0.6210, 0.0);
			const vec4 kYIQToG = vec4 (1.0, -0.2721, -0.6474, 0.0);
			const vec4 kYIQToB = vec4 (1.0, -1.1070, 1.7046, 0.0);	
			
			void main()
			{
				//vec4 color   = texture2D(inputImageTexture, textureCoordinate);
				//vec4 c;
				//gl_FragColor = vec4(2.0, 1.0, 0.0, 1.0);
				//gl_FragColor = position;
				//gl_FragColor = texture2D(_MainTex, TextureCoordinate);
				//c.xyz = texture2D(_MainTex, TextureCoordinate).xyz * _LC.xyz;
				//c.w = 1.0;
				//gl_FragColor = c;
				//hueAdjust = 120.0;
				
				vec4 color = texture2D(_MainTex, TextureCoordinate);
				
				// Convert to YIQ
				float YPrime = dot (color, kRGBToYPrime);
				float I = dot (color, kRGBToI);
				float Q = dot (color, kRGBToQ);
				     
				// Calculate the hue and chroma
				float hue = atan (Q, I);
				float chroma = sqrt (I * I + Q * Q);
				     
				// Make the user's adjustments
				//hue += (-hueAdjust); //why negative rotation?
				hue = hue - _hueAdjust; //why negative rotation?
				     
				// Convert back to YIQ
				Q = chroma * sin (hue);
				I = chroma * cos (hue);
				     
				// Convert back to RGB
				vec4 yIQ = vec4 (YPrime, I, Q, 0.0);
				color.r = dot (yIQ, kYIQToR);
				color.g = dot (yIQ, kYIQToG);
				color.b = dot (yIQ, kYIQToB);
     
				// Save the result
				gl_FragColor = color;
			}
			
			#endif
			
			ENDGLSL
		}
		
		//Pass {}
	}
}