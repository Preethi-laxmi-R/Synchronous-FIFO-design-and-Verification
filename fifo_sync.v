module fifo_sync
 // parameter section
   #(parameter FIFO_DEPTH = 8,//8 layers
     parameter DATA_WIDTH = 32)// each layer consists of 32 bit data
//ports
(input clk,
input rst_n,
input cs,
input wr_en,
input rd_en,
input [DATA_WIDTH-1:0] data_in,
output reg [DATA_WIDTH-1:0] data_out,
output empty,   //empty flag
 output full);  // full flag

localparam FIFO_DEPTH_LOG= $clog2(FIFO_DEPTH);//FIFO_DEPTH_LOG=3 )no. of bits required to represent 8(000 to 111)

//dimentional array to store a data
reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1];//depth=8

//read/write pointer have 1 extra bit at MAB
reg [FIFO_DEPTH_LOG:0] write_pointer;//3:0
reg [FIFO_DEPTH_LOG:0] read_pointer;//3:0

//wite operation
always@(posedge clk or negedge rst_n)//synchronous clk and asynchrounous reset
    begin
    if(!rst_n)//reset=0 system reset happens
    write_pointer<=0;
    else if(cs && wr_en &&!full)
    begin
    fifo[write_pointer[FIFO_DEPTH_LOG-1:0]]<=data_in;//data is stored in the location
    write_pointer<=write_pointer+1'b1;//after writing the data, write_pointer should be incremented by 1
    end
    end

//read operation
always@(posedge clk or negedge rst_n)//synchronous clk and asynchrounous reset
   begin
   if(!rst_n)// reset=0 system resets
   read_pointer<=0;
   else if(cs && rd_en && !empty)
   begin
   data_out<= fifo[read_pointer[FIFO_DEPTH_LOG-1:0]];//data is read
   read_pointer<=read_pointer+1'b1;//after reading read pointer should be incremented
   end
   end
   
   //empty/full logic
   assign empty=(read_pointer == write_pointer);
   assign full=(read_pointer == {~write_pointer[FIFO_DEPTH_LOG],write_pointer[FIFO_DEPTH_LOG-1:0]});
   
  endmodule



