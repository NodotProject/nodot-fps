extends Label

func _process(delta):
	text = str(round(1.0 / delta))
