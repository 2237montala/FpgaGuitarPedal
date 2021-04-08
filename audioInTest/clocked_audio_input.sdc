# (C) 2001-2020 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


###############################################################################
## Filename: clocked_audio_input.sdc
##
## Description: Timing Constraint file for clocked_audio_input Megacore
##
###############################################################################

set_false_path -to [get_keepers {*cai_avalon:*|fifo_fault_over_meta}]
set_false_path -to [get_keepers {*cai_avalon:*|aes_waddr_msb_gray_meta[*]}]
set_false_path -to [get_keepers {*cai_avalon:*|aes_raddr_msb_gray_meta[*]}]
