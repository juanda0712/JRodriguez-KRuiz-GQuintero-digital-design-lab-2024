module nbitsubtract #(parameter n = 4)
(input logic [n - 1: 0]a, b, output logic [n - 1: 0]y, output logic bout);
	
	logic [n:0] borrow;
	logic [n - 1: 0] temp;
	assign borrow[0] = 1'b0;
	
	genvar i;
	generate
		for (i = 0; i < n; i = i + 1) begin : subt_loop
			fullsubtract subt_inst (
            .a(a[i]),
            .b(b[i]),
            .bin(borrow[i]),
            .y(y[i]),
            .bout(borrow[i + 1]));
    end
	endgenerate
	
	assign bout = borrow[n];
	
	//if(bout) begin
	//	assign temp = y;
	//	negative neg(.a(temp), .y(y));
	//end
endmodule