@tool
class_name CSLEDColorSelection
extends Node

# Je crée un signal. C'est comme un haut-parleur qui annonce aux scripts Peintre et Électricien : "La couleur a changé, voici la nouvelle !"
signal color_changed(new_color: Color)

## Index de la couleur à afficher. Ce chiffre correspond à la position de la couleur dans le tableau juste en dessous.
@export var led_color: int:
	set(value):
		# Quand je change la valeur dans l'inspecteur, je mets à jour ma variable.
		led_color = value
		# Je vérifie que le nœud est bien chargé dans l'éditeur avant de rafraîchir pour éviter que le moteur ne plante.
		if is_node_ready():
			refresh()

## Tableau dans lequel j'ajoute et je configure toutes mes couleurs personnalisées.
@export var color_list: Array[Color]

## Couleur de sécurité qui s'affiche si je choisis un index qui n'existe pas dans mon tableau.
@export var default_color: Color = Color(1.0, 0.0, 1.0, 1.0)

func _ready():
	# Au démarrage de la scène, je force un premier rafraîchissement pour envoyer la bonne couleur tout de suite.
	refresh()

func set_selection(index: int):
	# Cette fonction permet à un autre script de changer l'index de ma couleur simplement.
	led_color = index
	
func set_default_color(defaultcolor: Color):
	# Cette fonction permet à un autre script de changer la couleur par default.
	default_color = defaultcolor
	refresh()
	
func set_color_with_percent(red: float, green: float, blue: float):
	push_error("not implemented")
	pass
	
func set_color_with_bytes(red_255: int, green_255: int, blue_255: int):
	push_error("not implemented")
	pass

func set_forced_color(custom_color: Color):
	# Cette fonction est appelée par mon clignoteur. Elle me permet de diffuser une couleur d'urgence sans modifier mon index normal.
	color_changed.emit(custom_color)

func refresh():
	# Je prépare ma couleur de sécurité au cas où.
	var base_color = default_color
	
	# Je vérifie que l'index demandé (led_color) est valide (qu'il ne dépasse pas la taille de mon tableau).
	if led_color >= 0 and led_color < color_list.size():
		# Si l'index est bon, je récupère la couleur correspondante dans mon tableau.
		base_color = color_list[led_color]
	
	# J'utilise mon signal pour diffuser la couleur finale à tous les scripts connectés.
	color_changed.emit(base_color)
