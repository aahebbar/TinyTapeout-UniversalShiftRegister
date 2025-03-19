/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
/*
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;
*/

  // List all unused inputs to prevent warnings
    wire _unused = |{ena, clk, rst_n, 1'b0};

    wire reset, serialIn_left, serialIn_right;
    wire [1:0] mode;
    wire [7:0] parallelOut, parallelIn;

    assign parallelIn = ui_in;
    assign uo_out = parallelOut;
    assign reset = ~rst_n;

    assign mode = uio_in[1:0];
    assign serialIn_left = uio_in[2];
    assign serialIn_right = uio_in[3];
    assign uio_oe = 8'b1111_0000;

    assign uio_out = {_unused, 7'b0000000};
    
    universalShiftRegister usr_module (
        .clk(clk),
        .reset(reset),
        .serialIn_left(serialIn_left),
        .serialIn_right(serialIn_right),
        .mode(mode),
        .parallelIn(parallelIn),
        .parallelOut(parallelOut)
    );

    
endmodule



module universalShiftRegister (
    input clk, reset, serialIn_left, serialIn_right,
    input [7:0] parallelIn,
    input [1:0] mode,
    output wire [7:0] parallelOut,
);
    reg [7:0] register;
    
    always @ (posedge clk, posedge reset) begin
        if (reset)
            register <= 8'b0000_0000;
        else begin
            case(mode)
                2'b00: register <= register;
                2'b01: register <= {register[6:0], serialIn_right};
                2'b10: register <= {serialIn_left, register[7:1]};
                2'b11: register <= parallelIn;
                default: register <= register;
            endcase
        end
    end

    assign parallelOut = register;

endmodule
