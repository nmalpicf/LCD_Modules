module Counter (Clk, Reset, Cuenta);
   
   input Clk;
   input Reset;
   output reg Cuenta; 
  
   parameter N = 25000;   // 40us -> 25KHz.

   reg [19:0] Contador;   // Clk Spartan 6: 100MHz.	

   always @ (posedge Clk) begin

          if (Reset) begin
              Contador <= 0;
              Cuenta <= 0;
          end else begin
              if (Contador == N) begin
                  Contador <= 0;
                  Cuenta <= 1;
              end else begin
                       Contador <= Contador + 1;
                       Cuenta <= 0;
                  end
              end
   end

endmodule
