/obj/item/mcobject/messaging/microphone
	name = "microphone component"
	base_icon_state = "comp_mic"

	var/relay_speaker = FALSE
/obj/item/mcobject/messaging/microphone/Initialize(mapload)
	. = ..()
	configs -= MC_CFG_OUTPUT_MESSAGE
	MC_ADD_CONFIG("Toggle Show-Source", toggle_source)
	become_hearing_sensitive()

/obj/item/mcobject/messaging/microphone/Destroy(force)
	. = ..()
	lose_hearing_sensitivity()

/obj/item/mcobject/messaging/microphone/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods, atom/sound_loc)
	. = ..()
	if(!anchored)
		return
	fire("[relay_speaker ? "[speaker.GetVoice()]:" : ""][raw_message]")

/obj/item/mcobject/messaging/microphone/proc/toggle_source(mob/user, obj/item/tool)
	relay_speaker = !relay_speaker
	to_chat(user, span_notice("You set [src] to [relay_speaker ? "relay the speaker" : "scrub the speaker"]."))
	return TRUE
