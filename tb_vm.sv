////////////////////////////////////////////////////////////////////////////
// 
// 	Vending Machine Testbench: vm_tb.sv - Vending Machine Testbench.
//	
//	Author : Saurabh Chavan, Vikrant Mehendale.
//	Date : 04/13/2020.
//  
//	Description:
// 	------------------------------------
//  This test the Vending Machine Module.
//  It has several basic test cases.
//////////////////////////////////////////////////////////////////////////

program tb_vm(output bit valid_s,
			  output bit [2:0] items_s,
			  output bit [3:0] count_s,
			  output bit [7:0] cost_s,
			  output bit enter_key,
			  output bit clk,rst,
			  output bit [1:0]coins,
			  output bit [5:0]button,
			  input logic [2:0]product,
              input logic [1:0]status,
              input logic [15:0]balance,
              input logic [7:0]info, 
			  output bit soft_rst
			  );
int i;			  
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

//======================= Cover Groups ==========================================
	
covergroup cg @(posedge clk);
	cover_point_coin 	: 	coverpoint coins{
										bins a[] = {[0:4]};
										}
	
	cover_point_button 	: 	coverpoint button{
											bins b[] = 	{1,2,4,8,16,32};
											}
	
	cover_point_product	:	coverpoint product{
											bins c[] = 	{1,2,3,4,5,6};
												}
	cover_point_status	:	coverpoint status{
											bins d[] = 	{1,2,3};
												}
cover_point_enter_key	:	coverpoint enter_key{
											bins e[] = 	{0,1};
												}
	cover_point_soft_rst:	coverpoint soft_rst{
											bins f[] =	{0,1};
												}
	cover_point_valid_s	:	coverpoint valid_s{
											bins g[] =	{0,1};
												}
	cover_point_count_s	:	coverpoint count_s{
											bins g[4] =	{[0:15]};
												}
	cover_point_items_s	:	coverpoint items_s{
											bins h[2] =	{[0:6]};
												}
	cover_point_cost_s	:	coverpoint	cost_s{
											bins a[2] =	{[0:127]};
												}
endgroup	

cg cg_inst=new();

//======================== SUPPLIER Task to perform Restocking ============================
task supplier;
		int i;
		valid_s = 1'b1;
		rst = 1'b0;
		for(i=0;i<6;i++)
			begin
				items_s = i;
				cost_s = i*5+5;
				count_s = 15;
			
				#10;
			end
		valid_s = 1'b0;
endtask: supplier

//Task for 
task buttoncoinzero;
		button = 6'b000000;
		coins = 2'b00;
		
endtask:buttoncoinzero

//Task For CONSUMER Inputs
task consumer(
			input logic [5:0]i,
			input logic [1:0]j,
			input logic k);
		begin
		//@(posedge clk);
			button = i;
			coins = j;
			enter_key = k;
			cg_inst.sample();
			
			repeat(2) @(posedge clk)buttoncoinzero;
			#10;
		
				
		end
endtask

//Task for when user putting coins continously.  
task coins_continue(
					input logic [5:0]i,
					input logic [1:0]j,
					input logic k
					);
		begin
			button = i;
			coins = j;
			enter_key = k;
			cg_inst.sample();
			#10;
		end
endtask:coins_continue

initial
	begin
	  repeat(5) @(posedge clk) rst = 1'b1;
			 #1 @(posedge clk) rst = 1'b0;
			
//====== Test Case 1: SUPPLIER : When Valid_s is 1 then supplier should abble to restock the items ===================
				@(posedge clk)	$display("\n Test Case :1 : SUPPLIER : When Valid_s is 1 then supplier should abble to restock the items ");
							    supplier;
			
//====== Test Case 2: CONSUMER : BUTTON 1 is SELECTED : COIN 5 cent is inserted ===========================	
			#10 @(posedge clk) $display("\n  Test Case 2: CONSUMER : BUTTON 3 is SELECTED : COIN 5 cent is inserted ");
			#10	@(posedge clk) consumer(6'b000001,2'b01,1'b1);
			#10	@(posedge clk) consumer(6'b000001,2'b01,1'b1);
			#10 @(posedge clk) consumer(6'b000001,2'b01,1'b1);
			
			
//====== Test Case 3: CONSUMER : BUTTON 2 is SELECTED : COIN 5 cent is inserted for 10 cent product value ================
			#10	@(posedge clk) $display("\n Test Case 3: CONSUMER : BUTTON 2 is SELECTED : COIN 5 cent is inserted for 10 cent product value "); 
								consumer(6'b000010,2'b01,1'b1);
			#10	@(posedge clk)	consumer(6'b000010,2'b01,1'b1);
			

//====== Test Case 4: CONSUMER : BUTTON 1 and 3 is SELECTED : COIN 5 cent is inserted =========================== 	
			#20 @(posedge clk) $display("\n Test Case 4: CONSUMER : BUTTON 1 and 3 is SELECTED : COIN 5 cent is inserted");
								consumer(6'b000101,2'b01,1'b1);
								
//====== Test Case 5: CONSUMER : BUTTON 6 is SELECTED : COIN 25 and 5 cents ahe inserted and use previous balance ==============================================
			#10 @(posedge clk)	$display("\n Test Case 5: CONSUMER : BUTTON 6 is SELECTED : COIN 25 and 5 cents ahe inserted and use previous balance");
								consumer(6'b100000,2'b11,1'b1);
			
//====== Test Case 6: CONSUMER : Pressed button 1 then enter 10 cents but then he wants to change his choice hensce he press soft reset and press button 3 =====
			#10	@(posedge clk)  $display("\n Test Case 6: CONSUMER : Pressed button 1 then enter 10 cents but then he wants to change his choice hensce he press soft reset and press button 3");
								consumer(6'b000001,2'b10,1'b0);
			#10 @(posedge clk)	soft_rst = 1'b1;
			#10 @(posedge clk)  soft_rst=1'b0; consumer(6'b000100,2'b00,1'b1); 
			
			
//====== Test Case 7: CONSUMER : BUTTON 2 is Pressed but enter_key is not Pressed also insufficient Balance and he change his selection and press enter_key ====
			#10 @(posedge clk) 	$display("\n Test Case 7: CONSUMER : BUTTON 2 is Pressed but enter_key is not Pressed also insufficient Balance and he change his selection and press enter_key");
								consumer(6'b000010,2'b01,1'b0);
			#10 @(posedge clk)  consumer(6'b000001,2'b00,1'b1);
			

//====	Test Case 8: CONSUMER : BUTTON 5 is Pressed : COIN 25 cents is inserted ==========================================
			#10 @(posedge clk)	$display("\n Test Case 8: CONSUMER : BUTTON 5 is Pressed : COIN 25 cents is inserted");
								coins_continue(6'b010000,2'b11,1'b1);
			#10 @(posedge clk)	coins_continue(6'b010000,2'b11,1'b1);
			
			
//====== Test Case 9 : CONSUMER : BUTTON 4 is pressed for 16 times : COIN 25 cent is inserted for 20 Cent product Value ======================
			#10 @(posedge clk)	$display("\n Test Case 9 : CONSUMER : BUTTON 4 is pressed for 16 times : COIN 25 cent is inserted for 20 Cent product Value");
								consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			#10 @(posedge clk)	consumer(6'b001000,2'b11,1'b1);
			
			
//====== Test Case 10 : Hard Reset and Soft Reset pressed at same time ========================================================			
			
			#30 @(posedge clk) $display("\n Test Case 10 : Hard Reset and Soft Reset pressed at same time ");soft_rst = 1'b1; rst = 1'b1;
			 
			 
//====== Test Case 11: CONSUMER : BUTTON 5 is SELECTED : COIN 10 cent is inserted continously for 10 cent product value but Supplier did not provide so it will not give any product================			
			#10 @(posedge clk) $display("\n Test Case 11: CONSUMER : BUTTON 5 is SELECTED : COIN 10 cent is inserted continously for 10 cent product value but Supplier did not provide so it will not give any product");
	  repeat(3) @(posedge clk) coins_continue(6'b010000,2'b10,1'b1);
			cg_inst.sample();	
			#500 $stop;
	end
endprogram		
