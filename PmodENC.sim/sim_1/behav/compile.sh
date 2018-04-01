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
echo "xvhdl -m64 --relax -prj rotaryencoder_tb_vhdl.prj"
ExecStep $xv_path/bin/xvhdl -m64 --relax -prj rotaryencoder_tb_vhdl.prj 2>&1 | tee -a compile.log
