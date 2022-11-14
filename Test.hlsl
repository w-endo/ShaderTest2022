Texture2D tex : register(t0);
SamplerState smp : register(s0);

cbuffer gloabl
{
	float4x4 matWVP;
	float4	 color;
	bool	 isTexture;
};

struct VS_OUT
{
	float4 pos : SV_POSITION;
	float2 uv  : TEXCOORD;
};

//頂点シェーダー
VS_OUT VS(float4 pos : POSITION, float4 uv : TEXCOORD)
{
	VS_OUT outData;
	outData.pos = mul(pos, matWVP);
	outData.uv = uv;
	return outData;
}

//ピクセルシェーダー
float4 PS(VS_OUT inData) : SV_TARGET
{
	if (isTexture)
	{
		return tex.Sample(smp, inData.uv);
	}
	else
	{
		return color;
	}
}