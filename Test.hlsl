Texture2D tex : register(t0);
SamplerState smp : register(s0);

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
	float4 color : COLOR0;
	float4 specular: COLOR1;
};

//頂点シェーダー
VS_OUT VS(float4 pos : POSITION, float4 uv : TEXCOORD, float4 normal : NORMAL)
{
	VS_OUT outData;
	outData.pos = mul(pos, matWVP);
	outData.uv = uv;

	float4 light = float4(1, 1, -1, 0);
	light = normalize(light);

	normal = mul(normal, matNormal);

	outData.color = dot(normal, light);
	outData.color = clamp(outData.color, 0, 1);

	float4 V = normalize( mul(pos,matW) - camPos);
	float4 R = reflect(light, normal);
	outData.specular = pow(clamp( dot(R, V),0,1), 5) * 5;

	return outData;
}

//ピクセルシェーダー
float4 PS(VS_OUT inData) : SV_TARGET
{
	float4 diffuse;
	float4 ambient;

	if (isTexture)
	{
		diffuse = tex.Sample(smp, inData.uv) * inData.color;
		ambient = tex.Sample(smp, inData.uv) * 0.8;
	}
	else
	{
		diffuse = color * inData.color;
		ambient = color * 0.3;
	}

	return diffuse + ambient + inData.specular;
}