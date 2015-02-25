#include "Lighting.hlsli"

cbuffer perFrame : register(b0)
{
	matrix view;
	matrix projection;
	float3 eyePos;
	float elapsedTime;
};

cbuffer perObject : register(b1)
{
	matrix world;
	matrix worldInverseTranspose;
	LightMaterial lightMat;
	int tileX;
	int tileY;
	float pad[2];
}

cbuffer lights : register(b2)
{
	DirectionalLight dLight[1];
	PointLight pLight[3];
	SpotLight sLight[3];
	int numDL;
	int numPL;
	int numSL;
	float lpad;
}

struct VertexToPixel
{
	float4 position		: SV_POSITION;
	float3 worldpos		: POSITION0;
	float4 color		: COLOR;
	float2 uv			: TEXCOORD0;
	float3 normal		: NORMAL;
	float3 tangent		: TANGENT;
};

float4 main(VertexToPixel input) : SV_TARGET
{
	// Pass through normal
	input.normal = normalize(input.normal);

	// Calculate relation to camera for specularity and camera based effects
	float distToEye = length(eyePos - input.worldpos);
	float3 toEye = normalize(eyePos - input.worldpos);

	// Create light values and set them to zero
	float4 ambient = float4(0, 0, 0, 0);
	float4 diffuse = float4(0, 0, 0, 0);
	float4 spec = float4(0, 0, 0, 0);

	float4 A, D, S;

	///
	// Lighting Calculations
	///
	for (int i = 0; i < numDL; i++)
	{
		ComputeDirectionalLight(lightMat, dLight[i], input.normal, toEye, A, D, S);
		ambient += A;
		diffuse += D;
		spec += S;
	}

	for (int i = 0; i < numPL; i++)
	{
		ComputePointLight(lightMat, pLight[i], input.worldpos, input.normal, toEye, A, D, S);
		ambient += A;
		diffuse += D;
		spec += S;
	}

	for (int i = 0; i < numSL; i++)
	{
		ComputeSpotLight(lightMat, sLight[i], input.worldpos, input.normal, toEye, A, D, S);
		ambient += A;
		diffuse += D;
		spec += S;
	}

	// Calculate lit color based on lighting and shadow calculations
	float4 litColor = (ambient + diffuse) + spec;

	// Pass through alpha value
	litColor.a = lightMat.diffuse.a;

	return litColor;
}