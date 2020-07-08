extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Answer_text_entered(new_text):
	if (new_text == "4") :
		texture_normal = load("res://.import/good.png-0f2fdeb5d2199ad1e5f219145dd68d16.stex")
		get_parent().get_node("first").visible = true
		get_parent().get_node("Number1").visible = false
