module fsm(input logic clk, 
			  input logic rst, 
			  input logic select,
			  input logic orden,
			  input logic cant_player,
			  input logic turno,
			  input logic end_attack_p1,
			  input logic end_attack_p2,
			  input logic timeout,
			  input logic gameover,
			  output logic en_attack_p1,
			  output logic en_attack_p2,
			  output logic en_attack_random,
			  output logic en_check );

logic [3:0] state, next_state;

//actual state logic
always_ff @ (posedge clk or posedge rst)
	if (rst) state = 4'b0000;
	else
		state = next_state;

//next state logic
always_comb begin
	case(state)
		4'b0000:if (select) begin 
						next_state = 4'b0001;
					end else begin
						next_state = 4'b0000;
					end
		4'b0001: if (select) begin 
						next_state = 4'b0010;
					end else begin
						next_state = 4'b0001;
					end
		4'b0010:if (select && orden) begin 
						next_state = 4'b0011;
					end else if (select && !orden) begin
						next_state = 4'b0100;
					end else begin
						next_state = 4'b0010;
					end
		4'b0011:if (end_attack_p1) begin 
						next_state = 4'b0110;
					end else begin
						next_state = 4'b0101;
					end
		4'b0100:if (!cant_player) begin 
						next_state = 4'b0111;
					end else if (cant_player && end_attack_p2) begin
						next_state = 4'b0110;
					end else begin
						next_state = 4'b0101;
					end
		4'b0101:if (timeout) begin 
						next_state = 4'b0111;
					end else if (!turno) begin
						next_state = 4'b0100;
					end else if (turno) begin
						next_state = 4'b0011;
					end else begin
						next_state = 4'b0101;
					end
		4'b0110:if (gameover) begin 
						next_state = 4'b1000;
					end else if (!turno) begin
						next_state = 4'b0100;
					end else if (turno) begin
						next_state = 4'b0011;
					end else begin
						next_state = 4'b0110;
					end
		4'b0111:next_state = 4'b0110;
		4'b1000:next_state = 4'b1000;
	endcase	
end
//output logic 

assign en_attack_p1 = state == 4'b0011;
assign en_attack_p2 = state == 4'b0100;
assign en_attack_random = state == 4'b0111;
assign en_check = state == 4'b0110;


endmodule