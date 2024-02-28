`line 2 "top.tlv" 0
`line 42 "top.tlv" 1

//_\SV
   // Included URL: "https://raw.githubusercontent.com/efabless/chipcraft---mest-course/main/tlv_lib/calculator_shell_lib.tlv"
   // Include Tiny Tapeout Lab.
   // Included URL: "https://raw.githubusercontent.com/os-fpga/Virtual-FPGA-Lab/35e36bd144fddd75495d4cbc01c4fc50ac5bde6f/tlv_lib/tiny_tapeout_lib.tlv"// Included URL: "https://raw.githubusercontent.com/os-fpga/Virtual-FPGA-Lab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlv_lib/fpga_includes.tlv"
`line 95 "top.tlv" 1

//_\SV

// ================================================
// A simple Makerchip Verilog test bench driving random stimulus.
// Modify the module contents to your needs.
// ================================================

module top(input logic clk, input logic reset, input logic [31:0] cyc_cnt, output logic passed, output logic failed);
   // Tiny tapeout I/O signals.
   logic [7:0] ui_in, uo_out;
   
   logic [31:0] r;
   always @(posedge clk) r <= $urandom();
   assign ui_in = r[7:0];
   
   logic ena = 1'b0;
   logic rst_n = ! reset;

   // Instantiate the Tiny Tapeout module.
   my_design tt(.*);

   assign passed = top.cyc_cnt > 60;
   assign failed = 1'b0;
endmodule


// Provide a wrapper module to debounce input signals if requested.
// The Tiny Tapeout top-level module.
// This simply debounces and synchronizes inputs.
// Debouncing is based on a counter. A change to any input will only be recognized once ALL inputs
// are stable for a certain duration. This approach uses a single counter vs. a counter for each
// bit.
module tt_um_template (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    /*   // The FPGA is based on TinyTapeout 3 which has no bidirectional I/Os (vs. TT6 for the ASIC).
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    */
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    
    // Synchronize.
    logic [9:0] inputs_ff, inputs_sync;
    always @(posedge clk) begin
        inputs_ff <= {ui_in, ena, rst_n};
        inputs_sync <= inputs_ff;
    end

    // Debounce.
    `define DEBOUNCE_MAX_CNT 14'h8
    logic [9:0] inputs_candidate, inputs_captured;
    logic sync_rst_n = inputs_sync[0];
    logic [13:0] cnt;
    always @(posedge clk) begin
        if (!sync_rst_n)
           cnt <= `DEBOUNCE_MAX_CNT;
        else if (inputs_sync != inputs_candidate) begin
           // Inputs changed before stablizing.
           cnt <= `DEBOUNCE_MAX_CNT;
           inputs_candidate <= inputs_sync;
        end
        else if (cnt > 0)
           cnt <= cnt - 14'b1;
        else begin
           // Cnt == 0. Capture candidate inputs.
           inputs_captured <= inputs_candidate;
        end
    end
    logic [7:0] clean_ui_in;
    logic clean_ena, clean_rst_n;
    assign {clean_ui_in, clean_ena, clean_rst_n} = inputs_captured;

    my_design my_design (
        .ui_in(clean_ui_in),
        
        .ena(clean_ena),
        .rst_n(clean_rst_n),
        .*);
endmodule
//_\SV



// =======================
// The Tiny Tapeout module
// =======================

module my_design (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    /*   // The FPGA is based on TinyTapeout 3 which has no bidirectional I/Os (vs. TT6 for the ASIC).
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    */
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
   wire reset = ! rst_n;

`include "top_gen.sv" //_\TLV
   /* verilator lint_off UNOPTFLAT */
   // Connect Tiny Tapeout I/Os to Virtual FPGA Lab.
   `line 77 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/35e36bd144fddd75495d4cbc01c4fc50ac5bde6f/tlvlib/tinytapeoutlib.tlv" 1
      assign L0_slideswitch_a0[7:0] = ui_in;
      assign L0_sseg_segment_n_a0[6:0] = ~ uo_out[6:0];
      assign L0_sseg_decimal_point_n_a0 = ~ uo_out[7];
      assign L0_sseg_digit_n_a0[7:0] = 8'b11111110;
   //_\end_source
   `line 205 "top.tlv" 2

   // Instantiate the Virtual FPGA Lab.
   `line 308 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
      
      `line 356 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
         //_/thanks
            /* Viz omitted here */























      //_\end_source
      `line 310 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
      
   
      // Board VIZ.
   
      // Board Image.
      /* Viz omitted here */



















      //_/fpga_pins
         /* Viz omitted here */


         //_/fpga
            `line 50 "top.tlv" 1
            
               //_|calc
                  //_@0
                     assign FpgaPins_Fpga_CALC_reset_a0 = reset;
                     assign FpgaPins_Fpga_CALC_op_a0[1:0] = ui_in[5:4];
                     assign FpgaPins_Fpga_CALC_val1_a0[7:0] = FpgaPins_Fpga_CALC_out_a1;
                     assign FpgaPins_Fpga_CALC_val2_a0[7:0] = ui_in[3:0];
                     assign FpgaPins_Fpga_CALC_sum_a0[7:0]  = FpgaPins_Fpga_CALC_val1_a0 + FpgaPins_Fpga_CALC_val2_a0;
                     assign FpgaPins_Fpga_CALC_diff_a0[7:0] = FpgaPins_Fpga_CALC_val1_a0 - FpgaPins_Fpga_CALC_val2_a0;
                     assign FpgaPins_Fpga_CALC_prod_a0[7:0] = FpgaPins_Fpga_CALC_val1_a0 * FpgaPins_Fpga_CALC_val2_a0;
                     assign FpgaPins_Fpga_CALC_quot_a0[7:0] = FpgaPins_Fpga_CALC_val1_a0 / FpgaPins_Fpga_CALC_val2_a0;
                     assign FpgaPins_Fpga_CALC_out_a0[7:0] =
                       FpgaPins_Fpga_CALC_op_a0[1:0] == 2'b11 ? FpgaPins_Fpga_CALC_quot_a0:
                       FpgaPins_Fpga_CALC_op_a0[1:0] == 2'b10 ? FpgaPins_Fpga_CALC_prod_a0:
                       FpgaPins_Fpga_CALC_op_a0[1:0] == 2'b01 ? FpgaPins_Fpga_CALC_diff_a0:
                       //default
                       FpgaPins_Fpga_CALC_sum_a0;
                     assign FpgaPins_Fpga_CALC_cnt_a0[31:0] = FpgaPins_Fpga_CALC_reset_a0 ? 0 : FpgaPins_Fpga_CALC_cnt_a1 + 1;
                  //_@3
                     assign FpgaPins_Fpga_CALC_digit_a3[3:0] = FpgaPins_Fpga_CALC_out_a3[3:0];
                     assign uo_out =
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'h0 ? 8'b00111111:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'h1 ? 8'b00000011:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'h2 ? 8'b00011011:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'h3 ? 8'b01001111:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'h4 ? 8'b01100110:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'h5 ? 8'b01101101:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'h6 ? 8'b01111101:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'h7 ? 8'b00000111:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'h8 ? 8'b01111111:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'h9 ? 8'b01101111:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'ha ? 8'b01110111:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'hb ? 8'b01111110:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'hc ? 8'b00111001:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'hd ? 8'b01011110:
                      FpgaPins_Fpga_CALC_digit_a3[7:0] == 4'he ? 8'b01111001:
                                            8'b01110001;
            
            
               `line 5 "/raw.githubusercontent.com/efabless/chipcraftmestcourse/main/tlvlib/calculatorshelllib.tlv" 1
                  // Only for Makerchip.
                  `line 10 "/raw.githubusercontent.com/efabless/chipcraftmestcourse/main/tlvlib/calculatorshelllib.tlv" 1
                     
                     
                     //_|calc
                        //_@0
                           assign {FpgaPins_Fpga_CALC_dummy_a0, FpgaPins_Fpga_CALC_mem_a0[8:0], FpgaPins_Fpga_CALC_rand1_a0[3:0], FpgaPins_Fpga_CALC_rand2_a0[3:0], FpgaPins_Fpga_CALC_valid_a0} = {FpgaPins_Fpga_TB_Default_dummy_a0, FpgaPins_Fpga_TB_Default_mem_a0, FpgaPins_Fpga_TB_Default_rand1_a0, FpgaPins_Fpga_TB_Default_rand2_a0, FpgaPins_Fpga_TB_Default_valid_a0};
                           `BOGUS_USE(FpgaPins_Fpga_CALC_dummy_a0 FpgaPins_Fpga_CALC_rand2_a0 FpgaPins_Fpga_CALC_rand1_a0)
                     //_|tb
                        //_@0
                           //_/default
                              assign FpgaPins_Fpga_TB_Default_valid_a0 = ! FpgaPins_Fpga_CALC_reset_a0;
                              /*SV_plus*/
                                 always @(posedge clk) FpgaPins_Fpga_TB_Default_rand_a0[31:0] <= $random();
                              assign FpgaPins_Fpga_TB_Default_rand_op_a0[2:0] = FpgaPins_Fpga_TB_Default_rand_a0[2:0];
                              assign FpgaPins_Fpga_TB_Default_rand1_a0[3:0] = FpgaPins_Fpga_TB_Default_rand_a0[6:3];
                              assign FpgaPins_Fpga_TB_Default_rand2_a0[3:0] = FpgaPins_Fpga_TB_Default_rand_a0[10:7];
                              assign FpgaPins_Fpga_TB_Default_op_a0[2:0] = ((top.cyc_cnt % 2) != 0)
                                             ? FpgaPins_Fpga_TB_Default_rand_op_a0[2:0]
                                             //? ( (*top.cyc_cnt > 33) ? ($rand_op[2:0] % 2) :
                                             //    (*top.cyc_cnt > 15) ? $rand_op[2:0] :
                                             //                          ((($rand_op[2:0] % 2) != 0) + ($rand_op[2:0] % 4)) )
                                             : FpgaPins_Fpga_TB_Default_op_a1;
                              assign FpgaPins_Fpga_TB_Default_val1_a0[7:0] = '0;
                              assign FpgaPins_Fpga_TB_Default_val2_a0[7:0] = '0;
                              assign FpgaPins_Fpga_TB_Default_out_a0[7:0] = '0;
                              assign FpgaPins_Fpga_TB_Default_mem_a0[8:0] = 9'h100;   // Indicates to VIZ that there is no memory.
                              assign FpgaPins_Fpga_TB_Default_dummy_a0 = 0;
                              `BOGUS_USE(FpgaPins_Fpga_TB_Default_out_a0 FpgaPins_Fpga_TB_Default_mem_a0 FpgaPins_Fpga_TB_Default_valid_a0 FpgaPins_Fpga_TB_Default_val1_a0 FpgaPins_Fpga_TB_Default_val2_a0 FpgaPins_Fpga_TB_Default_dummy_a0 FpgaPins_Fpga_TB_Default_rand1_a0 FpgaPins_Fpga_TB_Default_rand2_a0)
                        //_@2
                           assign {FpgaPins_Fpga_TB_mem_a2[8:0], FpgaPins_Fpga_TB_op_a2[1:0], FpgaPins_Fpga_TB_out_a2[7:0], FpgaPins_Fpga_TB_val1_a2[7:0], FpgaPins_Fpga_TB_val2_a2[7:0], FpgaPins_Fpga_TB_valid_a2} = {FpgaPins_Fpga_CALC_mem_a2, FpgaPins_Fpga_CALC_op_a2, FpgaPins_Fpga_CALC_out_a2, FpgaPins_Fpga_CALC_val1_a2, FpgaPins_Fpga_CALC_val2_a2, FpgaPins_Fpga_CALC_valid_a2};
                  
                           /* Viz omitted here */






















































































































































































































































                     
                     
                  //_\end_source
                  `line 7 "/raw.githubusercontent.com/efabless/chipcraftmestcourse/main/tlvlib/calculatorshelllib.tlv" 2
               //_\end_source
               `line 90 "top.tlv" 2
            
               // Connect Tiny Tapeout outputs. Note that uio_ outputs are not available in the Tiny-Tapeout-3-based FPGA boards.
               //*uo_out = 8'b0;
               
               
            //_\end_source
            `line 341 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
   
      // LEDs.
      
   
      // 7-Segment
      `line 396 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
         for (digit = 0; digit <= 0; digit++) begin : L1_Digit //_/digit
            /* Viz omitted here */



















            for (leds = 0; leds <= 7; leds++) begin : L2_Leds logic L2_viz_lit_a0; //_/leds
               assign L2_viz_lit_a0 = (! L0_sseg_digit_n_a0[digit]) && ! ((leds == 7) ? L0_sseg_decimal_point_n_a0 : L0_sseg_segment_n_a0[leds % 7]);
               /* Viz omitted here */
































               end end
      //_\end_source
      `line 347 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
   
      // slideswitches
      `line 455 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
         for (switch = 0; switch <= 7; switch++) begin : L1_Switch logic L1_viz_switch_a0; //_/switch
            assign L1_viz_switch_a0 = L0_slideswitch_a0[switch];
            /* Viz omitted here */










































            end
      //_\end_source
      `line 350 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
   
      // pushbuttons
      
   //_\end_source
   `line 208 "top.tlv" 2
   // Label the switch inputs [0..7] (1..8 on the physical switch panel) (top-to-bottom).
   `line 83 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/35e36bd144fddd75495d4cbc01c4fc50ac5bde6f/tlvlib/tinytapeoutlib.tlv" 1
      for (input_label = 0; input_label <= 7; input_label++) begin : L1_InputLabel //_/input_label
         /* Viz omitted here */















         end
   //_\end_source
   `line 210 "top.tlv" 2

//_\SV
endmodule


// Undefine macros defined by SandPiper (in "top_gen.sv").
`undef BOGUS_USE
