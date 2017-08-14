

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICACOES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSAO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRICAO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINICAO                       *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <P12F675.INC>	;ARQUIVO PADRAO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINACAO DE MEMORIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMORIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MEMORIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIAVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINICAO DOS NOMES E ENDEREÃ‡OS DE TODAS AS VARIAVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERECO INICIAL DA MEMORIA DE
					;USUARIO
		W_TEMP		;REGISTRADORES TEMPORARIOS PARA USO
		STATUS_TEMP	;JUNTO AS INTERRUPCOES
		;NOVAS VARIAVEIS
		AUX
		AUX_ESTOURO

	ENDC			;FIM DO BLOCO DE MEMORIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINICAO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINICAO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;#DEFINE ENTRADA GPIO,2 ;Porta de entrada 

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAIDA                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINICAO DE TODOS OS PINOS QUE SERAO UTILIZADOS COMO SAIDA
; RECOMENDAMOS TAMBEM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

#DEFINE SEMAFORO1_VERMELHO	GPIO,0	;Semaforo 1 vermelho e semaforo 2 verde
#DEFINE SEMAFORO1_VERDE		GPIO,1	;Semaforo 2 vermelho e semaforo 1 verde
#DEFINE SEMAFORO1_AMARELO	GPIO,2	;Semaforo 1 amarelo
#DEFINE SEMAFORO2_AMARELO	GPIO,4	;Semaforo 2 amarelo

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERECO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INICIO DA INTERRUPCAO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x04			;ENDERECO INICIAL DA INTERRUPCAO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPCAO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAIDA DA INTERRUPCAO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


;	-----	SEMAFORO1_VERMELHOR_2_VERDE_AMARELO	-----

SEMAFORO1_VERMELHO_2_VERDE_AMARELO
	;Primeiro limpa
	BCF	SEMAFORO1_AMARELO
	BCF	SEMAFORO1_VERDE
	BCF	SEMAFORO2_AMARELO
	
	;Agora seta os do momento
	BSF	SEMAFORO1_VERMELHO	;Acende o vermelho do 1 e o verde do 2
	
	GOTO	ATRASO_2S_INICIO	;Chama o primeiro atraso que eh de 2 segundos
VOLTA_2S
	BSF	SEMAFORO2_AMARELO	;Volta do atraso de 2 segundos e liga o led amarelo do semaforo 2
	GOTO	ATRASO_05S_INICIO	;Comeca um atraso de 0.5 segundos
	
VOLTA_05S
	BCF	SEMAFORO1_VERMELHO
	BCF	SEMAFORO2_AMARELO
	RETURN	;Volta pro Main
	
;	-----	ATRASO 2 SEGUNDOS	-----

;Cada atraso eh formado por um conjunto de labels que vao se alternando
;A label atraso inicio inicializa as variaveis que sao essenciais para o atraso

;Recebe o valor de AUX
ATRASO_2S_INICIO	
	MOVLW	.250			;Passa o valor de AUX_ESTOURO
	MOVWF	AUX_ESTOURO

;Recebe o valor de TMR0, que vai sendo atualizado a cada vez que uma variavel de AUX decrementa 
;Assim eu vou ter um loop consistente com duas variaveis

ATRASO_2S_ATUALIZA		
	BCF	INTCON,T0IF		;Limpa a flag
	MOVLW	.6			;Passa o valor de TMR0 desejado
	MOVWF	TMR0

ATRASO_2S
 	BTFSS	INTCON,T0IF		;Checa se o TMR0 chegou em 256
	GOTO	ATRASO_2S		;Fica em loop enquanto sem flag
	DECFSZ	AUX_ESTOURO		;Estourou decrementa AUX
	GOTO	ATRASO_2S_ATUALIZA	;AUX ainda nao zerou, entao repassa o valor correto de TMR0 e entra no loop novamente
	GOTO	FIM_ATRASO_2S		;Se AUX  for 0 entao terminou o tempo desejado do atraso

FIM_ATRASO_2S
	BCF	INTCON,T0IF		;Limpa a flag
	GOTO VOLTA_2S			;Sai do loop de 2 segundos

;	-----	ATRASO 05 SEGUNDOS	-----

;A explicacao do atraso de 2 segundos se repete para o atraso de 0.5 segundos

ATRASO_05S_INICIO
	MOVLW	.225			;Passa o valor de AUX_ESTOURO
	MOVWF	AUX_ESTOURO
	

ATRASO_05S_ATUALIZA
	BCF	INTCON,T0IF		;Limpa a flag
	MOVLW	.187			;Passa o valor de TMR0 desejado
	MOVWF	TMR0

ATRASO_05S
	BTFSS	INTCON,T0IF		;Checa se o TMR0 chegou em 256
	GOTO	ATRASO_05S		;Fica em loop enquanto sem flag
	DECFSZ	AUX_ESTOURO		;Estourou decrementa AUX
	GOTO	ATRASO_05S_ATUALIZA	;AUX ainda nao zerou, entao repassa o valor correto de TMR0 e entra no loop novamente
	GOTO	FIM_ATRASO_05S		;Se AUX  for 0 entao terminou o tempo desejado do atraso

FIM_ATRASO_05S
	BCF	INTCON,T0IF		;Limpa a flag
	GOTO VOLTA_05S			;Sai do loop de 0.5 segundos

;	-----	FIM	SEMAFORO1_VERMELHOR_2_VERDE_AMARELO	-----




;	-----	SEMAFORO2_VERMELHOR_1_VERDE_AMARELO	-----

SEMAFORO2_VERMELHOR_1_VERDE_AMARELO
	;Primeiro limpa os que nao serao utilizados no momento
	BCF	SEMAFORO2_AMARELO
	BCF 	SEMAFORO1_VERMELHO
	BCF	SEMAFORO1_AMARELO

	;Agora seta os do momento
	BSF	SEMAFORO1_VERDE			;O verde do 1 funciona como o vermelho do 2
	GOTO	ATRASO2_2S_INICIO
VOLTA2_2S
	BSF	SEMAFORO1_AMARELO
	GOTO	ATRASO2_05S_INICIO
VOLTA2_05S
	BCF	SEMAFORO1_VERMELHO
	BCF	SEMAFORO1_VERDE
	BCF	SEMAFORO2_AMARELO
	RETURN	;Volta pro Main
	
;	-----	ATRASO 2 SEGUNDOS	-----
ATRASO2_2S_INICIO
	MOVLW	.250
	MOVWF	AUX_ESTOURO

ATRASO2_2S_ATUALIZA
	BCF	INTCON,T0IF		;Limpa a flag
	MOVLW	.6			;Passa o valor de TMR0 desejado
	MOVWF	TMR0

ATRASO2_2S
	BTFSS	INTCON,T0IF		;Checa se o TMR0 chegou em 256
	GOTO	ATRASO2_2S		;Fica em loop enquanto sem flag
	DECFSZ	AUX_ESTOURO		;Estourou decrementa AUX
	GOTO	ATRASO2_2S_ATUALIZA	;AUX ainda nao zerou, entao repassa o valor correto de TMR0 e entra no loop novamente
	GOTO	FIM_ATRASO2_2S		;Se AUX  for 0 entao terminou o tempo desejado do atraso

FIM_ATRASO2_2S
	BCF	INTCON,T0IF		;Limpa a flag
	GOTO VOLTA2_2S

;	-----	ATRASO 05 SEGUNDOS	-----
ATRASO2_05S_INICIO
	MOVLW	.225
	MOVWF	AUX_ESTOURO

ATRASO2_05S_ATUALIZA
	BCF	INTCON,T0IF		;Limpa a flag
	MOVLW	.187			;Passa o valor de TMR0 desejado
	MOVWF	TMR0

ATRASO2_05S
	BTFSS	INTCON,T0IF		;Checa se o TMR0 chegou em 256
	GOTO	ATRASO2_05S		;Fica em loop enquanto sem flag
	DECFSZ	AUX_ESTOURO		;Estourou decrementa AUX
	GOTO	ATRASO2_05S_ATUALIZA	;AUX ainda nao zerou, entao repassa o valor correto de TMR0 e entra no loop novamente
	GOTO	FIM_ATRASO2_05S		;Se AUX  for 0 entao terminou o tempo desejado do atraso

FIM_ATRASO2_05S
	BCF	INTCON,T0IF		;Limpa a flag
	GOTO VOLTA2_05S			;Sai do loop de 0.5 segundos

;	-----	FIM	SEMAFORO2_VERMELHOR_1_VERDE_AMARELO	-----
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' 	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O

	MOVLW	B'00000100'	;Utilizando o PRESCALER em 1:32 do TMR0
				;Configurando ele!
	MOVWF	OPTION_REG	

	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE INTERRUPCAO
	BANK0			;RETORNA PARA O BANCO 0

	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERACAO DO COMPARADOR ANALOGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZACAO DE VARIAVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	CLRF GPIO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

BCF INTCON,T0IF
MAIN
	
	;	-----	EXPLICACAO ------
	;Explicacao do funcionamento do TMR0, estou utilizando o prescaler de 1:32
	;para cada 32 instrucoes de maquina terei um acrescimo no TMR0
	;	-----	FIM	EXPLICACAO ------


	;	-----	Semaforo	-----
	;	Consigo um tempo de 2.502306 segundos entre um semaforo e outro
	CALL	SEMAFORO1_VERMELHO_2_VERDE_AMARELO	;Chama semaforo 1 vermelho e semaforo 2 verde e amarelo
	CALL	SEMAFORO2_VERMELHOR_1_VERDE_AMARELO	;Chama semaforo 2 vermelho e semaforo 1 verde e amarelo
	GOTO MAIN
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
