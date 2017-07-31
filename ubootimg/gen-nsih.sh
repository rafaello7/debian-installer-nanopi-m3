#!/bin/sh
i=0
while [ $i -lt 512 ]; do
	val="00000000"; \
	[ $i -eq 68  ]	&& val="00060000"  # 0x44  load size
	[ $i -eq 72  ]	&& val="43bffe00"  # 0x48  load address
	[ $i -eq 76  ]	&& val="43c00000"  # 0x4c  launch address
	[ $i -eq 504 ]	&& val="68180300"  # 0x1f8 version
	[ $i -eq 508 ]	&& val="4849534E"  # 0x1fc "NSIH"
	# put in little endian
	vallo=${val#????}
	valhi=${val%????}
	echo "${vallo#??}${vallo%??}${valhi#??}${valhi%??}"
	i=$((i+4))
done
