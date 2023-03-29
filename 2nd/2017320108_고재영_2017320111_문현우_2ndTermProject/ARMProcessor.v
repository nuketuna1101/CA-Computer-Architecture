module armreduced(
   input clk,//
   input reset,//
   output[31:0] pc,//done
   input[31:0] inst,//done
   input nIRQ,//?
   output[3:0] be,//done
   output[31:0] memaddr,//done
   output memwrite,//done
   output memread,//done
   output[31:0] writedata,//done
   input[31:0] readdata//done
   );
   assign be = 4'b1111; // default
   assign memread = 'b1; // default
 
   wire[31:0] pc_next;
   reg[31:0] pc_current;
   wire[31:0] pc_plus4;
   wire[31:0] pc_plus8;
   wire[31:0] ExtImm;
   wire[3:0] RA1;
   wire[3:0] RA2;
   wire[31:0] SrcA;
   wire[31:0] RD2;
   wire[31:0] SrcB;
   wire ALUFlags;
   wire PCSrc;
   wire MemtoReg;
   wire MemWrite;
   wire[1:0] ALUControl;
   wire ALUSrc;
   wire[1:0] ImmSrc;
   wire[1:0] RegWrite;
   wire RegSrc0;
   wire RegSrc1;
   wire[31:0] ALUResult;
   wire[31:0] WriteData;
   wire[31:0] ReadData;
   wire[31:0] Result;
   
   assign ReadData = readdata;
   assign writedata = RD2;
   assign pc = pc_current;
   assign memwrite = MemWrite;
   assign memaddr = ALUResult;
   
   always@(posedge reset or posedge clk)
   begin
      if(reset)
         pc_current <= 32'b00000000000000000000000000000000;
      else begin
         pc_current <= pc_next;
      end
   end   
   
   assign pc_plus4 = pc_current + 32'b00000000000000000000000000000100;//small alu
   assign pc_plus8 = pc_current + 32'b00000000000000000000000000001000;//small alu    
   
   RegisterFile RegisterFile1(.RA1(RA1), .RA2(RA2), .RA3(inst[15:12]), 
		.WD3(Result), .RegWrite(RegWrite), .PCPlus8(pc_plus8), 
		.CLK(clk), .RD1(SrcA), .RD2(RD2));
   
   ControlUnit control(.Cond(inst[31:28]), .Op(inst[27:26]), .Funct(inst[25:20]), 
		.Rd(inst[15:12]), .ZeroFlags(ALUFlags), .PCSrc(PCSrc), 
		.MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUControl(ALUControl), 
		.ALUSrc(ALUSrc), .ImmSrc(ImmSrc), 
		.RegWrite(RegWrite), .RegSrc0(RegSrc0), .RegSrc1(RegSrc1));
   
	Extend extend(.ImmValue(inst[23:0]), .ImmSrc(ImmSrc), .ExtImm(ExtImm));
   
	ALU alu(.SrcA(SrcA), .SrcB(SrcB), .ALUControl(ALUControl), .ALUFlags(ALUFlags), .ALU_Result(ALUResult));
   
   assign pc_next = (PCSrc == 1'b1)?Result:pc_plus4;//mux 0
   assign RA1 = (RegSrc0 == 1'b1)?4'b1111:inst[19:16];//mux 1
   assign RA2 = (RegSrc1 == 1'b1)?inst[15:12]:inst[3:0];//mux 2
   assign SrcB = (ALUSrc == 1'b1)?ExtImm:RD2;//mux 3
   assign Result = (MemtoReg == 1'b1)?ReadData:ALUResult;//mux 4
   
    
endmodule
