shader_type canvas_item;

uniform float blur_amount = 2.0;

void fragment()
{
  COLOR = textureLod(TEXTURE, UV, blur_amount);
}