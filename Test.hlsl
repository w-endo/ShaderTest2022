//���_�V�F�[�_�[
float4 VS( float4 pos : POSITION ) : SV_POSITION
{
	return pos;
}

//�s�N�Z���V�F�[�_�[
float4 PS(float4 pos : SV_POSITION) : SV_TARGET
{

	return float4(1-(pos.x / 800), 1, 1, 1);
}