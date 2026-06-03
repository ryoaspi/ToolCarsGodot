@tool
extends Node
class_name CSLEDBlinker

## Je glisse ici le node avec le script principal (CSLEDColorSelection) que je veux faire clignoter.
@export var led_to_affect: CSLEDColorSelection

## Je coche cette case pour activer ou désactiver le clignotement.
@export var is_blinking: bool = false

## Vitesse du clignotement. Plus le chiffre est grand, plus le clignotement est rapide.
@export var blink_speed: float = 2.0

## Couleur de l'extinction. C'est la couleur vers laquelle la LED va tendre (le noir par défaut pour faire un effet éteint).
@export var blink_color: Color = Color(0.0, 0.0, 0.0, 1.0)

## Vitesse de la transition fluide. Plus je mets un chiffre élevé, plus le passage d'une couleur à l'autre est sec et rapide.
@export var lerp_speed: float = 10.0

# Je crée un chronomètre interne. Il descend de 1 à 0. Quand il arrive à 0, je change de phase.
var blink_timer: float = 1

# Je crée un interrupteur interne pour savoir si je suis actuellement sur ma phase allumée (true) ou ma phase éteinte (false).
var led_is_on: bool = true

# Je stocke ici la couleur cible que je dois atteindre à la fin de ma transition.
var target_color: Color

# Je stocke ici la couleur exacte que je suis en train de calculer à cette image (frame) précise.
var current_color: Color

func set_blinking():
	# Cette fonction permet à un autre script d'activer/désactiver le booléen du blink.
	is_blinking = !is_blinking

func set_blink_speed(blinkspeed: float):
	blink_speed = blinkspeed
	
func set_lerp_speed(lerpspeed: float):
	lerp_speed = lerpspeed

func _process(delta):
	# Je vérifie d'abord si le clignotement est désactivé depuis mon inspecteur.
	if not is_blinking:
		# Si la LED était en train de clignoter (interrupteur sur false), je dois la remettre dans son état normal.
		if not led_is_on:
			led_is_on = true
			# Je demande au script principal de recalculer et d'afficher sa couleur normale.
			led_to_affect.refresh()
		# Je m'assure que le chronomètre est rechargé pour être prêt au prochain allumage.
		blink_timer = 1
		return

	# Je fais descendre mon chronomètre en utilisant le temps écoulé (delta) multiplié par ma vitesse.
	blink_timer -= delta * blink_speed
	
	# Quand mon chronomètre arrive à zéro ou en dessous, il est temps d'inverser l'état de la LED.
	if blink_timer <= 0.0:
		# J'inverse mon interrupteur (si c'était true, ça devient false, et inversement).
		led_is_on = not led_is_on 
		# Je recharge mon chronomètre à 1 pour le cycle suivant.
		blink_timer = 1         
		
		if led_to_affect:
			# Si mon interrupteur vient de passer sur "éteint" :
			if led_is_on == false:
				# Je définis ma couleur noire de clignotement comme la nouvelle cible à atteindre.
				target_color = blink_color
			# Si mon interrupteur vient de passer sur "allumé" :
			else:
				# Je vérifie que l'index de couleur demandé existe bien dans la liste du script principal.
				if led_to_affect.led_color < led_to_affect.color_list.size():
					# Si oui, je définis cette couleur normale comme ma cible à atteindre.
					target_color = led_to_affect.color_list[led_to_affect.led_color]
				else:
					# Sinon, je prends la couleur par défaut par sécurité.
					target_color = led_to_affect.default_color

	# Je calcule et j'applique la transition fluide à chaque frame tant que je clignote.
	if is_blinking and led_to_affect:
		# J'utilise la fonction 'lerp' pour créer un mélange progressif entre ma couleur actuelle et ma cible.
		current_color = current_color.lerp(target_color, delta * lerp_speed)
		# J'envoie cette couleur fluide au script principal pour qu'il la diffuse aux autres.
		led_to_affect.set_forced_color(current_color)
