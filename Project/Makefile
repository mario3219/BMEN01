# Targets

# Usage: make run SCRIPT=example

run:
	matlab.exe -nosplash -nodesktop -r "$(SCRIPT)"

run_full:
	matlab.exe -nosplash -r "$(SCRIPT)"

setup:
	mkdir src

# Phony targets
.PHONY: all clean distclean

# Standard clean
clean:
#	-rm $(SRC_COMMON:.cc=.o)
#	-rm $(SRC_DATABASE:.cc=.o)
#	-rm $(SRC_SERVER:.cc=.o)

distclean: clean
#	-rm lib/libclientserver.a
#	-rmdir lib
#	-rm $(SRC_COMMON:.cc=.d)
#	-rm $(SRC_DATABASE:.cc=.d)
#	-rm $(SRC_SERVER:.cc=.d)
#	make -C server-client distclean


# Include the *.d files
#-include $(SRC_COMMON:.cc=.d)
#-include $(SRC_DATABASE:.cc=.d)
#-include $(SRC_SERVER:.cc=.d)
