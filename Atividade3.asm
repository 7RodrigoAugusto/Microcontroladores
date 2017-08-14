

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

#DEFINE SEMAFORO1_VERMELHO	GPIO,0
#DEFINE SEMAFORO1_VERDE		GPIO,1
#DEFINE SEMAFORO1_AMARELO	GPIO,2
#DEFINE SEMAFORO2_AMARELO	GPIO,4

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
	;Primeiro limpa os que nao serao utilizados no momento
	BCF	SEMAFORO1_AMARELO
	BCF	SEMAFORO1_VERDE
	BCF	SEMAFORO2_AMARELO
	
	;Agora seta os do momento
	BSF	SEMAFORO1_VERMELHO	;Acende o vermelho do 1 e o verde do 2
	;BSF	SEMAFORO1_VERDE
	GOTO	ATRASO_2S_INICIO
VOLTA_2S
	BSF	SEMAFORO2_AMARELO
	GOTO	ATRASO_05S_INICIO
VOLTA_05S
	BCF	SEMAFORO1_VERMELHO
	;BCF	SEMAFORO1_VERDE
	BCF	SEMAFORO2_AMARELO
	RETURN	;Volta pro Main
	
;	-----	ATRASO 2 SEGUNDOS	-----
ATRASO_2S_INICIO
	MOVLW	.250
	MOVWF	AUX_ESTOURO

ATRASO_2S_ATUALIZA
	BCF	INTCON,T0IF	;Limpa a flag
	MOVLW	.6
	MOVWF	TMR0

ATRASO_2S
 	BTFSS	INTCON,T0IF
	GOTO	ATRASO_2S
	DECFSZ	AUX_ESTOURO
	GOTO	ATRASO_2S_ATUALIZA
	GOTO	FIM_ATRASO_2S

FIM_ATRASO_2S
	BCF	INTCON,T0IF	;Limpa a flag
	GOTO VOLTA_2S

;	-----	ATRASO 05 SEGUNDOS	-----
ATRASO_05S_INICIO
	MOVLW	.225
	MOVWF	AUX_ESTOURO

ATRASO_05S_ATUALIZA
	BCF	INTCON,T0IF	;Limpa a flag
	MOVLW	.187
	MOVWF	TMR0

ATRASO_05S
	BTFSS	INTCON,T0IF
	GOTO	ATRASO_05S
	DECFSZ	AUX_ESTOURO
	GOTO	ATRASO_05S_ATUALIZA
	GOTO	FIM_ATRASO_05S

FIM_ATRASO_05S
	BCF	INTCON,T0IF	;Limpa a flag
	GOTO VOLTA_05S

;	-----	FIM	SEMAFORO1_VERMELHOR_2_VERDE_AMARELO	-----




;	-----	SEMAFORO2_VERMELHOR_1_VERDE_AMARELO	-----

SEMAFORO2_VERMELHOR_1_VERDE_AMARELO
	;Primeiro limpa os que nao serao utilizados no momento
	BCF	SEMAFORO2_AMARELO
	BCF SEMAFORO1_VERMELHO
	BCF	SEMAFORO1_AMARELO

	;Agora seta os do momento
	;BSF	SEMAFORO1_VERMELHO
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
	BCF	INTCON,T0IF	;Limpa a flag
	MOVLW	.6
	MOVWF	TMR0

ATRASO2_2S
	BTFSS	INTCON,T0IF
	GOTO	ATRASO2_2S
	DECFSZ	AUX_ESTOURO
	GOTO	ATRASO2_2S_ATUALIZA
	GOTO	FIM_ATRASO2_2S

FIM_ATRASO2_2S
	BCF	INTCON,T0IF	;Limpa a flag
	GOTO VOLTA2_2S

;	-----	ATRASO 05 SEGUNDOS	-----
ATRASO2_05S_INICIO
	MOVLW	.225
	MOVWF	AUX_ESTOURO

ATRASO2_05S_ATUALIZA
	BCF	INTCON,T0IF	;Limpa a flag
	MOVLW	.187
	MOVWF	TMR0

ATRASO2_05S
	BTFSS	INTCON,T0IF
	GOTO	ATRASO2_05S
	DECFSZ	AUX_ESTOURO
	GOTO	ATRASO2_05S_ATUALIZA
	GOTO	FIM_ATRASO2_05S

FIM_ATRASO2_05S
	BCF	INTCON,T0IF	;Limpa a flag
	GOTO VOLTA2_05S

;	-----	FIM	SEMAFORO2_VERMELHOR_1_VERDE_AMARELO	-----
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O

	MOVLW	B'00000100'	;Utilizando o PRESCALER em 1:32 do TMR0
						;Configurando ele!
	MOVWF	OPTION_REG	

	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE INTERRUPCAO
	BANK0				;RETORNA PARA O BANCO 0

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
	;por isso quando eu encontro o valor de AUX = 11 eu tenho TMR0 = 1
	;Pois para realizar o incremento de aux ate 11 eu tenho que realizar 32 instrucoes
	;sabendo que INCF corresponde a um ciclo de maquina e GOTO corresponde a dois ciclos 
	;de maquina
	;INCF	AUX
	;GOTO MAIN
	;	-----	FIM	EXPLICACAO ------


	;	-----	Semaforo	-----
	;	Consigo um tempo de 2.502306 segundos entre um semaforo e outro
	CALL	SEMAFORO1_VERMELHO_2_VERDE_AMARELO
	CALL	SEMAFORO2_VERMELHOR_1_VERDE_AMARELO
	GOTO MAIN
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END