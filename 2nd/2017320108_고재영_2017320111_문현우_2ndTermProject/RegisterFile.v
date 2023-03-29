module RegisterFile(
   input [3:0] RA1,
   input [3:0] RA2,
   input [3:0] RA3,
   input [31:0] WD3, 
   input [1:0] RegWrite,
   input [31:0] PCPlus8,
   input [31:0] PCPlus4,
   input CLK,
   output reg [31:0] RD1,
   output reg [31:0] RD2
   );
   
   reg [31:0] register[0:15];
   reg[3:0] r3;
   reg[1:0] write;
   
   initial begin
		 register[0] <= 32'b00000000000000000000000000000000;
         register[1] <= 32'b00000000000000000000000000000000;
         register[2] <= 32'b00000000000000000000000000000000;
         register[3] <= 32'b00000000000000000000000000000000;
         register[4] <= 32'b00000000000000000000000000000000;
         register[5] <= 32'b00000000000000000000000000000000;
         register[6] <= 32'b00000000000000000000000000000000;
         register[7] <= 32'b00000000000000000000000000000000;
         register[8] <= 32'b00000000000000000000000000000000;
         register[9] <= 32'b00000000000000000000000000000000;
         register[10] <= 32'b00000000000000000000000000000000;
         register[11] <= 32'b00000000000000000000000000000000;
         register[12] <= 32'b00000000000000000000000000000000;
         register[13] <= 32'b00000000000000000000000000000000;
         register[14] <= 32'b00000000000000000000000000000000;
         register[15] <= 32'b00000000000000000000000000000000;
	end
      
   always @(posedge CLK) begin
         write <= RegWrite;
         r3[3:0] <= RA3;
         RD2[31:0] <= register[RA2];
         if(RegWrite[1:0] == 2'b00 || RegWrite[1:0] == 2'b01)begin
			RD1 <= PCPlus8;
		 end
		 else begin
			RD1 <= register[RA1];
		 end
      end
  

   always @(negedge CLK) begin
      if(write[1:0] == 2'b01) begin
         register[15] <= PCPlus8;
         register[14] <= PCPlus4; 
      end
      if(write[1:0] == 2'b00) begin
         register[15] <= PCPlus8;
      end
      if(write[1:0] == 2'b11)begin
         register[r3] <= WD3;
      end
   end
endmodule
