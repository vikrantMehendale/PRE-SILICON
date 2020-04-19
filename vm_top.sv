////////////////////////////////////////////////////////////////////////////
// 
// 	Vending Machine TOP: vm_top.sv - Vending Machine TOP.
//	
//	Author : Saurabh Chavan, Vikrant Mehendale.
//	Date : 04/13/2020.
//  
//	Description:
// 	------------------------------------
//  This has instanstiation of Vending Machine and testbench.
//  
//////////////////////////////////////////////////////////////////////////


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
				logic [15:0]balance;
				logic [7:0]info;
				bit soft_rst;
				
				tb_vm DUT(.*);			//Instantiation Of Testbench of Vending Machine.
				vm VM(.*);				//Instantiation of Module of Vending Machine.
				initial
					begin	
							$monitor("items_s = %d\t Count = %d\t STATUS=%d\t BUTTON=%b\t COINS=%b\t PRODUCT=%d\t BALANCE =%d\t INFORMATION = %d\t ",VM.items_s,VM.count_u,VM.status,VM.button,VM.coins,VM.product,VM.balance,VM.info);
					end	
endmodule		
