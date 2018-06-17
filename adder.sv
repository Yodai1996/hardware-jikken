`timescale 1ns / 1ps


module fadd(
  input wire [31:0] x1,
  input wire [31:0] x2,
  output wire [31:0] y,
  output wire ovf);
  
  wire s1;
  wire s2;
  wire [7:0] e1;
  wire [7:0] e2;
  wire [22:0] m1;  
  wire [22:0] m2;
     
  assign {s1, e1, m1}=x1;
  assign {s2, e2, m2}=x2;
  
  wire [24:0] m1a;
  wire [24:0] m2a;  

  assign m1a={2'b01, m1};  //ayasii
  assign m2a={2'b01, m2};
  
  wire [7:0] e1a;
  wire [7:0] e2a;  

  assign e1a=e1; //ayasii
  assign e2a=e2;  
 
  wire [7:0] e2ai;    
  assign e2ai=~e2a;  //ayasii
  
  wire [8:0] te; //nannbittoshiftsuruka
  assign te={1'b0, e1a}+{1'b0, e2ai};        
  
  wire ce;
  wire [7:0] tde;
  assign ce=~te[8];  //ayasii
  assign tde = (ce==0) ? (te+{9'b000000001})[7:0] : (~te)[7:0]; //ayasii

  wire [4:0] de;  
  assign de = tde>31 ? 31 : tde[4:0];    //ayasii
  
  wire sel;
  assign sel = (de==0) ? ((m1a > m2a) ? 0 : 1) : ce;  
  
  wire [24:0] ms;
  wire [24:0] mi;   
  wire [7:0] es;
  wire [7:0] ei;  
  wire  ss;
  
  assign ms = (sel==0) ? m1a : m2a ;
  assign mi = (sel==0) ? m2a : m1a ;
  assign es = (sel==0) ? e1a : e2a ;
  assign ei = (sel==0) ? e2a : e1a ;
  assign ss = (sel==0) ? s1  : s2  ;

  wire [55:0] mie;
  assign mie={mi, 31b'0};

  wire [55:0] mia;  
  assign mia=mie>>de; //ayasii
  
  wire tstck;
  assign tstck=|(mia[28:0]);
  
  
  wire [26:0] mye;
  assign mye = (s1==s2) ? {ms, 2'b0}+mia[55:29]  : {ms, 2'b0} - mia[55:29] ;  

  wire [7:0] esi;
  assign esi=es+1;
  
  wire [7:0] eyd;    
  wire [26:0] myd;
  wire stck;    
  
  assign myd = (mye[26]==0) ? mye  :  ( (esi==255) ?  {2'b01,25'b0} : mye>>1 )  ;  
  assign eyd = (mye[26]==0) ? es   :  ( (esi==255) ?  255 : esi ) ;  
  assign stck = (mye[26]==0) ? tstck :  tstck || mye[0] ;      

  wire [4:0] se;    
  assign se = (myd[25] == 1) ? 0 :
              (myd[24] == 1) ? 1 :
              (myd[23] == 1) ? 2 :
              (myd[22] == 1) ? 3 :
              (myd[21] == 1) ? 4 :
              (myd[20] == 1) ? 5 :
              (myd[19] == 1) ? 6 :              
              (myd[18] == 1) ? 7 :
              (myd[17] == 1) ? 8 :
              (myd[16] == 1) ? 9 :
              (myd[15] == 1) ? 10 :
              (myd[14] == 1) ? 11 :
              (myd[13] == 1) ? 12 :
              (myd[12] == 1) ? 13 :
              (myd[11] == 1) ? 14 :
              (myd[10] == 1) ? 15 :
              (myd[9] == 1) ? 16 :              
              (myd[8] == 1) ? 17 :
              (myd[7] == 1) ? 18 :
              (myd[6] == 1) ? 19 :
              (myd[5] == 1) ? 20 :
              (myd[4] == 1) ? 21 :
              (myd[3] == 1) ? 22 :
              (myd[2] == 1) ? 23 :
              (myd[1] == 1) ? 24 :
              (myd[0] == 1) ? 25 :  26;
              
  wire [8:0] eyf;      
  assign eyf = {1'b0, eyd} - {4'b0, se};

  wire [7:0] eyr;    
  wire [26:0] myf;
  assign myf = (eyf>0) ? myd<<se  : myd<<(eyd[4:0]-1) ;                
  assign eyr = (eyf>0) ? eyf[7:0] : 8'b0  ;                              

  wire [24:0] myr;  
  assign myr = ((myf[1] == 1 && myf[0] == 0 && stck == 0 && myf[2] == 1)||(myf[1] == 1 && myf[0] == 0 && s1 == s2 && stck ==1)||(myf[1] == 1 && myf[0] == 1)) ? myf[26:2] + 23’b1 : myf[26:2];
  
  wire [7:0] eyri;      
  assign eyri = eyr + 8'b1;
  
  wire [7:0] ey;        
  wire [22:0] my;          
  assign ey = (myr[24]==1) ? eyri  : ((&(myr[23:0])==0) ? 0 : eyr) ; //overflow arier.  honnmani 0 ka? 7'b0では?               
  assign my = (myr[24]==1) ? 23'b0 : ((&(myr[23:0])==0) ? 23'b0 : myr[22:0])  ;      
  
  wire sy;
  assign sy = (ey==0 && my==0) ? s1&&s2 : ss;
  
  wire nzm1;
  wire nzm2;
  assign nmz1 = |(m1[22:0]); 
  assign nmz2 = |(m2[22:0]);              
  
  //23だけ略
  assign y={sy,ey,my};
  
              
endmodule   
   
   
   
   
   
   
   
   
   
   
   
   
