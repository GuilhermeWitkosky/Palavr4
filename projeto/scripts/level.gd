extends Node2D

onready var cardScene = preload("res://scenes/card.tscn")
var cards:Array = [1,2,3,4,5,6,7,8]

var cardsPlayer1:Array=[]
var cardsPlayer2:Array=[]
var numPalavra: Array=[[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],[0,8]]
var visibleB = true

var card_per_level:Array = [4,8,16,32]
var col_per_level:Array = [2,4,8,8]
var time_per_level:Array = [30,60,120,240]
var letra: Array = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
var num: Array = []
var points:int = 50
var pointsOver:int = 25

var posicao : int = 0;
var valueAux: int = 0;
var palavraId : Array = []
var palavraNum : Array = []
var qtdVezes: int = 4;
var palavraSize: int = 0;
var palavras: Array = ["ONDA", "VIDA", "SENA", "MOTO", "TOPA", "NOTA","LEVA", "LEVE", "ANOS", "CANO", "PANO", "HINO", "SINO", "COLA", "BOLA", "SETA", "META","ROMA", "DAMA", "VELA", "ILHA", "VILA", "POLO", "LEGO", "NAVE", "ANTA", "NATA" , "MATO", "SELA", "LEMA","LIMA"]
#var palavras: Array = ["CARTA","MARCA", "CERTA", "ONDA", "VIDA", "SENA", "KELVIN", "LETICIA", "VINICIUS", "PEIXE"]
var card_opened:Array = []
var face_cards:int = 0
var endgame:bool = false
var cards_mont:int = 0
var time:int = 0
var playerWin:bool = false;
var playerCards:int = 0;
var playerCards2:int = 0;
var level : int = 3;
var rng = RandomNumberGenerator.new();
onready var screenSize:Vector2 = get_viewport_rect().size

func _ready() -> void:
	randomize()
	_new_game()

func _on_exit_pressed() -> void:
	get_tree().change_scene("res://scenes/main.tscn")

func _end_game() -> void:
	$sfxGameover.play()
	
#	if playerWin:
#		$ui/msg_box/title.text = "Player 1 é o vencedor"
#	else:
	$ui/msg_box/title.text = "Suas tentativas acabaram :("
	$ui/timer.text = ""
	$ui/tentativas.text = ""
	_clear_cards()
	$timer.stop()
	$ui/msg_box.show()
	$ui/container/Control.visible = false;
	
	yield($sfxGameover, "finished")
	endgame = true
	$ui/buttonJogar.visible = true
	$ui/jogar.visible = true

func _can_play():
	if card_opened.size() < 9:
		return true
	else:
		return false
		
func _win_game():
	
	$ui/container/Control.visible = false;
#	if playerCards < playerCards2 :
#		playerWin = true;
	$ui/msg_box/title.text = "Parabens você completou todos niveis"
	$ui/msg_box.show()
	_clear_cards()
	$sfxWin.play()
	$timer.stop()
	
	yield($sfxWin, "finished")
	endgame = true
	$ui/buttonJogar.visible = true
	$ui/jogar.visible = true

func _mark_card(_id) -> void:
	for c in get_tree().get_nodes_in_group("card"):
		# procura no meu deck a carta
		if c.id == _id:
			# marca ela como concluída
			c._set_done(true)

func _clear_cards() -> void:
	# removo todas as instancias das cartas do deck
	for c in get_tree().get_nodes_in_group("card"):
		c.queue_free()

func _on_timer_timeout() -> void:
	var horas = floor(time / 3600);
	var minutos = floor((time - (horas * 3600)) / 60);
	var segundos = floor(time % 60);
	
	if minutos < 10:
		minutos = str("0",minutos)
	if segundos < 10:
		segundos = str("0",segundos)
	
	$ui/timer.text = str(minutos, ":", segundos)
	
	time -= 1
	if time <= -1:
		qtdVezes-=1
		$ui/tentativas.text = str("Tentativas: ",qtdVezes)
		time = 60
		if qtdVezes == 0:
			$timer.stop()
			_end_game()
		
		#_end_game() - traz o finalização do jogo

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed() and endgame:
			# Se o jogo tiver terminado, e o jogador clicar na tela, sai para o menu
			_on_exit_pressed()
			
			
"""
REGRAS DO JOGO DE CARTAS
--------------------------------------------------
"""


func _new_game() -> void:
	
	$background.texture = load(str("res://assets/fundo.jpg")) 
	# reset das variaveis
	face_cards = 0
	card_opened.clear()
	time = 60
	_clear_cards()
		
	var qtd_cards = 8
	# Embaralho as opções para utilizar
	#cards.shuffle()
	
	var palavra = _randon_palavra()
	_converter_em_Id(palavra)
	palavraSize = palavraId.size()
	var numAux = '';
	
	if(palavraId.size() < 8):
		var adicionar = 8 - palavraId.size()
		
		for i in adicionar:
			num.append(numAux)
			numAux  = ''
			palavraId.append(rng.randf_range(0,25))
		
		for nums in num.size():
			if(nums<4):
				palavraNum.append([palavraId[nums],'ativo', nums])	
			else:
				palavraNum.append([palavraId[nums],'desativo', nums])
			print(palavraNum[nums])
			
	palavraId.sort()
	#deck.append(cards[1])
	
	# embaralho meu deck
	#deck.shuffle()
	
	var col = 0
	var cardWidth = null
	# faço um loop no meu deck para instanciar as cartas
	
	for c in cards:
		var card = cardScene.instance()
		card.id = col# aqui informo qual a carta que vai aparecer
		card._set_letra(palavraId[col])
		var number = retornaNumero(palavraId[col], palavraNum)
		card._set_num(number)
		card._set_visible(false)
		card.add_to_group("card") # adiciona essa carta em um grupo
		card.connect("clicked", self, "_on_card_click")
		#card.state = "mov"+rng.randf_range(1,4)
		card.state = "hide"
		$cards.add_child(card)
		
		card.rect_position.x = col * (card.rect_size.x + 25)
		card.rect_position.y = 1.7 * (card.rect_size.y + 25)
		cardsPlayer1.append(card)
		if cardWidth == null:
			cardWidth = card.rect_size
		
		# quebro as cartas por coluna e linha
		col += 1
		
	
	# centralizo as cartas de acordo com a quantidade do level
	# e ajusto o tamanho delas para quanto mais cartas, menor o tamanho
	var scl = .8 - (3 / 10.0)
	$cards.scale = Vector2(scl, scl)
	$cards.position.x = (screenSize.x / 2) - (col_per_level[3 - 1] * ((cardWidth.x + 35) * scl) / 2)
		
	var rr = card_per_level[3 - 1] / col_per_level[3 - 1]
	$cards.position.y = (screenSize.y / 2) - (rr * ((cardWidth.y + 35) * scl) / 2) + 80
		
	
	

func _on_card_click(_id) -> void:
	# quando é clicado em uma carta
	
	#movimento a carta para uma posicao
	_movimentarCartas(_id)
	
	# marca essa carta como aberta colocando ela no array de cartas abertas
	card_opened.append(_id)
	print(card_opened.size())
	# Se já tenho as cartas selecionadas
	if card_opened.size() <= palavraSize:
		# Vertifico se as duas são iguais
		if _validar_palavra(card_opened):
			# confirmo para o jogador que ele acertou
			_mark_card(_id)
			var t = Timer.new()
			t.set_wait_time(0.6)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
			card_opened.clear() # limpo as cartas abertas
			if level >0:
				_next_level()
			else:
				_win_game()
			
		else:
			$sfxRight.play()
			
			_mark_card(_id) # marco a carta como concluída
			
			if card_opened.size() == palavraSize:
				card_opened.clear()
				_reset_level();
			if qtdVezes == 0:
				_end_game()
			
			pass

#retorna true ou false para jogada
func _reset_level():
	visibleB = true;
	posicao = 0
	qtdVezes-=1
	$ui/tentativas.text = str("Tentativas: ",qtdVezes)
	card_opened.clear()
	cardsPlayer1.clear()
	_clear_cards()
	var col = 0
	var cardWidth = null
	# faço um loop no meu deck para instanciar as cartas
	
	for c in cards:
		var card = cardScene.instance()
		card.id = col# aqui informo qual a carta que vai aparecer
		card._set_letra(palavraId[col])
		var number = retornaNumero(palavraId[col], palavraNum)
		card._set_num(number)
		
		card._set_visible(visibleB)
		card.add_to_group("card") # adiciona essa carta em um grupo
		card.connect("clicked", self, "_on_card_click")
		#card.state = "mov"+rng.randf_range(1,4)
		card.state = "hide"
		$cards.add_child(card)
		card.rect_position.x = col * (card.rect_size.x + 25)
		card.rect_position.y = 1.7 * (card.rect_size.y + 25)
		cardsPlayer1.append(card)
		if cardWidth == null:
			cardWidth = card.rect_size
		
		# quebro as cartas por coluna e linha
		col += 1
	
func _validar_palavra(_card_opend) -> bool:
	
	var palavra2 = _converter_de_Id_para_palavra(_card_opend)
	print(palavra2)
	for c in palavras:
		if c == palavra2:
			return true
	return false

func _movimentarCartas(_id):
	print(str("posicao:",posicao)) 
	for card in cardsPlayer1:
		if card.id == _id:
			card.rect_position.x = posicao * (card.rect_size.x + 25)
			card.rect_position.y = -( 0.01 * (card.rect_size.y + 25))
			posicao+=1

func _next_level():
	visibleB = true;
	palavraNum.clear();
	num.clear();
	posicao = 0
	level -=1
	face_cards = 0
	card_opened.clear()
	palavraId.clear()
	time = 60;
	_clear_cards()
	cardsPlayer1.clear()
		
	var qtd_cards = 8
	# Embaralho as opções para utilizar
	
	var palavra = _randon_palavra()
	_converter_em_Id(palavra)
	palavraSize = palavraId.size()
	var numAux = num.size()+1
	if(palavraId.size() < 8):
		var adicionar = 8 - palavraId.size()
		
		for i in adicionar:
			num.append(numAux)
			numAux+=1
			palavraId.append(rng.randf_range(0,25))
	for nums in num.size():
			if(nums<4):
				palavraNum.append([palavraId[nums],'ativo', nums])	
			else:
				palavraNum.append([palavraId[nums],'desativo', nums])
			print(palavraNum[nums])
	palavraId.sort()
	#deck.append(cards[1])
	
	# embaralho meu deck
	#deck.shuffle()
	
	var col = 0
	var cardWidth = null
	# faço um loop no meu deck para instanciar as cartas
	
	for c in cards:
		var card = cardScene.instance()
		card.id = col# aqui informo qual a carta que vai aparecer
		card._set_letra(palavraId[col])
		card.add_to_group("card") # adiciona essa carta em um grupo
		var number = retornaNumero(palavraId[col], palavraNum)
		card._set_num(number)
		card._set_visible(false)
		card.connect("clicked", self, "_on_card_click")
		#card.state = "mov"+rng.randf_range(1,4)
		card.state = "hide"
		$cards.add_child(card)
		card.rect_position.x = col * (card.rect_size.x + 25)
		card.rect_position.y = 1.7 * (card.rect_size.y + 25)
		cardsPlayer1.append(card)
		if cardWidth == null:
			cardWidth = card.rect_size
		
		# quebro as cartas por coluna e linha
		col += 1

func _Busca_palavra_no_banco():
	pass

func _converter_de_Id_para_palavra(_card_opend)->String:
	var a = "";
	for i in _card_opend :
		a += letra[palavraId[i]]
	print(a)
	return a
func _converter_em_Id(_string):
	var cont = 1
	for j in _string:
		for i in letra.size():
			if(letra[i] == j):
				num.append(cont)
				palavraId.append(i)
				cont+=1
				break;
	pass

func _randon_palavra()-> String:
	rng.randomize()
	return palavras[rng.randf_range(0, palavras.size())]
	

func _add_card_player():
	#player add card
	#if(isPlayer1)
	#Array2.add(Card)
	#else:
	#Array.add(Card)	
	pass

func retornaNumero(_palavraId, _palavraNum)-> String:
	var value = ''
	for j in _palavraNum:
		if _palavraId == j[0] && j[1] == 'ativo':
			value = j[2]+1;
	return value;

func _on_ajuda_pressed():
	
	if visibleB:
		print("click 1")
		for c in cardsPlayer1:
			c._set_visible(visibleB)
		visibleB = false
	else:
		print("click 2")
		for c in cardsPlayer1:
			c._set_visible(visibleB)
		visibleB = true


#func _on_buttonJogar_pressed():
#	_ready()
