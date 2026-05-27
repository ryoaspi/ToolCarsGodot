@tool
extends Node

# Je pointe vers le script de la LED qui est sur notre MeshInstance3D
@export var led_to_affect:CSLEDColorSelection

## Case à cocher pour activer/désactiver le clignotement
@export var is_blinking: bool = false
# Vitesse du clignotement
@export var blink_speed: float = 2.0
# Couleur utilisée pour le clignotement (le noir par défaut)
@export var blink_color: Color = Color(0.0, 0.0, 0.0, 1.0)

# variables de temps internes pour compter le temps qui passe
var blink_timer: float = 0.5
# Une variable "interrupteur" : True = couleur normale, False = noir
var led_is_on: bool = true

func _process(delta):
	# Si je coche pas la case, ca fait rien !
	if not is_blinking:
		# Si on vient d'arrêter le clignotement, on s'assure que la LED se remet sur sa couleur normale une bonne fois pour toutes
		if not led_is_on:
			led_is_on = true
			led_to_affect.refresh()
		blink_timer = 0.5
		return

	# Le chrono descend petit à petit
	blink_timer -= delta * blink_speed
	
	# Temps écoulé, j'inverse l'interrupteur
	if blink_timer <= 0.0:
		led_is_on = not led_is_on # j'inverse l'interrupteur (True devient False, False devient True)
		blink_timer = 0.5 # je recharge d'une demi-seconde pour le prochain coup 
		
	# Si l'interrupteur dit "éteint", je force la couleur de clignotement (le noir)
	if led_is_on == false:
			# Si l'interrupteur est sur OFF, on force la couleur de clignotement
			led_to_affect.set_forced_color(blink_color)
	else:
			# Si l'interrupteur est sur ON, on demande à la LED de recalculer 
			# et de réafficher sa couleur de base
			led_to_affect.refresh()
