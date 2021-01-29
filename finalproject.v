module finalproject(clk,rows,columns,signalout,LEDs, Hex0, Hex1, Hex2, Hex3, Hex4, Hex5);
	input clk;
	input [3:0] rows;
	output [3:0]columns;
	output [7:0] LEDs;
	output signalout;
	output[6:0] Hex0, Hex1, Hex2, Hex3, Hex4, Hex5;
	rotatingdisplay myrotatingdisplay(clk, Hex0, Hex1, Hex2, Hex3, Hex4, Hex5);
	keypad mykeypad(clk,rows,columns, LEDs,signalout);
	
endmodule //end of top module

module keypad(clk,rows,columns, LEDs,signalout);
	input clk;
	input [3:0] rows;
	output [3:0]columns;
	output [7:0] LEDs;
	wire[7:0] buttonvalue;
	wire[3:0] button;
	output signalout;
	wire [31:0] countlow, counthigh;
	wire signalout;
	wire push;
	
	keydebounce mykeydebounce(clk,rows,columns, button,LEDs);
	tonedata mytonedata(clk,button, countlow, counthigh);
	toneprocessor mytoneprocessor(clk, countlow, counthigh, signalout);
endmodule


module keydebounce(clk,rows,columns, button,LEDs);

	input clk;
	input [3:0] rows;
	output [3:0]columns;
	output [3:0] button;
	reg [3:0] button;
	output [7:0] LEDs;
	reg [7:0] LEDs;

	
	reg [3:0]columns;
	
	reg [4:0] progress;
	reg [31:0] counter;
	reg [15:0] val1;
	reg [15:0] val2;
	
	
	initial begin
		progress=5'b00000;
		counter=0;
		button=0;
	end//end of initial
	always@(posedge clk) begin
		counter=counter+1'b1;
		case(progress)
			default: begin
				progress = 5'b00000;
				end
			//Read col 0
			5'b00000: begin
				columns = 4'b1110;
				if(counter>=10) begin
					val1[3:0]=~rows;
					progress=5'b00001;
					counter =0;
					end
				end
			//Read col 1
			5'b00001: begin
				columns = 4'b1101;
				if(counter>=10) begin
					val1[7:4]=~rows;
					progress=5'b00010;
					counter=0;
					end
				end
			//Read col 2
			5'b00010: begin
				columns =4'b1011;
				if(counter>=10) begin
					val1[11:8]=~rows;
					progress=5'b00011;
					counter=0;
					end
				end
			//Read col 3
			5'b00011: begin
				columns = 4'b0111;
				if(counter>=10) begin
					val1[15:12]=~rows;
					progress=5'b00100;
					counter=0;	
					end//end of if
				end
			
			//wait 10 ms 
			5'b00100: begin
				if(counter>=500000)begin
					progress=5'b00101;
					counter=0;
					end
				end
			
			//Read col0
			5'b00101: begin
				columns = 4'b1110;
				if(counter>=10) begin
					val2[3:0]=~rows;
					progress=5'b00110;
					counter =0;
					end
				end
			//Read col1
			5'b00110: begin
				columns = 4'b1101;
				if(counter>=10) begin
					val2[7:4]=~rows;
					progress=5'b00111;
					counter=0;
					end
				end
			//Read col 2
			5'b00111: begin
				columns =4'b1011;
				if(counter>=10) begin
					val2[11:8]=~rows;
					progress=5'b01000;
					counter=0;
					end
				end
			//Read col 3
			5'b01000: begin
				columns = 4'b0111;
				if(counter>=10) begin
					val2[15:12]=~rows;
					progress=5'b01001;
					counter=0;	
					end//end of if
				end
			//compare val1 and val2
			5'b01001:begin
				if((val1==val2)&&(val1!=0))begin
					progress=5'b01010;
					end//end of if
				else begin
					progress=5'b00000;
					end//end of else
				end

			//Increment the LEDs
			5'b01010: begin
				case(val1)
				16'b0000_0000_0000_0001: begin//1
					button=4'b0001;
					end
				16'b0000_0000_0000_0010: begin//4
					button=4'b0100;
					end
				16'b0000_0000_0000_0100: begin//7
					button=4'b0111;
					end
				16'b0000_0000_0000_1000: begin//*
					button=4'b1110;
					end
				16'b0000_0000_0001_0000: begin//2
					button=4'b0010;
					end
				16'b0000_0000_0010_0000: begin//5
					button=4'b0101;
					end
				16'b0000_0000_0100_0000: begin//8
					button=4'b1000;
					end
				16'b0000_0000_1000_0000: begin//0
					button=4'b0000;
					end
				16'b0000_0001_0000_0000: begin//3
					button=4'b0011;
					end
				16'b0000_0010_0000_0000: begin//6
					button=4'b0110;
					end
				16'b0000_0100_0000_0000: begin//9
					button=4'b1001;
					end
				16'b0000_1000_0000_0000: begin//#
					button=4'b1111;
					end
				16'b0001_0000_0000_0000: begin//A
					button=4'b1010;
					end
				16'b0010_0000_0000_0000: begin//B
					button=4'b1011;
					end
				16'b0100_0000_0000_0000: begin//C
					button=4'b1100;
					end
				16'b1000_0000_0000_0000: begin//D
					button=4'b1101;
					end
				endcase
				LEDs=button+LEDs;
				progress=5'b01011;
			end
			//Read col 0
			5'b01011: begin
				columns = 4'b1110;
				if(counter>=10) begin
					val1[3:0]=~rows;
					progress=5'b01100;
					counter =0;
					end
				end
			//Read col 1
			5'b01100: begin
				columns = 4'b1101;
				if(counter>=10) begin
					val1[7:4]=~rows;
					progress=5'b01101;
					counter=0;
					end
				end
			//Read col 2
			5'b01101: begin
				columns =4'b1011;
				if(counter>=10) begin
					val1[11:8]=~rows;
					progress=5'b01110;
					counter=0;
					end
				end
			//Read col 3
			5'b01110: begin
				columns = 4'b0111;
				if(counter>=10) begin
					val1[15:12]=~rows;
					progress=5'b10000;
					counter=0;	
					end//end of if
				end
			
			//wait 10 ms 
			5'b10000: begin
				if(counter>=500000)begin
					progress=5'b10001;
					counter=0;
					end
				end
			
			//Read col0
			5'b10001: begin
				columns = 4'b1110;
				if(counter>=10) begin
					val2[3:0]=~rows;
					progress=5'b10010;
					counter =0;
					end
				end
			//Read col1
			5'b10010: begin
				columns = 4'b1101;
				if(counter>=10) begin
					val2[7:4]=~rows;
					progress=5'b10011;
					counter=0;
					end
				end
			//Read col 2
			5'b10011: begin
				columns =4'b1011;
				if(counter>=10) begin
					val2[11:8]=~rows;
					progress=5'b10100;
					counter=0;
					end
				end
			//Read col 3
			5'b10100: begin
				columns = 4'b0111;
				if(counter>=10) begin
					val2[15:12]=~rows;
					progress=5'b10101;
					counter=0;	
					end//end of if
				end
			//compare val1 and val2
			5'b10101:begin
				if((val1==val2)&&(val1==0))begin
					button=4'b0000;
					progress=5'b00000;
					end//end of if
				else begin
					progress=5'b01011;
					end//end of else
				end

			
		endcase
	end //end of always@
	
	
	
endmodule//end of submodule


module tonedata(clk,button, countlow, counthigh);
	input clk;
	input[3:0] button; 
	output[31:0] countlow, counthigh;
	reg[31:0] countlow, counthigh;
	
	
	initial begin
		countlow=0;
		counthigh=0;
		
	end//end of initial
	always@(posedge clk) begin
			case(button)
			default: begin
				end
			4'b0000: begin //nothing plays 
				countlow= 0;
				counthigh=0;
			end
			4'b0001: begin //C5 523.25
				countlow=47778;
				counthigh=95557;
			end//end of c5
			4'b0010: begin //d5 587.33
				countlow=42566;
				counthigh=85131;
			end//end of d5
			4'b0011: begin //e5 659.26
				countlow=37921;
				counthigh=75843;
			end//end of e5
			4'b0100: begin //f5 698.26
				countlow=35803;
				counthigh=71607;
			end//end of f5
			4'b0101: begin //g5 783.99
				countlow=31888;
				counthigh=63776;
			end//end of g5
			4'b0110: begin //a5 880
				countlow = 28409;
				counthigh = 56818;
			end//end of a5
			4'b0111: begin //b5 987.77
				countlow=25310;
				counthigh=50619;
			end//end of b5
			4'b1000: begin //c6 1046.50
				countlow=23889;
				counthigh=47778;
			end//end of c6
			4'b1001: begin //d6 1174.70
				countlow=21282;
				counthigh=42564;
			end//end of d6
			4'b1010: begin //e6 1318.50
				countlow=18961;
				counthigh=37922;
			end//end of e6
			4'b1011: begin //f6 1396.90
				countlow=17897;
				counthigh=35794;
			end//end of f6
			4'b1100: begin //g6 1568
				countlow= 15944;
				counthigh=31888;
			end//end of g6
			4'b1101: begin //A6 
				countlow= 14205;
				counthigh=28409;
			end//end of A6
			4'b1110: begin //B6 
				countlow=12655 ;
				counthigh=25310;
			end//end of B6
			4'b1111: begin //C7 
				countlow= 11945;
				counthigh=23889;
			end//end of C7
		endcase
	end //end of always@
endmodule 

module toneprocessor (clk, countlow, counthigh, signalout);
	input clk;
	input[31:0] countlow, counthigh;
	output signalout;
	reg signalout;
	reg[31:0] onesecond, mycounter1, mycounter2;
	reg [3:0] progress;
	
	initial begin
		signalout=0;
		mycounter1=0;
		progress=4'b0000;
	end// end of initial 
	
	always@(posedge clk)begin
		case(progress)
			default: begin
			end
		4'b0000: begin
			//Region 1
			mycounter1 = mycounter1 +1'b1;
				if(mycounter1<countlow) begin
					signalout=0;
				end//end of if
				else begin
					progress=4'b0001;
				end// end of else
		end //end of region 1 case
		4'b0001:begin
			//Region 2
			mycounter1 =mycounter1+1'b1;
			if((mycounter1>=countlow)&&(mycounter1<counthigh))begin
				signalout = 1;
			end// end of if statement
			else begin
				progress = 4'b0010;
			end// end of else statement
		end //end of region 2 case
		4'b0010:begin
			//Region 3
			mycounter1 =mycounter1+1'b1;
			if(mycounter1>=counthigh) begin
					signalout=0;
					mycounter1=0;
					progress=4'b0000;
				end//end of if
		end //end of region 3 case
	endcase
	end// end of always@
endmodule 


module rotatingdisplay(clk, Hex0, Hex1, Hex2, Hex3, Hex4, Hex5);
	input clk;
	output[6:0] Hex0, Hex1, Hex2, Hex3, Hex4, Hex5;
	reg[4:0] pos0, pos1, pos2, pos3, pos4, pos5;
	reg[31:0] timer,onesecond;
	

	initial begin
		timer =0;
		onesecond=50000000;
		pos5=5'b00101;
		pos4=5'b00101;
		pos3=5'b00101;
		pos2=5'b00101;
		pos1=5'b00101;
		pos0=5'b00000;
		end
	always@(posedge clk) begin
		timer = timer+1'b1;
		if(timer>=onesecond)begin
			timer=0;
			pos5=pos4;
			pos4=pos3;
			pos3=pos2;
			pos2=pos1;
			pos1=pos0;
			if(pos0==5'b11100)begin
				pos0=5'b00000;
				end
			else begin
				pos0=pos0+1'b1;
				end
			end//end of if statement
		end//end of always@
		
	sevensegmentdecoder seven0(
		.position(pos0), 
		.sevenoutputs(Hex0)
	);
	sevensegmentdecoder seven1(
		.position(pos1), 
		.sevenoutputs(Hex1)
	);
	sevensegmentdecoder seven2(
		.position(pos2), 
		.sevenoutputs(Hex2)
	);
	sevensegmentdecoder seven3(
		.position(pos3), 
		.sevenoutputs(Hex3)
	);
	sevensegmentdecoder seven4(
		.position(pos4), 
		.sevenoutputs(Hex4)
	);
	sevensegmentdecoder seven5(
		.position(pos5), 
		.sevenoutputs(Hex5)
	);
	

endmodule//end of roratingdisplay

module sevensegmentdecoder(position, sevenoutputs);
	input [4:0] position;
	output[6:0] sevenoutputs;
	wire E,L,e,n,I,space, P, o, l, i, c, h, r, O,N, a,  k, i0, s, F,A,L0,L1, two0, two1, zero0, zero1;
	
	assign E = (~position[4])&(~position[3])&(~position[2])&(~position[1])&(~position[0]);
	assign L = (~position[4])&(~position[3])&(~position[2])&(~position[1])&(position[0]);
	assign e = (~position[4])&(~position[3])&(~position[2])&(position[1])&(~position[0]);
	assign n = (~position[4])&(~position[3])&(~position[2])&(position[1])&(position[0]);
	assign I = (~position[4])&(~position[3])&(position[2])&(~position[1])&(~position[0]);
	
	//assign space = (~position[4])&(~position[3])&(position[2])&(~position[1])&(position[0]);
	
	assign P = (~position[4])&(~position[3])&(position[2])&(position[1])&(~position[0]);
	assign o = (~position[4])&(~position[3])&(position[2])&(position[1])&(position[0]);
	assign l = (~position[4])&(position[3])&(~position[2])&(~position[1])&(~position[0]);
	assign i = (~position[4])&(position[3])&(~position[2])&(~position[1])&(position[0]);
	assign c = (~position[4])&(position[3])&(~position[2])&(position[1])&(~position[0]);
	assign h = (~position[4])&(position[3])&(~position[2])&(position[1])&(position[0]);
	assign r = (~position[4])&(position[3])&(position[2])&(~position[1])&(~position[0]);
	assign O = (~position[4])&(position[3])&(position[2])&(~position[1])&(position[0]);
	assign N = (~position[4])&(position[3])&(position[2])&(position[1])&(~position[0]);
	assign a = (~position[4])&(position[3])&(position[2])&(position[1])&(position[0]);
	assign k = (position[4])&(~position[3])&(~position[2])&(~position[1])&(~position[0]);
	assign i0 = (position[4])&(~position[3])&(~position[2])&(~position[1])&(position[0]);
	assign s = (position[4])&(~position[3])&(~position[2])&(position[1])&(~position[0]);
	
	//assign space1 = (position[4])&(~position[3])&(~position[2])&(position[1])&(position[0]);
	
	assign F = (position[4])&(~position[3])&(position[2])&(~position[1])&(~position[0]);
	assign A = (position[4])&(~position[3])&(position[2])&(~position[1])&(position[0]);
	assign L0 = (position[4])&(~position[3])&(position[2])&(position[1])&(~position[0]);
	assign L1 = (position[4])&(~position[3])&(position[2])&(position[1])&(position[0]);
	assign two0 = (position[4])&(position[3])&(~position[2])&(~position[1])&(~position[0]);
	assign zero0 = (position[4])&(position[3])&(~position[2])&(~position[1])&(position[0]);
	assign two1 = (position[4])&(position[3])&(~position[2])&(position[1])&(~position[0]);
	assign zero1 = (position[4])&(position[3])&(~position[2])&(position[1])&(position[0]);
	//assign space2 = (position[4])&(position[3])&(position[2])&(~position[1])&(~position[0]);
	
	
	assign sevenoutputs[6]=~(E|e|P|o|c|h|r|O|a|k|s|F|A|two0|two1);
	assign sevenoutputs[5]=~(E|L|e|n|P|l|h|N|a|k|s|A|F|L0|L1|zero0|zero1);
	assign sevenoutputs[4]=~(E|L|e|n|P|o|l|c|h|r|O|N|a|k|F|A|L0|L1|zero0|zero1|two0|two1);
	assign sevenoutputs[3]=~(E|L|e|o|l|c|O|s|L0|L1|two0| zero0| two1| zero1);
	assign sevenoutputs[2]=~(n|I|o|i|h|O|N|a|k|i0|s|A|zero0|zero1);
	assign sevenoutputs[1]=~(n|I|P|i|N|a|k|i0|A|zero0|zero1|two0|two1);
	assign sevenoutputs[0]=~(E|e|n|P|N|a|s|F|A|two0|two1|zero0|zero1);

endmodule //end of sevensegmentdecoder