#!/bin/bash -f
xv_path="/home/pharaoh/Xilinx/Vivado/2017.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim rotaryencoder_tb_behav -key {Behavioral:sim_1:Functional:rotaryencoder_tb} -tclbatch rotaryencoder_tb.tcl -view /home/pharaoh/Projekte/FPGA/Xilinx/PmodENC/controller_tb_behav.wcfg -log simulate.log
