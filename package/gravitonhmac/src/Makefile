all: gravitonhmac

gravitonhmac: gravitonhmac.cpp
	$(CXX) $(CXXFLAGS) $(LDFLAGS) gravitonhmac.cpp -o gravitonhmac -DCONFIG_LIBNL30 $(LIBS)

clean:
	rm gravitonhmac
	
