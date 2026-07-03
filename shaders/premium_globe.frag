#include <flutter/runtime_effect.glsl>

precision highp float;

uniform vec2 uSize;
uniform float uTime;
uniform float uRotation;
uniform vec3 uLightDir;
uniform float uRimStrength;
uniform float uAtmosphereStrength;
uniform float uOpacity;
uniform float uCenterLat;
uniform sampler2D uTexture;

out vec4 fragColor;

const float kPi = 3.14159265358979323846;
const float kTau = 6.28318530717958647692;

float saturate(float value) {
  return clamp(value, 0.0, 1.0);
}

void main() {
  vec2 fragCoord = FlutterFragCoord().xy;
  vec2 p = (fragCoord / uSize) * 2.0 - 1.0;
  p.x *= uSize.x / max(uSize.y, 0.0001);

  float radiusSq = dot(p, p);
  if (radiusSq > 1.0) {
    fragColor = vec4(0.0);
    return;
  }

  float z = sqrt(max(0.0, 1.0 - radiusSq));
  vec3 normal = normalize(vec3(p.x, -p.y, z));

  float sinCenter = sin(uCenterLat);
  float cosCenter = cos(uCenterLat);
  float sinLat = clamp(normal.y * cosCenter + normal.z * sinCenter, -1.0, 1.0);
  float lat = asin(sinLat);
  float lonReference = normal.z * cosCenter - normal.y * sinCenter;
  float lon = atan(normal.x, lonReference) + uRotation;

  vec2 mapUv = vec2(fract((lon / kTau) + 0.5), clamp(0.5 - (lat / kPi), 0.0, 1.0));
  vec4 mapSample = texture(uTexture, mapUv);

  vec3 lightDir = normalize(uLightDir);
  float lambert = saturate(dot(normal, lightDir));
  float diffuse = 0.44 + 0.66 * pow(lambert, 1.18);
  float terminator = smoothstep(-0.20, 0.78, dot(normal, normalize(vec3(-0.50, 0.24, 0.83))));
  float edge = 1.0 - z;
  float curvatureShade = 1.0 - pow(edge, 1.42) * 0.34;

  vec3 color = mapSample.rgb * diffuse * curvatureShade * (0.82 + terminator * 0.24);

  vec3 viewDir = vec3(0.0, 0.0, 1.0);
  float specular = pow(saturate(dot(reflect(-lightDir, normal), viewDir)), 42.0);
  color += vec3(0.66, 0.88, 1.0) * specular * 0.11;

  float rim = pow(saturate(edge), 1.82) * uRimStrength;
  float leftRim = pow(saturate(edge * (1.05 - p.x * 0.28)), 2.0);
  float redEdge = pow(saturate(edge * (0.78 + p.x * 0.46 + p.y * 0.22)), 2.15);
  color += vec3(0.40, 0.72, 0.98) * rim * 0.14 * uAtmosphereStrength;
  color += vec3(0.96, 0.10, 0.12) * redEdge * 0.040;
  color += vec3(0.72, 0.92, 1.0) * leftRim * 0.038 * uAtmosphereStrength;

  float oceanPulse = sin((mapUv.x * 32.0) + (mapUv.y * 18.0) + uTime * 0.45);
  color += vec3(0.04, 0.10, 0.16) * oceanPulse * 0.018;

  float lowerShadow = smoothstep(0.18, 1.14, p.x * 0.44 + p.y * 0.66 + edge * 0.50);
  color *= 1.0 - lowerShadow * 0.12;
  color = mix(color, vec3(0.005, 0.015, 0.032), pow(edge, 2.35) * 0.16);

  float alpha = smoothstep(1.0, 0.975, radiusSq) * uOpacity;
  fragColor = vec4(color, alpha);
}
