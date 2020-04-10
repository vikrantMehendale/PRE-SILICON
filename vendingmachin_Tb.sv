program tb_vm(output bit valid_s,
			  output bit [2:0] items_s,
			  output bit [3:0] count_s,
			  output bit [7:0] cost_s,
			  output bit enter_key,
			  output bit clk,rst,
			  output bit [1:0]coins,
			  output bit [5:0]button,
			  input bit [2:0]product,
              input logic [1:0]status,
              input bit [7:0]balance,
              input bit [7:0]info  
			  );
			  
/*//SUPPLIER INPUTS TO DESIGN
bit valid_s;
bit [2:0] item_s;
bit [3:0] count_s;
bit [7:0] cost_s;
bit enter_key;

//USER INPUTS TO DESIGN
bit [1:0]coins;
bit [5:0]button;

//ESSENTIAL INPUTS
bit clk, rst;*/

//======================= Clock Generator =================================================

initial begin: clockGenerator
	clk = 0;							//Initializing the clk to 0.
	forever #5 clk = ~clk;				//Toggling the clk after every 5 unit time.
end: clockGenerator

//======================== SUPPLIER Task to perform Restocking ============================
task supplier;
		int i;
		valid_s = 1'b1;
		rst = 1'b0;
		for(i=0;i<6;i++)
			begin
				items_s = i;
				cost_s = i;
				count_s = 15;
			$display("ITEM = %d\t COST = %d\t COUNT =%d",items_s,cost_s,count_s);
				#1;
			end
		valid_s = 1'b0;
endtask: supplier


initial
	begin
//=========================Test Case 1: CONSUMER : BUTTON 1 is SELECTED : COIN 5 cent is inserted ===========================	
				@(posedge clk)supplier;
			#5	@(posedge clk)button = 6'b000001 ; coins = 2'b01; enter_key = 1'b1;
			$monitor("ITEM = %d\t COST = %d\t COUNT =%d\t status=%d\t Button=%d\t Coins=%b\t Product=%d\t",items_s,cost_s,count_s,status,button,coins,product);	
			#5	@(posedge clk)button = 6'b000000 ; coins = 2'b00; enter_key = 1'b0;
			$monitor("ITEM = %d\t COST = %d\t COUNT =%d\t status=%d\t Button=%d\t Coins=%b\t Product=%d\t",items_s,cost_s,count_s,status,button,coins,product);	
			#5	@(posedge clk)button = 6'b000000 ; coins = 2'b00; enter_key = 1'b0;
			$monitor("ITEM = %d\t COST = %d\t COUNT =%d\t status=%d\t Button=%d\t Coins=%b\t Product=%d\t",items_s,cost_s,count_s,status,button,coins,product);		
	
	
			#50	$stop; 
	end
endprogram		
