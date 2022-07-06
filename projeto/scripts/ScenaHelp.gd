extends Control

var  mensagem: Array = [
"Formando Palavr4:\n\nO Objetivo do jogo é formar palavras com diferentes \nnúmero de letras, onde há 4 tentativas para \no jogador acertar a palavra."
,"Cronometro:\n\nO Cronometro marca o tempo para montar e acertar\na palavra. Caso ele termine, o jogador perde uma\ntentiva, ou caso não tenha tentativas sobrando,\nperde o jogo."
,"Dica:\n\nAo clicar na dica (? no canto inferior direito da tela)\nela apresenta um numero\nrepresentado a sequência da palavra.\nQuando Clicado novamente, fica oculto,\nsem remoção ou adição de tentativas."
,"Como ganhar:\n\nA vitoria e definida quando o jogador acerta todos\nos quatro niveis."
]

var titulo: Array = ["Como jogar", "Conometro", "Dica", "Vitória"]



var next: int = 0;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = mensagem[0]
	$Label4.text = titulo[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Sair_pressed():
	get_tree().change_scene("res://scenes/main.tscn");


func _on_proximo_pressed():
	print(next)
	next +=1
	if mensagem.size() > next:
		$Label.text = mensagem[next]
		$Label4.text = titulo[next]
		$anterior.visible = true;
		$Label5.visible = true	
	if mensagem.size()-1 == next:
		$proximo.visible = false
		$Label2.visible = false	
	


func _on_anterior_pressed():
	next -=1
	print(next)
	if 0 <= next:
		$Label.text = mensagem[next]
		$Label4.text = titulo[next]
		$proximo.visible = true;
		$Label2.visible = true	
	if 0 == next:
		$anterior.visible = false
		$Label5.visible = false	
