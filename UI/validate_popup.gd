extends PanelContainer
class_name ValidatePopup

@export var main_text : String = ""
@export var validate_text : String = "Ok"
@export var text_cancel : String = "Cancel"

signal on_cancel()
signal on_validate()

# Called when the node enters the scene tree for the first time.
func _ready():
	update_from_export()


func _on_cancel_button_pressed():
	on_cancel.emit()
	self.queue_free()


func _on_ok_button_pressed():
	on_validate.emit()
	self.queue_free()

func update_from_export():
	%MainText.text = main_text
	%CancelButton.text = text_cancel
	%OkButton.text = validate_text
