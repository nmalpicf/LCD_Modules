module Display(
    input Clk,
    input Reset,
    input [7:0] DatoInit,
    input [7:0] DatoLCD,
    input Ejecutar,
    input Init,
    input DoneInit,
    input Linea2,
    input Lista,
    input WrittenLCD,
    input Cuenta,
    output reg RS,
    output reg RW,
    //output reg E,
    output reg [7:0] DB,
    output reg InitEscrito,
    output reg CaracterEscrito
    );

   parameter M = 55;        // 625ns -> 1.6MHz.              
   reg [6:0] Timer;        // Clk Spartan 6: 100MHz.	
   reg Number;       

//*****************************************************
// DECLARACIÓN DE LAS SEÑALES DE LA MAQUINA DE ESTADOS:	 

	 parameter [2:0] Iniciar        = 0;
	 parameter [2:0] EscribirDato   = 1;
	 parameter [2:0] EscribirChar   = 2;
	 parameter [2:0] SegundaLinea   = 3;
   	 parameter [2:0] DatoEscrito    = 4;
	 parameter [2:0] CharEscrito    = 5;
	 parameter [2:0] EscrituraHecha = 6;


//***************************
// LOGICA DE ESTADO SIGUIENTE

reg [2:0] EstadoActual, EstadoSiguiente;

always @ (negedge Clk) begin
       if (Reset) EstadoActual <= Iniciar;
	   else 
           EstadoActual <= EstadoSiguiente;
       end

 
always @ (*) begin  
       case (EstadoActual)

       Iniciar:	  	    if (Ejecutar && Init && !DoneInit) EstadoSiguiente <= EscribirDato; 
				else if (Ejecutar && Lista && DoneInit) EstadoSiguiente <= EscribirChar;
                                         else EstadoSiguiente <= Iniciar;
 
       EscribirDato:	    if (Number && Init && Ejecutar) EstadoSiguiente <= DatoEscrito;
                                else if (Number && Ejecutar && DoneInit) EstadoSiguiente <= EscrituraHecha;
                                         else EstadoSiguiente <= EscribirDato;

       EscribirChar:	    if (Number && Lista && !Linea2 && Ejecutar && !Cuenta ) EstadoSiguiente <= EscrituraHecha;
				else if (Linea2 && !Lista && Cuenta && Ejecutar && !Number) EstadoSiguiente <= SegundaLinea;
                                         else EstadoSiguiente <=  EscribirChar;

       SegundaLinea:        if (Number && Lista && !Linea2 && Ejecutar && !Cuenta ) EstadoSiguiente <= CharEscrito;
				else EstadoSiguiente <= SegundaLinea;   

       DatoEscrito:	    EstadoSiguiente <= Iniciar;

       CharEscrito:     EstadoSiguiente <= Iniciar;

       EscrituraHecha:  EstadoSiguiente <= Iniciar;

       endcase
end
	 
always @ (*)
       case (EstadoActual)

	  Iniciar:begin
	  RS = 0;
	  RW = 0;
	  DB = 0;
	  InitEscrito = 0;
	  CaracterEscrito = 0;
	          end 
	
	  EscribirDato:begin
	  RS = 0;
	  RW = 0;
	  DB = DatoInit;
	  InitEscrito = 1;
	  CaracterEscrito = 0;
	                end
	
	  EscribirChar:begin
	  RS = 1;
	  RW = 0;
	  DB = DatoLCD;
	  InitEscrito = 0;
	  CaracterEscrito = 1;
	              end
	
	  SegundaLinea:begin
		RS = 0;
	  RW = 0;
	  DB = 8'h18;
	  InitEscrito = 0;
	  CaracterEscrito = 0;
	               end
	
	  DatoEscrito: begin
	  RS = 0;
	  RW = 0;
	  DB = 0;
	  InitEscrito = 1;
	  CaracterEscrito = 0;
	                 end
	
	  CharEscrito: begin
	  RS = 0;
	  RW = 0;
	  DB = 0;
	  InitEscrito = 0;
	  CaracterEscrito = 1;
	                 end
	
	  CharEscrito: begin
	  RS = 0;
	  RW = 0;
	  DB = 0;
	  InitEscrito = 0;
	  CaracterEscrito = 0;
          		 end
       endcase
 
//**************
//  ENABLE DELAY
 
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
