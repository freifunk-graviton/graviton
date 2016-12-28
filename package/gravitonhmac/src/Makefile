all: gravitonhmac

CFLAGS += -Wall

gravitonhmac: gravitonhmac.cpp
	$(CC) $(CPPFLAGS) $(LDFLAGS) gravitonhmac.cpp -o gravitonhmac -DCONFIG_LIBNL30 $(LIBS)

clean:
	rm gravitonhmac
	
