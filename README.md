# Rel-gio-digital
Relógio digital com set de horário
Descrição do Projeto: 
Este projeto consiste no desenvolvimento de um relógio digital em Verilog, que será executado na placa S-board Pitanga da InPlace. O relógio apresenta o horário no formato hh.mm em 4 displays de 7 segmentos, enquanto LEDs são utilizados para exibir a contagem dos segundos. O projeto permite o ajuste da hora e minutos através de botões.

Funcionalidades
Displays de 7 Segmentos: Exibem o horário no formato hh.mm.
LEDs: Indicadores que exibem a contagem de segundos.
Ponto Separador: O ponto do 3º display permanece sempre aceso, separando as horas dos minutos.
Ajuste de Horário:
Botão btn0: Inicia o ajuste de horário, alternando entre os estados de ajuste.
Botão btn1: Incrementa o valor da hora ou minutos, conforme o estado atual.
Intervalos:
Hora: de 0 a 23.
Minutos: de 0 a 59.
Congelamento do Relógio: Durante os estados de ajuste, o relógio congela a contagem.

Implementação
O relógio é implementado em Verilog, utilizando a descrição de hardware adequada para a S-board Pitanga.
Sinta-se livre para implementar a lógica conforme sua preferência, simplificando a máquina de estados ou incluindo funcionalidades adicionais conforme necessário.

Requisitos
Placa S-board Pitanga da InPlace.

Instruções de Uso
Conecte a Placa: Certifique-se de que a S-board Pitanga esteja conectada corretamente ao seu computador.
Carregue o Código: Compile e carregue o código Verilog para a placa.
Interaja com o Relógio: Use os botões btn0 e btn1 para ajustar a hora e minutos conforme necessário.
