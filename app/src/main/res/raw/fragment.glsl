precision mediump float;

uniform sampler2D textureDiff;
uniform sampler2D textureDissolve;

uniform vec3 matSpec, matAmbi, matEmit;
uniform float matSh;
uniform vec3 srcDiffL, srcSpecL, srcAmbiL;
uniform vec3 srcDiffR, srcSpecR, srcAmbiR;
uniform float threshold;

varying vec3 v_normal;
varying vec2 v_texCoord;
varying vec3 v_view, v_lightL, v_lightR;
varying float v_attL, v_attR;

void main() {
    //-------------------------------------------------------
    // Problem 2
    // Put a texture on the teapot.
    // Change the code below to get the texture value.

    vec3 color = texture2D(textureDiff, v_texCoord).rgb;

    //-------------------------------------------------------

    //-------------------------------------------------------
    // Problem 3
    // Implement the phong shader using 2 color point lights.

    // diffuse term
    vec3 matDiff = color;
    vec3 diffL = max(dot(v_lightL, v_normal), 0.0) * srcDiffL * matDiff * v_attL;
    vec3 diffR = max(dot(v_lightR, v_normal), 0.0) * srcDiffR * matDiff * v_attR;
    vec3 diff = diffL + diffR;

    // specular term
    vec3 reflL = reflect(-v_lightL, v_normal);
    vec3 reflR = reflect(-v_lightR, v_normal);
    vec3 specL = pow(max(dot(reflL, v_view), 0.0), matSh) * srcSpecL * matSpec * v_attL;
    vec3 specR = pow(max(dot(reflR, v_view), 0.0), matSh) * srcSpecR * matSpec * v_attR;
    vec3 spec = specL + specR;

    // ambient term
    vec3 ambiL = matAmbi * srcAmbiL;
    vec3 ambiR = matAmbi * srcAmbiR;
    vec3 ambi = ambiL + ambiR;
    color = ambi + diff + spec + matEmit;
    //-------------------------------------------------------

    float alpha = 1.0;
    //-------------------------------------------------------
    // Problem 4
    // Implement the alpha blending using an extra dissolve texture.

    alpha = 1.0 - threshold;
    //vec3 layer1 = texture2D(textureDiff, v_texCoord).rgb * alpha;
    vec3 layer1 = color * alpha + texture2D(textureDissolve, v_texCoord).rgb * (1.0 - alpha);
    vec3 layer2 = vec4(layer1
    //-------------------------------------------------------
    /*
    if(diss.x < (1.5 * (1.0 - alpha) - 0.3) ){
        discard;
    }
    */
    // final output color with alpha
    //gl_FragColor = vec4(color, 1.0);
    gl_FragColor = vec4(layer2,1.0);
}