#ifndef LIGHT_HPP
#define LIGHT_HPP

#include "Config.hpp"
#include "ShadowMap.hpp"

NS_BEGIN
/// <summary>
/// Abstract class for lights
/// </summary>
struct Light
{
public:
	Light();

	XMFLOAT4 ambient;
	XMFLOAT4 diffuse;
	XMFLOAT4 specular;
	//bool hasShadows;
	//ShadowMap* shadowmap;
	//bool pad[7];
private:

};

/// <summary>
/// Sun-like light
/// </summary>
struct DirectionalLight : public Light
{
public:
	DirectionalLight();

	XMFLOAT3 direction;
	float pad3;
private:

};

/// <summary>
/// Lightbulb-like light
/// </summary>
struct PointLight : public Light
{
public:
	PointLight();

	XMFLOAT3 position;
	float range;
	XMFLOAT3 attenuation;
	float pad3;
private:

};

/// <summary>
/// Flashlight-like light
/// </summary>
struct SpotLight : public Light
{
public:
	SpotLight();

	XMFLOAT3 position;
	float range;
	XMFLOAT3 direction;
	float spot;
	XMFLOAT3 attenuation;
	float pad3;
private:

};

NS_END

#endif