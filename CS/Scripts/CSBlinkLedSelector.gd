@tool
extends Node
class_name CSLEDBlinker

# On pointe vers le script de la LED qui est sur notre MeshInstance3D
@export var led_to_affect: CSLEDColorSelection

# Case à cocher pour activer/désactiver le clignotement
@export var is_blinking: bool = false
# Vitesse du clignotement
@export var blink_speed: float = 2.0
# Couleur utilisée pour le clignotement (le noir par défaut)
@export var blink_color: Color = Color(0.0, 0.0, 0.0, 1.0)

## Vitesse de la transition fluide (plus la valeur est haute, plus la transition est rapide)
@export var lerp_speed: float = 10.0

# Le chrono descend de 1.0 à 0. Quand il arrive à 0, on change l'état !
var blink_timer: float = 1
# Une variable "interrupteur" : True = couleur normale, False = noir
var led_is_on: bool = true

## Variable pour stocker la couleur cible vers laquelle on veut tendre
var target_color: Color
## Variable pour calculer et appliquer la couleur adoucie actuelle
var current_color: Color

func _process(delta):
	# Le clignotement (est fait APRÈS la boucle pour pouvoir écraser la couleur si besoin)
	if not is_blinking:
		# Si on vient d'arrêter le clignotement, on s'assure que la LED se remet 
		# sur sa couleur normale (et rallume ses composants/spots) une bonne fois pour toutes
		if not led_is_on:
			led_is_on = true
			led_to_affect.refresh()
		# Si on ne clignote plus, on s'assure que la LED reste allumée normalement
		blink_timer = 1
		return

	# Le chrono descend petit à petit (multiplié par notre vitesse)
	blink_timer -= delta * blink_speed
	
	# Le chrono est expiré (arrivé à 0 ou moins) : c'est le signal pour inverser l'état de la LED !
	if blink_timer <= 0.0:
		led_is_on = not led_is_on # On inverse l'interrupteur (True devient False, False devient True)
		blink_timer = 1         # On recharge le chrono pour une seconde
		
		# On applique le changement d'état uniquement au moment du basculement du chrono
		if led_is_on == false:
			# Si l'interrupteur dit "éteint", je force la couleur de clignotement (le noir qui est "set" par default)
			# Grâce au code dans CSLEDColor_Manager, cela va couper aussi l'émission et cacher les spots !
			
			# MODIFICATION : Au lieu d'appliquer directement, on définit la couleur noire comme cible
			target_color = blink_color
		else:
			# Si l'interrupteur dit "allumé", on demande à la LED de recalculer sa vraie couleur
			# Cela va rétablir l'albedo, réactiver l'émission et ré-afficher les spots !
			
			# MODIFICATION : Au lieu d'appeler refresh(), on va chercher la vraie couleur de la liste
			# pour la définir comme notre cible à atteindre
			if led_to_affect.led_color < led_to_affect.color_selection.size():
				target_color = led_to_affect.color_selection[led_to_affect.led_color]
			else:
				target_color = led_to_affect.default_color

	# --- APPLICATION DU LERP (À CHAQUE FRAME) ---
	# Si le clignotement est actif, on calcule la couleur intermédiaire en continu vers la cible
	if is_blinking:
		current_color = current_color.lerp(target_color, delta * lerp_speed)
		# On pousse cette couleur fluide en temps réel dans la LED et le SpotLight
		led_to_affect.set_forced_color(current_color)
