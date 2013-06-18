module Display(
    input Clk,
    input Reset,
    input [7:0] DatoInit,
    input [7:0] DatoLCD,
    input Ejecutar,
    input Init,
    input Linea2,
    input Cuenta,
    output reg RS,
    output reg RW,
    output reg E,
    output reg [7:0] DB,
    output reg InitEscrito,
    output reg CharEscrito
              );

   parameter M = 1600000;    // 625ns -> 1.6MHz.
   
   reg [20:0] Timer;         // Clk Spartan 6: 100MHz.	
   
   reg Number;       

//***DECLARACIÓN DE LAS SEÑALES DE LA MAQUINA DE ESTADOS***

	 parameter [2:0] Iniciar        = 0;
	 parameter [2:0] EnEspera       = 1;
	 parameter [2:0] EscribirDato   = 2;
	 parameter [2:0] EscribirChar   = 3;
	 parameter [2:0] SegundaLinea   = 4;
	 parameter [2:0] EscrituraHecha = 5;

//***LOGICA DE ESTADO SIGUIENTE***

	 reg [2:0] EstadoActual, EstadoSiguiente;

	 always @ (negedge Clk) begin
	       if (Reset) EstadoActual <= Iniciar;
	           else 
             EstadoActual <= EstadoSiguiente;
	       end


	 always @ (EstadoActual, Ejecutar, Number, Init) begin
   case (EstadoActual)

	 Iniciar:	  	    if (Reset || Ejecutar || Init || Number) EstadoSiguiente <= EnEspera;
								        else EstadoSiguiente <= Iniciar;

	 EnEspera:		    if (Number && Init) EstadoSiguiente <= EscribirDato;
  	                    else if (Number && Ejecutar) EstadoSiguiente <= EscribirChar;
                                 else EstadoSiguiente <= EnEspera;

	 EscribirDato:		if (Number && Init) EstadoSiguiente <= EscrituraHecha;
								        else EstadoSiguiente <= EscribirDato;

	 EscribirChar:		if (Number && !Linea2 && Ejecutar) EstadoSiguiente <= EscrituraHecha;
								        else if (Number && Linea2 && Ejecutar) EstadoSiguiente <= SegundaLinea;
                                 else EstadoSiguiente <=  EscribirChar;

	 SegundaLinea:		if (Number && Cuenta) EstadoSiguiente <= EscrituraHecha;
								        else EstadoSiguiente <= SegundaLinea;   

	 EscrituraHecha:	EstadoSiguiente <= EnEspera;

   endcase
	 end
	 
   always @ (*)
   case (EstadoActual)

   Iniciar:begin
   RS = 0;
   RW = 0;
   E  = 0;
   DB = 0;
   InitEscrito = 0;
   CharEscrito = 0;
          end 

   EnEspera:begin
   RS = 0;
   RW = 0;
   E  = 0;
   DB = 0;
   InitEscrito = 0;
   CharEscrito = 0;
          end

   EscribirDato:begin
   RS = 0;
   RW = 0;
   E  = 1;
   DB = DatoInit;
   InitEscrito = 0;
   CharEscrito = 0;
                end

   EscribirChar:begin 
   RS = 1;
   RW = 0;
   E  = 1;
   DB = DatoLCD;
   InitEscrito = 0;
   CharEscrito = 0;
              end

   SegundaLinea:begin
	 RS = 0;
   RW = 0;
   E  = 1;
   DB = 8'h40;
   InitEscrito = 0;
   CharEscrito = 0;
               end

   EscrituraHecha:begin
   RS = 0;
   RW = 0;
   E  = 0;
   DB = 0;
   InitEscrito = 1;
   CharEscrito = 1;
                 end
   endcase

//***ENABLE DELAY***
 
  always @ (posedge Clk) begin

	      if (Reset) begin
            Timer <= 0;
            Number <= 0;
	          end else if (Timer == M) begin
                     Timer <= 0;
                     Number <= 1;
	                   end else begin
                     Timer <= Timer + 1;
                     Number <= 0;
	               end
        end

endmodule
