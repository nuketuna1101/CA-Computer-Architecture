module ALU(
   input wire [31:0] SrcA,
   input wire [31:0] SrcB,
   input wire [1:0] ALUControl,
   output wire ALUFlags,
   output wire [31:0] ALU_Result
   );

   integer in1, in2, out;
   reg Zero;
   
   always @(*)
   begin

      in1 = SrcA;
      in2 = SrcB;

      case(ALUControl)
      2'b00://add
         out = SrcA + SrcB;
      2'b01://sub
         out = SrcA - SrcB;
      2'b10://AND
         out = SrcA&SrcB;
      2'b11://MOV
         out = SrcB;
      default : out = SrcA + SrcB;
      endcase

      if(out == 32'b00000000000000000000000000000000)begin
         Zero = 1'b1;
      end
      else
         Zero = 1'b0;
   end

   assign ALUFlags = Zero;
   assign ALU_Result = out;   
   
endmodule
