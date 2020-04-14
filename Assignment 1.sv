


module vm(input bit [1:0]coins, [5:0]button, 					//coins button : Inputs given by USER.
		  input bit [2:0]items_s, 								//items_s : Item Selected by SUPPLIER.
		  input bit [3:0]count_s,								//count_s : Count of item given by SUPPLIER.
		  input bit [7:0]cost_s,								//cost_s  : Cost of suppler given by SUPPLIER.
		  input bit valid_s,									//valid_s : Input given by SUPPLIER.
		  input bit rst,clk,									
		  input bit enter_key,									//enter_key : Input given by USER.
		  input bit soft_rst,									//soft_rst : when user press this button it will go to IDLE state.
		  output logic [2:0]product,							//product 'z: No PRODUCT, 001: 1st PRODUCT, 010: 2nd PRODUCT, 011: 3rd PRODUCT, 100: 4th PRODUCT, 101: 5th PRODUCT, 110: 6th PRODUCT  
		  output logic [1:0]status,								//STATUS 01: No PRODUCT Available, 11: PRODUCT Available, 00: Internal Error, 10:Processing, STATUS z : No Operation is going on.
		  output logic [15:0]balance,							//Balance : Shows balance remaining in Vending Machine.
		  output logic [7:0] info								//Info:  Actual Value of Product. 
		  );
//INTERMEDIATE VARIABLES		  
bit [15:0] bal;													//bal : Intermediate Variable to stores user's coins.
bit [5:0] button_u;												//button_u : Intermediate Variable stores user's button input at IDLE state.	
bit [3:0] count_u[5:0];											//count_u : Intermediate array stores actual count in vending machine.
bit [7:0]actual_value[5:0];										//actual_value : Intermediate array stores actual value provided by suppler.
int valid_button;												//valid_button : Intermediate variable stores value of button when only one button is pressed.
int prod,i,j;

bit flag =1'b1;													//flag : For Prevnting SUPPLIER to take control during the Transaction.
//STATE VALUES TO USE
enum {IDLE, BUTTON, PRODUCT} state, next;						//enum : Defining States.

//NEXT STATE LOGIC.
always_ff@(posedge clk)
		begin
			if(rst)
				begin
					state <= IDLE;
					
				end
			else
				state <= next;
		end
//OUTPUT LOGIC.
always_comb
		begin
			case(state)
			// In IDLE state we are checking whether to give control to SUPPLIER or USER or remain in IDLE state.
			// We are checking whether only one button is pressed by USER or Not.
				IDLE :	begin
							flag = 1'b1;						//Initialising value of flag to 1, so even in IDLE state valid become 1, SUPPLIER can get control of Vending Machine.
							valid_button = 0;					//Initialising valid_button to 0, so if no button is pressed or multiple buttons are pressed then it will not change state.		
							product = 'z;						//Initialising product as z.
							if(coins == 2'b01)					//checking value of inserted coin is 5 cents.
								begin
									bal = bal + 3'b101;									//adding 5 cents in binary.
									balance = bal;
								end
							else if(coins == 2'b10)				//checking the value of inserted coin is 10 cents.
								begin
									bal = bal + 4'b1010;		//Adding 10 cents in binary. 	
									balance = bal;
								end
							else if(coins == 2'b11)				//checking the value of inserted coin is 25 cents.
								begin
									bal = bal + 5'b11001;		//adding 25 cents in binary.
									balance = bal;
								end
							else
								begin
									bal = balance;
									balance = bal;
								end
																
							status = 'z;						//Initialising STATUS as 'z
							info = 'z;							//Initialising information .
							for(i=0;i<6;i++)
								begin
									if(button[i] == 1)			//This block is to check whether single button is pressed or not.
										begin
											valid_button = valid_button + 1; //changing the value of valid_button when only one button is pressed.
										end
								end	
						//Hard Reset.		
						
							if(rst == 1'b1)			
										begin
										for(i=0;i<6;i++)
											begin
												count_u[i] = 8'b00000000;
												actual_value[i] = 4'b0000;
												info = 'z;
											end
										end		
						//SUPPLIER Control 				
							else if(valid_s && flag)		//Checking status of valid_s and flag for deciding whether to give control to supplier or not.					
								begin
									next <= IDLE;	
						// Checking which item is selected by SUPPLIER, and giving counts and cost to respective item.
									
									
									 if(items_s == 3'b000 && cost_s <= 8'b11111111)				// item 1 is selected by SUPPLIER.
										begin
											count_u[0] = count_s;			
											actual_value[0] = cost_s;	
										end
									else if(items_s == 3'b001 && cost_s <= 8'b11111111)			// item 2 is selected by SUPPLIER.
										begin
											count_u[1] = count_s;
											actual_value[1] = cost_s;
										end
									else if(items_s == 3'b010 && cost_s <= 8'b11111111)			// item 3 is selected by SUPPLIER.
										begin	
											count_u[2] = count_s;
											actual_value[2] = cost_s;
										end
									else if(items_s == 3'b011 && cost_s <= 8'b11111111)			// item 4 is selected by SUPPLIER.
										begin
											count_u[3] = count_s;
											actual_value[3] = cost_s;
										end
									else if(items_s == 3'b100 && cost_s <= 8'b11111111)			// item 5 is selected by SUPPLIER.
										begin
											count_u[4] = count_s;
											actual_value[4] = cost_s;	
										end
									else if(items_s == 3'b101 && cost_s <= 8'b11111111)			// item 6 is selected by SUPPLIER.
										begin
											count_u[5] = count_s;
											actual_value[5] = cost_s;
										end
								end	
							
						//USER Control
						// Here we are checking status of valid_button and valid_s and reset registers and enter_key for deciding whether to give control to USER or Not.
								else if((valid_button == 1) && (valid_s == 0) && (rst ==0 )  )						//LOGIC for IDLE to BUTTON transition
										begin
											for(i=0; i < 6; i++)
												begin
												if(button[i] == 1'b1)						//Checking which button is pressed.
													begin
														next <= BUTTON; 					//Next State.
														flag = 1'b0;						//Deasserting flag.
														status = 2'b10;						//STATUS : Processing
														info = actual_value[i];				//Displaying info as actual value of product.
														button_u = button;					//Storing button value.
													end
												end
										end
								else if((valid_button != 1) || (valid_button != 0))			//If Multiple Buttons are Pressed.
									begin
										next <= IDLE;										//Next State.	
										info = 8'b00000000;									//display error that multiple buttons have been pressed and now will move to IDLE state
									end
								else
								next <= IDLE;
							
						end
						
			//In BUTTON State we are checking which button is pressed. Also we are checking the count of product in Vending Machine.
			
				BUTTON :begin
							product = 'z;						//Initialising value of product.
							if(coins == 2'b01)					//checking value of inserted coin is 5 cents.
								begin
									bal = bal + 3'b101;			//Adding 4 cents
									balance = bal;			
								end
							else if(coins == 2'b10)				//checking the value of inserted coin is 10 cents.
								begin
									bal = bal + 4'b1010;		//Adding 10 cents	
									balance = bal;
								end
							else if(coins == 2'b11)				//checking the value of inserted coin is 25 cents.
								begin
									bal = bal + 5'b11001;		//Adding 25 cents
									balance = bal;
								end
							else
								begin
								bal = bal;
								balance = bal;
								end
							flag = 1'b0;																//Initialising flag 0, even SUPPLIER wants to take control he have to wait for completion of transaction.
							
							for(i=0; i < 6; i++)
								begin
									if(button_u[i] == 1)												//Checking which button is pressed.
										begin
											if(count_u[i] == 0)											//If no Product is available in Vending Machine next state will be IDLE State.
												begin
													next <= IDLE;
													status = 2'b00;										//STATUS : Internal Error
													info = actual_value[i];								//Displaying info as actual value of product.
												end
										else if((bal >= actual_value[i]) && (enter_key == 1))			// If product is available in Vending Machine and ammount which was given by USER 
												begin													// is equal to or greater than actual_value then next state will be PRODUCT State. 
													next <= PRODUCT;
													prod=i;
													status = 2'b10;										//STATUS : Processing
													info = actual_value[i];								//Displaying info as actual value of product.
												end
										else if(bal < actual_value[i])									// If product is available in Vending Machine but amount which was given by USER 
												begin													// is less that actual_value of product then next state will be IDLE.
													next <= IDLE;
													status = 2'b01;										//STATUS : No PRODUCT
													info = actual_value[i];								//Displaying info as actual value of product.
												end
										end
										
									else if(soft_rst == 1'b1)
												begin
													next <= IDLE;
													status = 2'b01;
													info = 'z;
												end
										
								end								
						end	
			
			//In PRODUCT State product is calculated of respective button.			
				PRODUCT	:begin
							product = 'z;
							if(coins == 2'b01)					//checking value of inserted coin is 5 cents.
								begin
									bal = bal + 3'b101;			//adding 5 cents in binary.
								end
							else if(coins == 2'b10)				//checking the value of inserted coin is 10 cents.
								begin
									bal = bal + 4'b1010;		//Adding 10 cents in binary. 	
								end
							else if(coins == 2'b11)				//checking the value of inserted coin is 25 cents.
								begin
									bal = bal + 5'b11001;		//adding 25 cents in binary.
								end
							else
								bal = bal;
							flag = 1'b0;										//Initialising flag 0, even SUPPLIER wants to take control he have to wait for completion of transaction.
							for(i=0;i<6;i++)
								begin
								//LOGIC for BUTTON to PRODUCT transition
									if(prod==i)									/*the prod variable is used to get the index number indicating the button pressed 
																				  thus for the same button the corresponding product must come out*/
										begin
											count_u[i] = count_u[i] - 1;
											product = i+1;						// i+1 because when 1st button is pressed it will indicate PRODUCT of 1st button is come out of Vending Machine.
											next <= IDLE;
											flag = 1'b1;
											balance = bal - actual_value[i];	//Calculating remaing balance of USER.
											bal = bal - actual_value[i];
											info = 8'b00000000;				//Info indicating Value of Product.
											status = 2'b11;						//STATUS : PRODUCT Given 
										end
									
								end
						 end
			endcase
		end
endmodule
