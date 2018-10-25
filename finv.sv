`timescale 1ns / 1ps

//とりあえず組み合わせ回路で実現しようか

module finv(
  input wire [31:0] x,
  output wire [31:0] y);
  
  wire sx;
  wire [7:0] ex;
  wire [22:0] mx;
  
  assign {sx,ex,mx}=x;
  
  //25bit_verに対応させた
  wire [24:0] twice;
  wire [24:0] square;
  
  //テーブルをもとに作成
  assign twice = 
    () ? ..... :
    () ? ..... : ...
  
  assign square = ...
    
  wire [24:0] manx;
  assign manx = {1'b1, mx, 1'b0};  
  
  //same to [49:0], because b[49] is definetly 0
  wire [48:0] b;
  assign b = manx * square;
  
  wire [24:0] m_inv;
  assign m_inv = twice - b[48:24];  //ここでも切り捨ててるけど大丈夫かな？
  
  //基本的にm_invの最上位bitは0になり、次のbitが1になるはずであり、このとき残り23bitをか仮数部とすればよい。
  //基本的にはstate==0なはず
  wire state;
  assign state = m_inv[24] ;
  
  wire [7:0] ey;
  assign ey = state ? (8'd254 - ex) : (8'd253 - ex) ;
  
  wire [22:0] my;
  assign my = state ? m_inv[23:1] : m_inv[22:0];
  
  assign y = {sx, ey,  my};

endmodule   
   
   
   
   
   
   
   
   
   
   
   
   

