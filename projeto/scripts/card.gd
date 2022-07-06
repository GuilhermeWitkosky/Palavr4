extends Control
#Aqui e a quantidade de cartas e os ids
export(int) var id: int = 2
var qtdCartas = 7;
var state = "select"
var done:bool = false
var letra: Array = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
var posicaox:Array=[]
var posicaoy:Array=[]
var posicao : int = 0;
signal clicked(id)

func _ready() -> void:
	randomize()
	# Altera o frame da carta, colocando qual a carta atual
	$front.frame = id
	
	# timer para mostrar a carta quando entra no tabuleiro
	yield(get_tree().create_timer(randf()), "timeout")
	$anim.play("start")

func _on_touch_pressed() -> void:
	# Não possiblito clicar na card caso ja tenha ido pro meio e for valida
	if done: return
	
	# Ja pode selecionar outra carta
	if !get_node("../../")._can_play(): return
	
	# Se a animação da carta estiver sendo executada então não deixa clicar
	if $anim.is_playing(): return
	
	#tem que ver a logica ainda para ser implementada.
	
	# Aqui vai fica a logica caso tenha 
	#carta para jogar caso sim joga senão compra do baralho
	#for i in range id:
	if state == 'hide':
			#Aqui definino se a carta e clicavel
		emit_signal("clicked", id)
			#aqui fica a carta seleciona
		#how()
	if state == 'show':
		#if emitir sinal botao para carta
		#emit_signal("clicked",id)
		_mov1()
#			if :
#				#Aqui definino se a carta e clicavel
#				emit_signal("clicked", id)
#				#Aqui move a carta para a posição
#			_	show()

func _select() -> void:
	# Esconde a carta novamente, criamos um timer apenas para ter uma randomização nos movimentos
	yield(get_tree().create_timer(randf() / 8), "timeout")
	state = 'select'
	$anim.play_backwards("show")

#Aqui mostra a carta do baralho e traz para sua mão
func _show() -> void:
	$sfx.play()

#Movimento para posição 1
func _mov1() -> void:
	state = 'mov1'
	$anim.play("mov1")
	
#Movimento para posição 2
func _mov2() -> void:
	state = 'mov2'
	$anim.play("mov2")
	
#Movimento para posição 3
func _mov3() -> void:
	state = 'mov3'
	$anim.play("mov3")
	
#Movimento para posição 4
func _mov4() -> void:
	state = 'mov4'
	$anim.play("mov4")

func _set_letra(_posicion):
	$letra.text = letra[_posicion]

func _set_num(_num):
	$num.text = str("",_num)
	
func _set_visible(_visible):
	$num.visible = _visible
	
func _get_letra()->String:
	return $letra.text
func _set_done(_state):
	
	# marca essa carta como concluída, ou seja, e valida a palavra 
	done = _state
	
	# Deixo ela um pouco transparente para dar destaques as que estão na mão.
	#modulate.a = .5
	pass
