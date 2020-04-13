module TOP();
				bit valid_s;
				bit [2:0] items_s;
				bit [3:0] count_s;
				bit [7:0] cost_s;
				bit enter_key;
				logic clk,rst;
				bit [1:0]coins;
				bit  [5:0]button;
				logic [2:0]product;
				logic [1:0]status;
				bit [15:0]balance;
				bit [7:0]info;
				
				tb_vm DUT(.*);			//Instantiation Of Testbench of Vending Machine.
				vm VM(.*);				//Instantiation of Module of Vending Machine.
				
endmodule
