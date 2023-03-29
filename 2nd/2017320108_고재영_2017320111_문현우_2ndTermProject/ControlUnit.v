module ControlUnit(
   input[3:0] Cond,      //4bits
   input[1:0] Op,         //2bits
   input[5:0] Funct,      //6bits
   input[3:0] Rd,         //4bits
   input ZeroFlags,
   output reg PCSrc,//0
   output reg MemtoReg,//1
   output reg MemWrite,//2
   output reg [1:0] ALUControl,
   output reg ALUSrc,//3
   output reg [1:0] ImmSrc,//4                  need to check each immsrc ###
   output reg [1:0]RegWrite,//5               need to check each RegWrite
   output reg RegSrc0,//6
   output reg RegSrc1//7
   );
   
   reg zero;
   //Suffixes : EQ, NE, (AL) ... Cond
   //Instructions : Arithmetic : add, sub, cmp, mov / ldr, str / b, bl
   //addressing modes
   
   always @ (Cond or ZeroFlags or Op or Funct) begin
		zero = ZeroFlags;
      if(Cond == 4'b0000) begin      //EQ
         MemtoReg <= 1'b0;
         MemWrite <= 1'b0;
         ALUControl <= 2'b00;
         ALUSrc <= 1'b1;
         ImmSrc <= 2'b10;//not sure
         RegWrite <= 2'b00;
         RegSrc0 <= 1'b1;
         RegSrc1 <= 1'b0;
         if(zero == 1'b1) begin      //flag set ... EQ-equal case
            PCSrc <= 1'b1;
         end
         else begin  //flag reset ... EQ-not equal case
            PCSrc <= 1'b0;
         end
      end
      else if (Cond == 4'b0001) begin      //NE
         MemtoReg <= 1'b0;
         MemWrite <= 1'b0;
         ALUControl <= 2'b00;
         ALUSrc <= 1'b1;
         ImmSrc <= 2'b10;      //not sure
         RegWrite <= 2'b00;
         RegSrc0 <= 1'b1;
         RegSrc1 <= 1'b0;
         if(zero == 1'b1) begin      //flag set ... NE-
            PCSrc <= 1'b0;
         end
         else begin
            PCSrc <= 1'b1;
         end
      end
      else if (Cond ==4'b1110) begin      //AL - Arith/LW,SW/B
         if(Op == 2'b00) begin      //arithmatic
            MemtoReg <= 1'b0;
            MemWrite <= 1'b0;
            ImmSrc <= 2'b00;//not sure
            if(Funct[4:1]==4'b0100)begin      //add
               ALUSrc <= 1'b0;
               RegWrite <= 2'b11;
               ALUControl <= 2'b00;
            end
            else if(Funct[4:1]==4'b0010)begin      //subtract
               ALUSrc <= 1'b0;
               RegWrite <= 2'b11;
               ALUControl <= 2'b01;
            end
            else if(Funct[4:0]==5'b10101)begin      //cmp
               RegWrite <= 2'b00;
               ALUControl <= 2'b01;      //cuz we need to subtract each value to compare
               if(Funct[5] == 1'b1)
                  ALUSrc <= 1'b1;
               else
                  ALUSrc <= 1'b0;
            end
            else if(Funct[4:1]==4'b1101)begin      //mov inst
               ALUControl <= 2'b11;
               RegWrite <= 2'b00;
               if(Funct[5] == 1'b1)      //for imm
                  ALUSrc <= 1'b1;
               else         //for reg
                  ALUSrc <= 1'b0;
            end
         end
         else if(Op == 2'b01) begin      //lw, sw
            PCSrc <= 1'b0;
            MemtoReg <= 1'b1;
            ALUControl <= 2'b00;
            ALUSrc <= 1'b1;
            ImmSrc <= 2'b01;      //12bit for imm
            RegSrc0 <= 1'b0;
            RegSrc1 <= 1'b1;
            if (Funct[2]==1'b0 && Funct[0]==1'b0) begin      //str
               MemWrite <= 1'b1;
               RegWrite <= 2'b11;
            end
            if (Funct[2]==1'b0 && Funct[0]==1'b1) begin      //ldr
               MemWrite <= 1'b0;
               RegWrite <= 2'b11;         
            end            
         end
         else if(Op == 2'b10) begin     //branch
         if(Funct[4] == 1'b0)begin
            ALUControl <= 2'b00;
            PCSrc <= 1'b1;
            MemtoReg <= 1'b0;
            MemWrite <= 1'b0;
            ALUSrc <= 1'b0;
            ImmSrc <= 2'b10;      //24bit offset
            RegWrite <= 2'b00;
            RegSrc0 <= 1'b1;
            RegSrc1 <= 1'b0; 
            end
         if(Funct[4] == 1'b1)begin
            ALUControl <= 2'b00;
            PCSrc <= 1'b1;
            MemtoReg <= 1'b0;
            MemWrite <= 1'b0;
            ALUSrc <= 1'b0;
            ImmSrc <= 2'b10;      //24bit offset
            RegWrite <= 2'b01;
            RegSrc0 <= 1'b1;
            RegSrc1 <= 1'b0; 
            end
         end
      end
   end
   
endmodule