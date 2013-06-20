module Controller(
    input Clk,
    input Reset,
    input Cuenta,
    input Init,
    input InitEscrito,
    input DoneInit,
    input Lista,
    input CaracterEscrito,
    input WrittenLCD,
    input Enter,
    input Delete,
    output reg Comenzar,
    output reg Mostrar,
    output reg Ejecutar
    );

   
//*****************************************************
// DECLARACIÓN DE LAS SEÑALES DE LA MAQUINA DE ESTADOS:	 

	 parameter [2:0] BeginControl   = 0;
	 parameter [2:0] Initial        = 1;
	 parameter [2:0] EnableInit     = 2;
   	 parameter [2:0] DoneInitial    = 3;
	 parameter [2:0] Main           = 4;
	 parameter [2:0] EnableMain     = 5;
   	 parameter [2:0] DoneMain       = 6;
	 parameter [2:0] EndControl     = 7;


//***************************
// LOGICA DE ESTADO SIGUIENTE

reg [2:0] EstadoActual, EstadoSiguiente;

always @ (negedge Clk) begin
	  if (Reset) EstadoActual <= Initial;
	      else 
              EstadoActual <= EstadoSiguiente;
	  end


always @ (*) begin
	case (EstadoActual)


	 Initial:    	    if (Init) EstadoSiguiente <= EnableInit;
  	                    else EstadoSiguiente <= Initial;

	 EnableInit:  	  if (InitEscrito) EstadoSiguiente <= DoneInitial;
			                  else EstadoSiguiente <= EnableInit;

	 DoneInitial:  	  if (DoneInit) EstadoSiguiente <= Main;
			                  else EstadoSiguiente <= EnableInit;

	 Main:            if (Lista) EstadoSiguiente <= EnableMain;
			                  else EstadoSiguiente <= Main;

	 EnableMain:  	  if (CaracterEscrito) EstadoSiguiente <= DoneMain;
			                  else EstadoSiguiente <= EnableMain;  

	 DoneMain:  	    if (WrittenLCD) EstadoSiguiente <= EndControl;
			                  else EstadoSiguiente <= EnableMain; 

	 EndControl:      EstadoSiguiente <= Main;

	endcase
	end
	 
always @ (*)
	case (EstadoActual) 
	
	  Initial:begin
	  Comenzar = 1;
	  Mostrar = 0;
	  Ejecutar = 0;
	  end
	
	  EnableInit:begin
	  Comenzar = 0;
	  Mostrar = 0;
	  Ejecutar = 1;
	  end
	
	  DoneInitial:begin
	  Comenzar = 1;
	  Mostrar = 0;
	  Ejecutar = 0;
	  end
	
	  Main:begin
	  Comenzar = 0;
	  Mostrar = 1;
	  Ejecutar = 0;
	  end
	
	  EnableMain:begin
	  Comenzar = 0;
	  Mostrar = 0;
	  Ejecutar = 1;
	  end
	
	  DoneMain:begin
	  Comenzar = 0;
	  Mostrar = 1;
	  Ejecutar = 0;
	  end
	
	  EndControl:begin
	  Comenzar = 0;
	  Mostrar = 0;
	  Ejecutar = 1;
	  end

	endcase
	 
endmodule
