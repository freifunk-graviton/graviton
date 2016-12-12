# build helloworld executable when user executes "make"
gravitonhmac: gravitonhmac.o
	$(CXX) $(LDFLAGS) gravitonhmac.o -o gravitonhmac -I$(STAGING_DIR)/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/usr/include/ -I$(STAGING_DIR)/usr/include/uClibc++ -I$(STAGING_DIR)/usr/include/libnl-tiny -DCONFIG_LIBNL30 $(LIBS) -levent -lnl-tiny -lzmq -lpthread
gravitonhmac.o: gravitonhmac.cpp
	$(CXX) $(CXXFLAGS) -c gravitonhmac.cpp -I$(STAGING_DIR)/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/usr/include/ -I$(STAGING_DIR)/usr/include/uClibc++ -I$(STAGING_DIR)/usr/include/libnl-tiny -DCONFIG_LIBNL30 $(LIBS)

# remove object files and executable when user executes "make clean"
clean:
	rm *.o gravitonhmac
	
