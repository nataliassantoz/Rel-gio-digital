module contaSegundos(
    input clk,        
    input rst, 
    input zerou_hr,    
    input ajuste,   
    output reg sinal_segundos,  // Sinal de 1 bit para contagem dos segundos
    output reg leds            // Controle do LED
); 
    reg [5:0] count; // Contador de 6 bits para contar até 59 segundos
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 6'h3A;     // Inicializa o contador de segundos em 0
            sinal_segundos <= 0; // Inicializa o sinal de segundos
            leds <= 0;           // Inicializa o LED desligado
        end else if (zerou_hr) begin
            sinal_segundos <= 0; // Reinicia o sinal de segundos quando as horas zeram
            leds <= 0;           // Reseta o LED (opcional, pode alternar também)
        end else if (count == 6'h3B) begin
            count <= 6'h01;     // Reinicia o contador de segundos após 59 segundos
            sinal_segundos <= 1; // Gera o sinal indicando que 60 segundos se passaram
            leds <= ~leds;       // Alterna o LED (pisca a cada segundo)
        
        end 
        else if(ajuste) begin 
            leds <= 6'h01; 
            sinal_segundos <= 0; 

        end
        else begin
            count <= count + 1'b1; // Incrementa o contador de segundos
            sinal_segundos <= 0;   // Reseta o sinal de segundos durante a contagem
            leds <= ~leds;          // Mantém o LED no estado atual
        end
    end
endmodule


module dec7seg(
    input [3:0] digit, 
    output [6:0] seg
);
    assign seg =
        (digit == 4'h0) ? 7'b1111110 : // 0
        (digit == 4'h1) ? 7'b0110000 : // 1
        (digit == 4'h2) ? 7'b1101101 : // 2
        (digit == 4'h3) ? 7'b1111001 : // 3
        (digit == 4'h4) ? 7'b0110011 : // 4
        (digit == 4'h5) ? 7'b1011011 : // 5
        (digit == 4'h6) ? 7'b1011111 : // 6
        (digit == 4'h7) ? 7'b1110000 : // 7
        (digit == 4'h8) ? 7'b1111111 : // 8
        (digit == 4'h9) ? 7'b1111011 : // 9
        (digit == 4'hA) ? 7'b1110111 : // A
        (digit == 4'hB) ? 7'b0011111 : // B
        (digit == 4'hC) ? 7'b1001110 : // C
        (digit == 4'hD) ? 7'b0111101 : // D
        (digit == 4'hE) ? 7'b1001111 : // E
        (digit == 4'hF) ? 7'b1000111 : // F
        7'b0000000; // Apaga
endmodule

module contaHoras(
    input clk,
    input rst,
    input inc_hours,         // Sinal que indica que os minutos zeraram e horas devem incrementar
    input ajuste,            // Sinal para indicar que estamos ajustando as horas
    input btn,               // Botão para incrementar as horas durante o ajuste
    output reg [5:0] horas,
    output reg zerou_hr      // Flag que indica que as horas zeraram
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            horas <= 6'h17;   // Inicializa horas em 0
            zerou_hr <= 0;    // Reseta o sinal de zeramento de horas
        end else if (ajuste) begin
            // Durante o ajuste manual, incrementa as horas com o botão
            if (btn) begin
                if (horas == 6'h17) begin
                    horas <= 6'h00;   // Reseta para 0 após 23 horas
                   
                end else begin
                    horas <= horas + 1'b1;
                end
            end
        end 

        else if (inc_hours) begin  // Adiciona uma verificação adicional para garantir que as horas só incrementem uma vez
            if (horas == 6'h17) begin
                horas <= 6'h00;   // Reseta as horas para 0 após 23
                zerou_hr <= 1;    // Sinaliza que as horas zeraram
            end else begin
                horas <= horas + 1'b1; // Incrementa a hora
                zerou_hr <= 1;         // Reseta o sinal de zeramento
            end
        end else begin
            zerou_hr <= 0;  // Garante que a flag zerou_hr é resetada
        end
    end
endmodule



module contaMinutos(
    input clk,
    input rst,
    input sinal,        // Sinal de contagem dos segundos
    input ajuste,       // Sinal para indicar que estamos ajustando os minutos
    input btn,          // Botão para incrementar os minutos durante o ajuste
    // input zerou_hr,
    output reg [5:0] count,
    output reg inc_hours      // Sinal para incrementar horas
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 6'h3B;          // Inicializa minutos em 0
            inc_hours <= 0;          // Reseta o sinal de inc_hours
        end else if (ajuste) begin
            // Durante o ajuste manual, incrementa os minutos com o botão
            if (btn) begin
                if (count == 6'h3B) begin
                    count <= 6'h00;    // Reseta para 0 após 59 minutos
                end else begin
                    count <= count + 1'b1;
                    
                end
            end
        
        end

        // else if (zerou_hr) begin 
        //     count <= 6'h00; 
        // end

         else if (sinal) begin
            // Lógica normal de contagem de minutos
            if (count == 6'h3B) begin
                inc_hours <= 1;    // Sinaliza incremento de horas
                count <= 6'h00;    // Reseta os minutos para 0 após 59
                
            end else begin
                count <= count + 1'b1;  // Incrementa os minutos
                inc_hours <= 0;         // Desativa o sinal de incremento de horas
            end
        end

        else begin
            inc_hours <= 0;  // Assegura que inc_hours é resetado quando não incrementando
        end
        

       
    end

endmodule




module exibeNumero(
    input [5:0] Num,
    output [6:0] seg0,
    output [6:0] seg1
);
    wire [3:0] unidade;
    wire [3:0] dezena;

    assign unidade = Num % 10; // Unidades
    assign dezena = Num / 10;  // Dezenas

    dec7seg decod0 (.digit(unidade), .seg(seg0));
    dec7seg decod1 (.digit(dezena), .seg(seg1));
endmodule


module funcionandoRelogio(
    input clk,
    input rst,
    input btn0,   // usado para alternar entre modos de ajustes
    input btn1,   // usado para incrementar horas ou minutos
    output [6:0] mins0,
    output [6:0] mins1,
    output [6:0] horas0,
    output [6:0] horas1,
    output led    // Adicione uma saída para o LED
);

    // Definindo os estados usando localparam
    localparam RODANDO = 2'b00;      // Estado em que o relógio está rodando normalmente
    localparam AJUSTA_MINUTO = 2'b01;// Estado de ajuste de minutos
    localparam AJUSTA_HORA = 2'b10;  // Estado de ajuste de horas

    reg [1:0] estado_atual, proximo_estado;
    wire [5:0] mins;
    wire [5:0] horas;
    wire sinal_segundos;  // Sinal para contagem de 60 segundos
    wire inc_hours;       // Sinal para incrementar horas
    wire zerou_hr;
    wire leds;            // Sinal para controlar o LED

    // Instanciação dos módulos
    contaSegundos segundos (
        .clk(clk), 
        .rst(rst), 
        .ajuste(estado_atual == AJUSTA_MINUTO || estado_atual == AJUSTA_HORA),
        .sinal_segundos(sinal_segundos),
        .zerou_hr(zerou_hr),
        .leds(led)         // Conectando o sinal de LEDs ao módulo contaSegundos
    );

    contaMinutos minutos (
        .clk(clk), 
        .rst(rst), 
        .sinal(sinal_segundos), 
        .ajuste(estado_atual == AJUSTA_MINUTO), 
        .btn(btn1), 
        .count(mins), 
        .inc_hours(inc_hours)
        // .zerou_hr(zerou_hr)
    );
    
    contaHoras horasContador (
        .clk(clk), 
        .rst(rst), 
        .inc_hours(inc_hours), 
        .ajuste(estado_atual == AJUSTA_HORA), 
        .btn(btn1), 
        .horas(horas),
        .zerou_hr(zerou_hr)
    );

    // Lógica de transição de estados
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estado_atual <= RODANDO;
        end else begin
            estado_atual <= proximo_estado;
        end
    end

    always @(*) begin
        case (estado_atual)
            RODANDO: begin
                if (btn0) 
                    proximo_estado = AJUSTA_MINUTO;  // Se btn0 for pressionado, vai para o estado de ajuste de minutos
                else 
                    proximo_estado = RODANDO;
            end
            AJUSTA_MINUTO: begin
                if (btn0) 
                    proximo_estado = AJUSTA_HORA;  // Se btn0 for pressionado, alterna para ajuste de horas
                else 
                    proximo_estado = AJUSTA_MINUTO;
            end
            AJUSTA_HORA: begin
                if (btn0) 
                    proximo_estado = RODANDO;  // Se btn0 for pressionado novamente, retorna ao estado de contagem normal
                else 
                    proximo_estado = AJUSTA_HORA;
            end
            default: proximo_estado = RODANDO;
        endcase
    end

    // Exibe os valores de minutos e horas
    exibeNumero exibeMinutos (.Num(mins), .seg0(mins0), .seg1(mins1));
    exibeNumero exibeHoras (.Num(horas), .seg0(horas0), .seg1(horas1));

    // Conecte o sinal de LED ao output
    assign leds = led;

endmodule