#!/bin/bash
#set -x # Debug

FILES="indemo.psm outdemo.psm pmoddemo.psm sdread.psm"
ASSEMBLER_DIR="../picoassembler"


command -v dosbox > /dev/null 2>&1|| { echo "DOSBox required but it's not installed";exit 255; }

function kcpsm3 {
	echo "c:" > run.bat
	echo "KCPSM3.EXE $1" >> run.bat
	#echo "pause"  >> run.bat # Debug, stop after assembler
	echo "exit"  >> run.bat
	dosbox -c "mount c ." -c "c:\run.bat"
	}

for f in $FILES ; do
	bs=`basename -s .psm $f`
	cp ../asm/$f asmcode.psm
	kcpsm3 asmcode.psm
	rm asmcode.psm
	mv ASMCODE.VHD $bs.vhd
done

RES_OK=""
RES_FAIL=""
for f in $FILES ; do
	bs=`basename -s .psm $f`	
	if [ -f $bs.vhd ]; then
		RES_OK="$RES_OK $bs.vhd"
	else
		RES_FAIL="$RES_FAIL $bs.vhd"
	fi
	
		
done

echo "--------------------------------------------"
echo "** VHDL Files generated: $RES_OK"
if [ -n "$RES_FAIL" ]; then
	echo "*** Some errors happened, files not generated: $RES_FAIL"
fi

echo "** You must copy or link once of these files as 'asmcode.vhd' to include it in ISE project"