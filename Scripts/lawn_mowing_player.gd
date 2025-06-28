extends AudioStreamPlayer

var mowingStart = load("res://Assets/Audio/Kosilnica/Startup3.mp3")
var mowingMid = load("res://Assets/Audio/Kosilnica/Operating3.mp3")
var mowingEnd = load("res://Assets/Audio/Kosilnica/Shutdown3.mp3")
@onready var mower_player: AudioStreamPlayer = $"."
var isMowingMidLooping = true
var should_resume_mid_after_end = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("playing StartingSFX")
	mower_boot_up()

func mower_boot_up():
	print("Booted up mower")
	mower_player.stream = mowingStart
	mower_player.play()
	mower_player.connect("finished", on_mower_start_finished)

func on_mower_start_finished():
	print("Playing mowingMid")
	mower_player.disconnect("finished", on_mower_start_finished)
	mower_player.stream = mowingMid
	mower_player.play()
	mower_player.connect("finished", loop_mower)

func loop_mower():
	mower_player.disconnect("finished", loop_mower)
	if isMowingMidLooping:
		mower_player.stream = mowingMid
		mower_player.play()
		mower_player.connect("finished", loop_mower)


func stop_mower():
	mower_player.stop()
	mower_player.stream = mowingEnd
	mower_player.play()
	mower_player.connect("finished", on_mower_end_finished)

func on_mower_end_finished():
	mower_player.disconnect("finished", on_mower_end_finished)
	print("Finished mowing")
	if should_resume_mid_after_end: # in some other script we will set this to true, meaning we booted the lawn mower up and we need the mowingMid SFX to start playing and looping
		print("Gonna boot up mower after crash")
		should_resume_mid_after_end = false
		mower_boot_up()
	else:
		print("stopping mower")
		mower_player.stop()
