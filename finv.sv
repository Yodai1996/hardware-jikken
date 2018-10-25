`timescale 1ns / 1ps

//when x<0, returns 1

module finv(
  input wire [31:0] x,
  output wire [31:0] y);
  
  wire sx;
  wire [7:0] ex;
  wire [22:0] mx;
  
  assign {sx,ex,mx}=x;
  
  
  
  
  
  assign y = (x[31]==1 && x[30:23] !=8'b0) ? 1 : 0;

endmodule   
   
   
   
   
   
   
   
   
   
   
   
   

