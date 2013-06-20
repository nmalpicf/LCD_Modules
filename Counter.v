module Counter (Clk, Reset, Cuenta, enable);
   
   input Clk;
   input Reset;
   output reg Cuenta; 
  
   parameter N = 4000000;    // 40us -> 25KHz.

   reg [21:0] Contador1;     // Clk Spartan 6: 100MHz.	

   parameter retardo = 55;   // 625ns -> 1.6MHz.
   reg [6:0] tiempo;         // Clk Spartan 6: 100MHz.	
   output reg enable; 
   reg Contador; 
   reg contar;    

always @ (posedge Clk) begin

	  if (Reset) begin
         tiempo <= 0;
         Contador <= 0;
	  end else if (contar) begin 
						if (tiempo == retardo) begin
                      tiempo <= 0;
                      Contador <= 1;
                  end else begin
                      tiempo <= tiempo + 1;
                      Contador <= 0;
	               end
     end
     end
     
	reg [1:0] EstadoActual, EstadoSiguiente;
   parameter enable0=0;
   parameter enable1=1;

always @ (negedge Clk) begin
	    if (Reset) EstadoActual <= enable0;
	        else 
           EstadoActual <= EstadoSiguiente;
	    end


always @ (*) begin
  	    case (EstadoActual)

	          enable0:    	if (!Cuenta) EstadoSiguiente <= enable0;
  	                  
																else EstadoSiguiente <= enable1;


	          enable1:  	  if (!Contador) EstadoSiguiente <= enable1;
			              
																else EstadoSiguiente <= enable0;

       endcase
end

always @ (*) begin
  	    case (EstadoActual)

       enable0: begin
                enable = 0;
                contar = 0;
                end
      
       enable1: begin
                enable = 1;
                contar = 1;
                end
       endcase
end
   

always @ (posedge Clk) begin
       if (Reset) begin
           Contador1 <= 0;
           Cuenta <= 0;
       end else begin
           if (Contador1 == N) begin
               Contador1 <= 0;
               Cuenta <= 1;
               end else begin
                   Contador1 <= Contador1 + 1;
                   Cuenta <= 0;
               end
            end
       end

endmodule
