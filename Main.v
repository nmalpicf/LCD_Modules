module Main(
       input Clk,
       input Reset,
       input Mostrar,
    /* input Data,
       input Weight,
       input Value, */ 
       input Cuenta,
       output [7:0] DatoLCD,
       output Linea2,
       output Lista,
       output WrittenLCD
           );

//***PARAMETROS PARA ASIGNACION DE CARACTERES EN BINARIO 8B***

parameter [7:0] 			 A=8'b 0100_0001, a=8'b 0110_0001,
					             B=8'b 0100_0010, b=8'b	0110_0010,
					             C=8'b 0100_0011, c=8'b 0110_0011,
             					 D=8'b 0100_0100, d=8'b 0110_0100,
            					 E=8'b 0100_0101, e=8'b 0110_0101,
					             F=8'b 0100_0110, f=8'b 0110_0110,
            					 G=8'b 0100_0111, g=8'b 0110_0111,
  					           H=8'b 0100_1000, h=8'b 0110_1000,
					             I=8'b 0100_1001, i=8'b 0110_1001,
					             J=8'b 0100_1010, j=8'b 0110_1010,
					             K=8'b 0100_1011, k=8'b 0110_1011,
					             L=8'b 0100_1100, l=8'b 0110_1100,
					             M=8'b 0100_1101, m=8'b 0110_1101,
					             N=8'b 0100_1110, n=8'b 0110_1110,
					             O=8'b 0100_1111, o=8'b 0110_1111,
					             P=8'b 0101_0000, p=8'b 0111_0000,
					             Q=8'b 0101_0001, q=8'b 0111_0001,
					             R=8'b 0101_0010, r=8'b 0111_0010,
					             S=8'b 0101_0011, s=8'b 0111_0011,
					             T=8'b 0101_0100, t=8'b 0111_0100,
					             U=8'b 0101_0101, u=8'b 0111_0101,
					             V=8'b 0101_0110, v=8'b 0111_0110,
            					 W=8'b 0101_0111, w=8'b 0111_0111,
					             X=8'b 0101_1000, x=8'b 0111_1000,
					             Y=8'b 0101_1001, y=8'b 0111_1001,
					             Z=8'b 0101_1010, z=8'b 0111_1010,
					 
					             ESPACIO=8'b 0010_0000, 
                       END_MESSAGE=8'b 0000_0000,
					 
					             CERO=8'b 0011_0000, UNO=8'b 0011_0001, DOS=8'b 0011_0010,
					             TRES=8'b 0011_0011, CUATRO=8'b 0011_0100, CINCO=8'b 0011_0101,
					             SEIS=8'b 0011_0110, SIETE=8'b 0011_0111, OCHO=8'b 0011_1000,
					             NUEVE=8'b 0011_1001,
					 
					             shift_line=8'b 1100_0000, 
                       signo_pesos=8'b 0010_0100, 
                       signo_admiracion=8'b 0010_0001,
					             dos_puntos=8'b 0011_1010;

//***PARAMETROS PARA ASIGNACION DE CARACTERES EN BINARIO 8B (Estados)***

                    	 parameter [5:0] Inicio = 0;
                    	 parameter [5:0] Char1_1 = 1;
                    	 parameter [5:0] Char1_2 = 2;
                    	 parameter [5:0] Char1_3 = 3;
                    	 parameter [5:0] Char1_4 = 4;
                    	 parameter [5:0] Char1_5 = 5;
                    	 parameter [5:0] Char1_6 = 6;
                    	 parameter [5:0] Char1_7 = 7;
                    	 parameter [5:0] Char1_8 = 8;
                    	 parameter [5:0] Char1_9 = 9;
                    	 parameter [5:0] Char1_10 = 10;
                    	 parameter [5:0] Char1_11 = 11;
                    	 parameter [5:0] Char1_12 = 12;
                    	 parameter [5:0] Char1_13 = 13;
                    	 parameter [5:0] Char1_14 = 14;
                    	 parameter [5:0] Char1_15 = 15;
                    	 parameter [5:0] Char1_16 = 16;
                    	 parameter [5:0] SiguienteLinea = 17;
                    	 parameter [5:0] Char2_1 = 18;
                    	 parameter [5:0] Char2_2 = 19;
                    	 parameter [5:0] Char2_3 = 20;
                    	 parameter [5:0] Char2_4 = 21;
                    	 parameter [5:0] Char2_5 = 22;
                    	 parameter [5:0] Char2_6 = 23;
                    	 parameter [5:0] Char2_7 = 24;
                    	 parameter [5:0] Char2_8 = 25;
                    	 parameter [5:0] Char2_9 = 26;
                    	 parameter [5:0] Char2_10 = 27;
                    	 parameter [5:0] Char2_11 = 28;
                    	 parameter [5:0] Char2_12 = 29;
                    	 parameter [5:0] Char2_13 = 30;
                    	 parameter [5:0] Char2_14 = 31;
                    	 parameter [5:0] Char2_15 = 32;
                    	 parameter [5:0] Char2_16 = 33;
                    	 parameter [5:0] Fin = 34;

//***LOGICA DE ESTADO SIGUIENTE***

reg [5:0] Siguiente, Actual;

always @ (negedge Clk) begin
          if (Reset) Actual <= Inicio;
	  	       else 
             Actual <= Siguiente;
	        end

//***CAMBIO DE ESTADOS PARA ESCRIBIR SEGUIDO***

always @ (Mostrar, Actual, Cuenta) begin
	 case (Actual)

	 Inicio:		if (Mostrar) Siguiente <= Char1_1;
							else Siguiente <= Inicio;
	            				
	 Char1_1:   if(Cuenta == 1) Siguiente <= Char1_2;
						  else Siguiente <= Char1_1;
											
	 Char1_2:  	if(Cuenta == 1) Siguiente <= Char1_3;
							else Siguiente <= Char1_2;
           	
	 Char1_3:		if(Cuenta == 1) Siguiente <= Char1_4;
							else Siguiente <= Char1_3;

	 Char1_4:		if(Cuenta == 1) Siguiente <= Char1_5;
							else Siguiente <= Char1_4;

	 Char1_5:		if(Cuenta == 1) Siguiente <= Char1_6;
							else Siguiente <= Char1_5;

	 Char1_6:		if(Cuenta == 1) Siguiente <= Char1_7;
							else Siguiente <= Char1_6;

	 Char1_7:		if(Cuenta == 1) Siguiente <= Char1_8;
							else Siguiente <= Char1_7;

	 Char1_8:		if(Cuenta == 1) Siguiente <= Char1_9;
							else Siguiente <= Char1_8;

	 Char1_9:		if(Cuenta == 1) Siguiente <= Char1_10;
							else Siguiente <= Char1_9;

	 Char1_10:	if(Cuenta == 1) Siguiente <= Char1_11;
							else Siguiente <= Char1_10;

	 Char1_11:	if(Cuenta == 1) Siguiente <= Char1_12;
							else Siguiente <= Char1_11;

	 Char1_12:	if(Cuenta == 1) Siguiente <= Char1_13;
							else Siguiente <= Char1_12;

	 Char1_13:	if(Cuenta == 1) Siguiente <= Char1_14;
							else Siguiente <= Char1_13;

	 Char1_14:	if(Cuenta == 1) Siguiente <= Char1_15;
							else Siguiente <= Char1_14;

	 Char1_15:	if(Cuenta == 1) Siguiente <= Char1_16;
							else Siguiente <= Char1_15;

	 Char1_16:	if(Cuenta == 1) Siguiente <= SiguienteLinea;
							else Siguiente <= Char1_16;

	 SiguienteLinea:		if(Cuenta == 1) Siguiente <= Char2_1;
							        else Siguiente <= SiguienteLinea;

	 Char2_1:		if(Cuenta == 1) Siguiente <= Char2_2;
							else Siguiente <= Char2_1;

	 Char2_2:		if(Cuenta == 1) Siguiente <= Char2_3;
							else Siguiente <= Char2_2;

	 Char2_3:		if(Cuenta == 1) Siguiente <= Char2_4;
							else Siguiente <= Char2_3;

	 Char2_4:		if(Cuenta == 1) Siguiente <= Char2_5;
							else Siguiente <= Char2_4;

	 Char2_5:		if(Cuenta == 1) Siguiente <= Char2_6;
							else Siguiente <= Char2_5;

	 Char2_6:		if(Cuenta == 1) Siguiente <= Char2_7;
							else Siguiente <= Char2_6;

	 Char2_7:	  if(Cuenta == 1) Siguiente <= Char2_8;
							else Siguiente <= Char2_7;

	 Char2_8:	  if(Cuenta == 1) Siguiente <= Char2_9;
							else Siguiente <= Char2_8;

	 Char2_9:		if(Cuenta == 1) Siguiente <= Char2_10;
							else Siguiente <= Char2_9;

	 Char2_10:	if(Cuenta == 1) Siguiente <= Char2_11;
							else Siguiente <= Char2_10;

	 Char2_11:	if(Cuenta == 1) Siguiente <= Char2_12;
							else Siguiente <= Char2_11;
							
	 Char2_12:	if(Cuenta == 1) Siguiente <= Char2_13;
							else Siguiente <= Char2_12;

	 Char2_13:	if(Cuenta == 1) Siguiente <= Char2_14;
							else Siguiente <= Char2_13;

	 Char2_14:  if(Cuenta == 1) Siguiente <= Char2_15;
							else Siguiente <= Char2_14;

	 Char2_15:	if(Cuenta == 1) Siguiente <= Char2_16;
							else Siguiente <= Char2_15;

	 Char2_16:	if(Cuenta == 1) Siguiente <= Fin;
							else Siguiente <= Char2_16;		
					
   Fin:       Siguiente <= Lista;

	 endcase
	 end

//***ASIGNACION DE LETRAS A DATOS LCD***LOGICA DE SALIDA***

assign DatoLCD =(Actual == Char1_1) ? P : 
  						  (Actual == Char1_2) ? E : 
  						  (Actual == Char1_3) ? S : 
  						  (Actual == Char1_4) ? O : 
  						  (Actual == Char1_5) ? ESPACIO : 
  						  (Actual == Char1_6) ? P : 
  						  (Actual == Char1_7) ? R : 
  						  (Actual == Char1_8) ? E : 
  						  (Actual == Char1_9) ? C : 
  						  (Actual == Char1_10) ? I : 
  						  (Actual == Char1_11) ? O : 
  						  (Actual == Char1_12) ? ESPACIO : 
  						  (Actual == Char1_13) ? I : 
  						  (Actual == Char1_14) ? D : 
  						  (Actual == Char1_15) ? ESPACIO : 
  						  (Actual == Char1_15) ? M : 
  						  (Actual == Char2_1) ? UNO://[4] weightvector: 
  						  (Actual == Char2_2) ? DOS://[3] weightvector: 
  						  (Actual == Char2_3) ? UNO://[2] weightvector: 
  						  (Actual == Char2_4) ? DOS://[1] weightvector: 
  						  (Actual == Char2_5) ? UNO://[0] weightvector: 
  						  (Actual == Char2_6) ? DOS://[5] pricevector: 
  						  (Actual == Char2_7) ? UNO://[4] pricevector: 
  						  (Actual == Char2_8) ? DOS://[3] pricevector: 
  						  (Actual == Char2_9) ? UNO://[2] pricevector: 
  						  (Actual == Char2_10) ? DOS://[1] pricevector: 	  
  						  (Actual == Char2_11) ? UNO://[0] pricevector: 
  						  (Actual == Char2_12) ? DOS://[3] idvector: 
  						  (Actual == Char2_13) ? UNO://[2] idvector: 
  						  (Actual == Char2_14) ? DOS://[1] idvector:
  						  (Actual == Char2_15) ? UNO://[0] idvector:
  						  (Actual == Char2_16) ? CERO:8'h10;//[1] mode: 8'h10;
							 
assign Linea2 = (Actual == SiguienteLinea) ? 1'b1 : 1'b0;

assign Lista =  (Actual == Char1_1) ? 1'b1 : 
  						  (Actual == Char1_2) ? 1'b1: 
  						  (Actual == Char1_3) ? 1'b1 : 
  						  (Actual == Char1_4) ? 1'b1 : 
  						  (Actual == Char1_5) ? 1'b1 : 
  						  (Actual == Char1_6) ? 1'b1 : 
  						  (Actual == Char1_7) ? 1'b1 : 
  						  (Actual == Char1_8) ? 1'b1 : 
  						  (Actual == Char1_9) ? 1'b1 : 
  						  (Actual == Char1_10) ? 1'b1 : 
  						  (Actual == Char1_11) ? 1'b1 : 
  						  (Actual == Char1_12) ? 1'b1 : 
  						  (Actual == Char1_13) ? 1'b1 : 
  						  (Actual == Char1_14) ? 1'b1 : 
  						  (Actual == Char1_15) ? 1'b1 : 
  						  (Actual == Char1_15) ? 1'b1 : 
  						  (Actual == Char2_1) ? 1'b1 : 
  						  (Actual == Char2_2) ? 1'b1 : 
  						  (Actual == Char2_3) ? 1'b1 : 
  						  (Actual == Char2_4) ? 1'b1 :
  						  (Actual == Char2_5) ? 1'b1 : 
  						  (Actual == Char2_6) ? 1'b1 :
  						  (Actual == Char2_7) ? 1'b1 :
  						  (Actual == Char2_8) ? 1'b1 : 
  						  (Actual == Char2_9) ? 1'b1 : 
  						  (Actual == Char2_10) ? 1'b1 : 	  
  						  (Actual == Char2_11) ? 1'b1 : 
  						  (Actual == Char2_12) ? 1'b1 :
  						  (Actual == Char2_13) ? 1'b1 : 
  						  (Actual == Char2_14) ? 1'b1 :
  						  (Actual == Char2_15) ? 1'b1 :
  						  (Actual == Char2_16) ? 1'b1 : 1'b0;

assign WrittenLCD = (Actual == Fin) ? 1'b1 : 1'b0;
							
endmodule
