module Extend(
   input [23:0] ImmValue,
   input [1:0] ImmSrc,
   output reg [31:0] ExtImm
   );
  
   always @ (*) begin
      if(ImmSrc[1:0] == 2'b00) begin         //mov immediate needs only 8bits
         ExtImm[7:0] <= ImmValue[7:0];
         if(ImmValue[7] == 1'b1)
            ExtImm[31:8] <= 24'b111111111111111111111111;
         else
            ExtImm[31:8] <= 24'b0000000000000000000000;
      end
      else if(ImmSrc[1:0] == 2'b01) begin      //lw, sw needs only 12bits
         ExtImm[11:0] <= ImmValue[11:0];
         if(ImmValue[11] == 1'b1)
            ExtImm[31:12] <= 20'b11111111111111111111;
         else
            ExtImm[31:12] <= 20'b00000000000000000000;         
      end
      else if(ImmSrc[1:0] == 2'b10) begin      //branch needs 24bit offset
		 ExtImm[1:0] = 2'b00;
         ExtImm[25:2] <= ImmValue[23:0];
         if(ImmValue[23] == 1'b1)
            ExtImm[31:26] <= 6'b111111;
         else
            ExtImm[31:26] <= 6'b000000;
      end   
   end
endmodule