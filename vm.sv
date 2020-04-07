module vm;
//variables to use

//USER INPUTS
bit select;
bit [1:0] coins;
bit [5:0] button;

//SUPPLIER INPUTS
bit [2:0] items;
bit [3:0] count;
bit [7:0] cost;
bit valid;

//OUTPUT VALUES OF THE VENDING MACHINE
bit [2:0] product;
bit [1:0] status;
bit [7:0] balance;
struct {
bit [2:0] button_pressed;
bit [7:0] cost_entry; } info;


//STATE VALUES TO USE
enum {IDLE, BUTTON, PRODUCT} state, next;

//INTERMEDIATE VARIABLES
logic clk, rst;
bit [3:0] count[5:0];


bit [3:0]count[5:0];
bit [7:0]actual_value[5:0];
bit valid_button;

always_ff(posedge clk)
		if(rst)
			begin
				state <= IDLE;
			end
		else
			begin
				if(valid)
					begin
						next <= state;
					end
				else
					state <= IDLE;
			end

always_comb
		begin	
			case(state)
				IDLE :	begin
							valid_button = 0;
							for(i=0;i<6;i++)
								begin
									if(button[i] == 1)	//This block is to check whether multiple buttons are not pressed
										valid_button = valid_button + 1;
									else
										valid_button = 0;
								end	
							//LOGIC for BUTTON to PRODUCT transition
							//this block helps in generating the STATUS and reduce the count which means that the item is reduced and will be picked by the user
							if((valid_button == 1)&& (valid == 0) && (balance > 0) && (rst ==0 ) )
								begin
									for(i=0; i < 6; i++)
										begin
											if(button[i] == 1)
												begin
													count[i] = count[i] - 1;
													if(count[i])
															begin
																status = 2'b11;
																next <= Button; 
															end
													else if(count[i] == 0)
															begin
																status =  2'b01;
																next <= Button;
															end	
													else
														begin
															status = 2'b00;
															next <= Button;
														end
												end
											
										end	
								end
							else
								next <= IDLE;
								//display error that multiple buttons have been pressed and now will move to IDLE state
						end
						
				BUTTON :begin
							for(i=0; i < 6; i++)
								begin
									if(button[i] == 1)
										begin
											if((balance >= actual_value[i])&& status == 2'b11 && (enter_key == 1))
												begin
													next <= PRODUCT;
													var=i;
												end
											else 
													next <= IDLE;
										end
								end								
						end				
				PRODUCT	:begin
							for(i=0;i<6;i++)
								begin
									if(var==i)	/*the var variable is used to get the index number indicating the button pressed 
												thus for the same button the corresponding product must come out*/
										begin
											product = i+1;	// i+1 because the product value can't be 000 as you have used
											next <= IDLE;	
										end
									else
										next <= IDLE;
								end
						 end
		end
endmodule
