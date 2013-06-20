module Init(
    input Clk,
    input Reset,
    input Cuenta,
    input Comenzar,
    output [7:0] DatoInit,
    output Init,
    output DoneInit
    );
	 
//****************************************************
// DECLARACIÓN DE LAS SEÑALES DE LA MAQUINA DE ESTADOS	 

	 parameter [3:0] Encender    = 0;
	 parameter [3:0] Hex38       = 1;
	 parameter [3:0] Hex38_1     = 2;
	 parameter [3:0] Hex38_2     = 3;
   	 parameter [3:0] Hex38_3     = 4;
	 parameter [3:0] Hex30       = 5;
	 parameter [3:0] Hex8        = 6;
	 parameter [3:0] Hex06       = 7;
	 parameter [3:0] Hex01       = 8;
	 parameter [3:0] Hex80       = 9;
	 parameter [3:0] Hex0F       = 10;
	 parameter [3:0] Iniciohecho = 11;
	 

//***************************
// LOGICA DE ESTADO SIGUIENTE

	 
reg [3:0] EstadoActual, EstadoSiguiente;

always @ (negedge Clk) begin
       if (Reset) EstadoActual <= Encender;
	   else 
           EstadoActual <= EstadoSiguiente;
       end
	 

always @ (*) begin
       case (EstadoActual)

	 Encender:   if (Comenzar) EstadoSiguiente <= Hex38;	          // Si han pasado 40us ->  
			 else EstadoSiguiente <= Encender;

	 Hex38:	     if (Cuenta && !Reset ) EstadoSiguiente <= Hex38_1;	  // Si han pasado 40us -> Modo de Transferencia 8'b
			 else EstadoSiguiente <= Hex38; 

	 Hex38_1:    if (Cuenta && !Reset ) EstadoSiguiente <= Hex38_2;	  // Si han pasado 40us -> Modo de Transferencia 8'b
			 else EstadoSiguiente <= Hex38_1; 

	 Hex38_2:    if (Cuenta && !Reset ) EstadoSiguiente <= Hex38_3;	  // Si han pasado 40us -> Modo de Transferencia 8'b
			 else EstadoSiguiente <= Hex38_2;

	 Hex38_3:    if (Cuenta && !Reset ) EstadoSiguiente <= Hex30;	  // Si han pasado 40us -> Modo de Transferencia 8'b
			 else EstadoSiguiente <= Hex38_3;

	 Hex30:	     if (Cuenta && !Reset ) EstadoSiguiente <= Hex8;	  // Si han pasado 40us -> Modo de Transferencia 8'b
			 else EstadoSiguiente <= Hex30; 

	 Hex8:	     if (Cuenta && !Reset ) EstadoSiguiente <= Hex06;	  // Si han pasado 40us -> Modo de Transferencia 8'b
			 else EstadoSiguiente <= Hex8; 

	 Hex06:	     if (Cuenta && !Reset) EstadoSiguiente <= Hex01;	  // Si han pasado 40us -> Clears Display
			 else EstadoSiguiente <= Hex06; 

	 Hex01:	     if (Cuenta && !Reset) EstadoSiguiente <= Hex80;	  // Si han pasado 40us -> Forma de entrada de datos hacia la derecha.  
			 else EstadoSiguiente <= Hex01; 
                  
	 Hex80:	     if (Cuenta && !Reset) EstadoSiguiente <= Hex0F;      // Si han pasado 40us -> Acceso a posicion 0 de la DD Ram
			 else EstadoSiguiente <= Hex80;

	 Hex0F:	     if (Cuenta && !Reset) EstadoSiguiente <= Iniciohecho;// Si han pasado 40us -> Display On/off, Cursor on
			 else EstadoSiguiente <= Hex0F;

	 Iniciohecho:	 EstadoSiguiente <= Iniciohecho;
	 
	 endcase
	 end

//*********************	 
// FIN DE LA INICIACIÓN

	assign DatoInit = (EstadoActual == Hex38) ? 8'h38 : 
							 (EstadoActual == Hex38_1) ? 8'h38 :
							 (EstadoActual == Hex38_2) ? 8'h38 :
                          (EstadoActual == Hex38_3) ? 8'h38 :
							 (EstadoActual == Hex30) ? 8'h30 :
							 (EstadoActual == Hex8) ? 8'h8 :
						         (EstadoActual == Hex06) ? 8'h06 : 
						         (EstadoActual == Hex01) ? 8'h01 :  
						         (EstadoActual == Hex80) ? 8'h80 : 
						         (EstadoActual == Hex0F) ? 8'h0F : 8'h00; // Posición del Cursor

        assign Init = (EstadoActual == Hex38) ? 1'b1 : 
						         (EstadoActual == Hex38_1) ? 1'b1 :
                      (EstadoActual == Hex38_2) ? 1'b1 :
                      (EstadoActual == Hex38_3) ? 1'b1 :
						         (EstadoActual == Hex30) ? 1'b1 :
						         (EstadoActual == Hex8) ? 1'b1 : 
						         (EstadoActual == Hex06) ? 1'b1 : 
						         (EstadoActual == Hex01) ? 1'b1 :
						         (EstadoActual == Hex80) ? 1'b1 : 
						         (EstadoActual == Hex0F) ? 1'b1 :1'b0;
						
	 assign DoneInit = (EstadoActual == Hex38) ? 1'b0 : 
						         (EstadoActual == Hex38_1) ? 1'b0 : 
                           (EstadoActual == Hex38_2) ? 1'b0 :
                           (EstadoActual == Hex38_3) ? 1'b0 : 
							 (EstadoActual == Hex30) ? 1'b0 :
							 (EstadoActual == Hex8) ? 1'b0 :
						         (EstadoActual == Hex06) ? 1'b0 :
						         (EstadoActual == Hex01) ? 1'b0 : 
						         (EstadoActual == Hex80) ? 1'b0 : 
						         (EstadoActual == Hex0F) ? 1'b0 : 
                           (EstadoActual == Iniciohecho) ? 1'b1 : 1'b0;



endmodule
