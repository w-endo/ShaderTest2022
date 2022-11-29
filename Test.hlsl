Texture2D tex : register(t0);
SamplerState smp : register(s0);

Texture2D texToon : register(t1);

cbuffer gloabl
{
	float4x4 matWVP;
	float4x4 matNormal;
	float4x4 matW;
	float4	 color;
	float4	 camPos;
	bool	 isTexture;
};

struct VS_OUT
{
	float4 pos : SV_POSITION;
	float2 uv  : TEXCOORD;
	float4 normal : NORMAL;
	float4 V : TEXCOORD1;
};

//頂点シェーダー
VS_OUT VS(float4 pos : POSITION, float4 uv : TEXCOORD, float4 normal : NORMAL)
{
	VS_OUT outData;
	outData.pos = mul(pos, matWVP);
	outData.uv = uv;


	normal.w = 0;
	outData.normal = mul(normal, matNormal);
	outData.normal = normalize(outData.normal);

	outData.V = normalize(mul(pos, matW) - camPos);

	return outData;
}

//ピクセルシェーダー
float4 PS(VS_OUT inData) : SV_TARGET
{
	float4 diffuse;
	float4 ambient;
	float4 specular;

	float4 light = float4(1, 1, -1, 0);
	light = normalize(light);

	float4 S = dot(inData.normal, light);
	S = clamp(S, 0, 1);

	float2 uv;
	uv.x = S;
	uv.y = 0;
	//return texToon.Sample(smp, uv);



	float4 R = reflect(light, inData.normal);
	specular = pow(clamp(dot(R, inData.V), 0, 1), 10) * 3;

	if (isTexture)
	{
		diffuse = tex.Sample(smp, inData.uv) * texToon.Sample(smp, uv);
		ambient = tex.Sample(smp, inData.uv) * 0.2;
	}
	else
	{
		diffuse = color * texToon.Sample(smp, uv);
		ambient = color * 0.2;
	}

	return diffuse /*+ ambient*/ + specular;
}