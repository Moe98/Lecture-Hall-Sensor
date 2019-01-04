module lecturehall(led,clk,out1,out2,out3,echo,echo2,habd2,trig,trig2,habd,realTrig, redlightBulb, greenlightBulb);
output reg[6:0] out1;
output reg[6:0] out2,out3;
input clk; //clk coming from the FPGA board
reg clk2;
output reg redlightBulb, greenlightBulb; //slower clock and lightbulb regs
reg[150:0] cycle; 
output reg led;
reg [7:0] humanCount; //counts the number of human beings in the hall
reg [7:0] outCount; //counts the number of human beings out of the hall
reg [7:0] TotalCount; //counts the total number of human beings in and out of the hall
parameter max=9;
reg[150:0] echoStartCycle; 
integer distance;
reg[150:0] echoStartCycle2; 

output  trig;
reg trig;
output  trig2;
reg trig2;
input echo;
input echo2;

output realTrig;
reg realTrig;
output habd;
reg habd;
output habd2;
reg habd2;

//assign realTrig=trig;
/* To initialize parameters */
initial
	begin
		out1 <= 7'b1000000;
		out2 <= 7'b0100100;
		out3 <= 7'b1000000;
		clk2=1'b0;
	
		trig=0;
		trig2=0;
		realTrig=0;
		cycle<=151'b0;
		
		redlightBulb=1'b0;
		greenlightBulb=1'b0;
		led<=1'b0;
		
		humanCount<=8'd0;
		outCount<=8'd0;
		TotalCount<=8'd0;
		habd=1'b0;
		habd2=1'b0;
	end
	
/* To initialize parameters */
		
/*        Clock Module         */
always@(humanCount)
	begin
		if(humanCount==max)
			begin
				redlightBulb=1'b1;
				greenlightBulb=1'b0;
				led=1'b1;
			end
		else if(humanCount<max)
			begin
				led=1'b0;
				redlightBulb=1'b0;
				greenlightBulb=1'b1;
			end
	end	


always@(posedge clk)
	begin
		if(cycle==10000000)
			begin
				clk2=~clk2;
				cycle=0;
			end
		else
			begin
				cycle=cycle+1;
				if(clk2)
					begin
						trig=~trig;
						trig2=~trig2;
						
					end
			end
		realTrig=trig;
	end
	


	
always@(posedge clk2)
	begin
		if(habd==1'b1)
			begin
				if(humanCount<max)
					begin
						out1<=7'b1000000;
						out2<=7'b0100100;
						out3<=7'b1000000;
						humanCount= humanCount+1;
						case(humanCount)
						8'b00000000: out1 <= 7'b1000000;
						8'b00000001: out1 <= 7'b1111001;
						8'b00000010: out1 <= 7'b0100100; 
						8'b00000011: out1 <= 7'b0110000; 
						8'b00000100: out1 <= 7'b0011001; 
						8'b00000101: out1 <= 7'b0010010;
						8'b00000110: out1 <= 7'b0000010;
						8'b00000111: out1 <= 7'b1111000;
						8'b00001000: out1 <= 7'b0000000;
						8'b00001001: out1 <= 7'b0010000;
						default: out1 <= 7'b1000000;
						endcase
					end
			end
		if(habd2==1'b1)
			begin
				if(humanCount>0)
					begin
						out1<=7'b1000000;
						out2<=7'b0100100;
						out3<=7'b1000000;
						humanCount= humanCount-1;
						case(humanCount)
						8'b00000000: out1 <= 7'b1000000;
						8'b00000001: out1 <= 7'b1111001;
						8'b00000010: out1 <= 7'b0100100; 
						8'b00000011: out1 <= 7'b0110000; 
						8'b00000100: out1 <= 7'b0011001; 
						8'b00000101: out1 <= 7'b0010010;
						8'b00000110: out1 <= 7'b0000010;
						8'b00000111: out1 <= 7'b1111000;
						8'b00001000: out1 <= 7'b0000000;
						8'b00001001: out1 <= 7'b0010000;
						default: out1 <= 7'b1000000;
						endcase
					end
			end				
		case(humanCount)
			8'b00000000: out3 <= 7'b0010000;
			8'b00000001: out3 <= 7'b0000000;
			8'b00000010: out3 <= 7'b1111000; 
			8'b00000011: out3 <= 7'b0000010; 
			8'b00000100: out3 <= 7'b0010010; 
			8'b00000101: out3 <= 7'b0011001;
			8'b00000110: out3 <= 7'b0110000;
			8'b00000111: out3 <= 7'b0100100;
			8'b00001000: out3 <= 7'b1111001;
			8'b00001001: out3 <= 7'b1000000;
			default: out3 <= 7'b1000000;
			endcase
	end
always@(posedge echo)
		begin
			echoStartCycle=cycle;
		end

always@(posedge echo2)
		begin
			echoStartCycle2=cycle;
		end

always@(negedge echo)
		begin
			distance=(cycle-echoStartCycle);
			if(distance<0 & distance+10000000 <50*2900)
				begin
					habd=1'b1;
				end
			else if(distance >0 & distance<50*2900)
				habd=1'b1;
			else
				habd=1'b0;
		end


always@(negedge echo2)
		begin
			distance=(cycle-echoStartCycle2);
			if(distance<0 & distance+10000000 <50*2900)
				begin
					habd2=1'b1;
				end
			else if(distance >0 & distance<50*2900)
				habd2=1'b1;
			else
				habd2=1'b0;
		end
		
endmodule



