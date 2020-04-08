module vm(input bit [1:0]coins, [5:0]button,
                  input bit [2:0]items_s,
                  input bit [3:0]count_s,
                  input bit [7:0]cost_s,
                  input bit valid_s,rst,clk,enter_key,
                  output bit [2:0]product,
                  output bit [1:0]status,
                  output bit [7:0]balance,
                  output bit [10:0]info
                  );

//variables to use

/*//USER INPUTS
bit select;
bit [1:0] coins;
bit [5:0] button;

//SUPPLIER INPUTS
bit [2:0] items_s;
bit [3:0] count_s;
bit [7:0] cost_s;
bit valid_s;

//OUTPUT VALUES OF THE VENDING MACHINE
bit [2:0] product;
bit [1:0] status;
bit [7:0] balance;*/

bit [2:0] button_pressed;
bit [7:0] bal;

//STATE VALUES TO USE
enum {IDLE, BUTTON, PRODUCT} state, next;

//INTERMEDIATE VARIABLES
bit [3:0] count_prod[5:0];
bit [3:0] count_u[5:0];
bit [7:0]actual_value[5:0];
int valid_button;
int prod,i,j;

bit flag =1'b1;



always_ff@(posedge clk)
                begin
                        if(rst)
                                begin
                                        state <= IDLE;
                                end
                        else
                                state <= next;
                end
always_comb
                begin
                        product = 0;
                        case(state)
                                IDLE :  begin
                                                        flag = 1'b1;
                                                        valid_button = 0;

                                                        for(i=0;i<6;i++)
                                                                begin
                                                                        if(button[i] == 1)      //This block is to check whether multiple buttons are not pressed
                                                                                begin
                                                                                        valid_button = valid_button + 1;

                                                                                end

                                                                end
                                                        if(valid_s && flag)                                                     //SUPPLIER Control
                                                                begin
                                                                                        next <= IDLE;
                                                                                        if(items_s == 3'b001)
                                                                                        begin
                                                                                        count_u[0] = count_s;
                                                                                        actual_value[0] = cost_s;

                                                                                        end
                                                                                        else if(items_s == 3'b010)
                                                                                        begin
                                                                                                count_u[1] = count_s;
                                                                                                actual_value[1] = cost_s;
                                                                                        end
                                                                                        else if(items_s == 3'b011)
                                                                                        begin
                                                                                                count_u[2] = count_s;
                                                                                                actual_value[2] = cost_s;
                                                                                        end
                                                                                        else if(items_s == 3'b100)
                                                                                        begin
                                                                                                count_u[3] = count_s;
                                                                                                actual_value[3] = cost_s;
                                                                                        end
                                                                                        else if(items_s == 3'b101)
                                                                                        begin
                                                                                                count_u[4] = count_s;
                                                                                                actual_value[4] = cost_s;
                                                                                        end
                                                                                        else if(items_s == 3'b110)
                                                                                        begin
                                                                                                count_u[5] = count_s;
                                                                                                actual_value[5] = cost_s;
                                                                                        end
                                                                end
                                                        //LOGIC for BUTTON to PRODUCT transition
                                                        //this block helps in generating the STATUS and reduce the count which means that the item is reduced and will be picked by the user
                                                        else if((valid_button == 1)&& (valid_s == 0) && (rst ==0 ) )
                                                                begin
                                                                        bal = bal + coins;
                                                                        balance = bal;
                                                                        for(i=0; i < 6; i++)
                                                                                begin
                                                                                        if(button[i] == 1)
                                                                                                begin
                                                                                                        if(count_u[i])
                                                                                                                        begin
                                                                                                                                status = 2'b11;
                                                                                                                                next <= BUTTON;
                                                                                                                                flag = 1'b0;
                                                                                                                        end
                                                                                                        else if(count_u[i] == 0)
                                                                                                                        begin
                                                                                                                                status =  2'b01;
                                                                                                                                next <= BUTTON;

                                                                                                                        end
                                                                                                        else
                                                                                                                begin
                                                                                                                        status = 2'b00;
                                                                                                                        next <= BUTTON;
                                                                                                                end
                                                                                                end

                                                                                end
                                                                end
                                                        else
                                                                next <= IDLE;
                                                                //display error that multiple buttons have been pressed and now will move to IDLE state
                                                end

                                BUTTON :begin
                                                        flag = 1'b0;
                                                        for(i=0; i < 6; i++)
                                                                begin
                                                                        if(button[i] == 1)

                                                                                begin
                                                                                        if((bal >= actual_value[i])&& status == 2'b11 && (enter_key == 1))
                                                                                                begin
                                                                                                        next <= PRODUCT;
                                                                                                        prod=i;
                                                                                                        balance = bal;
                                                                                                end
                                                                                        else if(status == 2'b01 || status == 2'b10 || status == 2'b00 || bal < actual_value[i])
                                                                                                        next <= IDLE;
                                                                                end
                                                                end
                                                end
                                PRODUCT :begin
                                                        for(i=0;i<6;i++)
                                                                begin
                                                                        if(prod==i)     /*the prod variable is used to get the index number indicating the button pressed
                                                                                                thus for the same button the corresponding product must come out*/
                                                                                begin
                                                                                        count_u[i] = count_u[i] - 1;
                                                                                        product = i+1;  // i+1 because the product value can't be 000 as you have used
                                                                                        next <= IDLE;
                                                                                        flag = 1'b1;
                                                                                        bal = bal - actual_value[i];
                                                                                        balance = bal;
                                                                                end
                                                                        else
                                                                                next <= IDLE;
                                                                end
                                                 end
                        endcase
                end
endmodule
