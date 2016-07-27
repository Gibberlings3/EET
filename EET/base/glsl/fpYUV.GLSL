uniform lowp	sampler2D	uTex;
uniform lowp	sampler2D	uTex2;
varying mediump	vec2		vTc;
varying mediump	vec2		vTcU;
varying mediump	vec2		vTcV;
varying lowp	vec4		vColor;

const lowp		vec3		off		= vec3( 0.06250,  0.50000,  0.50000 );
const lowp		vec3		dotR	= vec3( 1.00000,  0.00000,  1.28033 );
const lowp		vec3		dotG	= vec3( 1.00000, -0.21482, -0.38059 );
const lowp		vec3		dotB	= vec3( 1.00000,  2.12798,  0.00000 );

const mediump	float		Yextent			= 0.6666666;	// The extent of the Y component in the texture (V coord)
const mediump	float		epsilonPadding	= 0.001;

// For wrapping coordinates in the Y portion of YUV, we must be within [0,2/3]   
// for the V component of the texcoord.
float fracV(float y)
{
	y = y / Yextent;

	y = fract(y);
	y = y * Yextent;

	// The following is to prevent ugly lines from forming at the wrap locations
	y = min(y, Yextent - epsilonPadding);
	y = max(y, epsilonPadding);

	return y;
}

// For wrapping coordinates in the UV portion of YUV, we must be within [2/3,1]  
// for the V component of the texcoord.
float fracUV(float y)
{
	y = y - Yextent;

	y = y / (1.0-Yextent);
	y = fract(y);
	y = y * (1.0-Yextent);

	y = y + Yextent;

	// The following is to prevent ugly lines from forming at the wrap locations
	y = min(y, 1.0 - epsilonPadding);
	y = max(y, Yextent + epsilonPadding);

	return y;
}

void main()
{
	lowp vec3 yuv;

	mediump	vec2 tc = vTc;
	mediump	vec2 tcU = vTcU;
	mediump	vec2 tcV = vTcV;

	tc.y 	= fracV(tc.y);
	tcU.y 	= fracUV(tcU.y);
	tcV.y 	= fracUV(tcV.y);

	yuv.r = texture2D( uTex, tc  ).r;
	yuv.g = texture2D( uTex, tcU ).r;
	yuv.b = texture2D( uTex, tcV ).r;
	mediump vec2 vTcA = vTc;

	// Adjust y coords from our packed texture
	// to those used in our alpha texture
	vTcA.y /= Yextent;
	float a = texture2D( uTex2, vTcA).r;
	
	yuv = yuv - off;
	
	lowp float r = dot( yuv, dotR );
	lowp float g = dot( yuv, dotG );
	lowp float b = dot( yuv, dotB );

	gl_FragColor = vec4(r,g,b,a);
}
