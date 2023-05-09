@tool
extends WaterArea3D

func move_sfx(body: Node3D):
  $SplashSFX.position = body.position
