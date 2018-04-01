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
ExecStep $xv_path/bin/xelab -wto 483e78ad49964b6c8d2212cc02a7f653 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot rotaryencoder_tb_behav xil_defaultlib.rotaryencoder_tb -log elaborate.log
