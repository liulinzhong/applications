CC = g++
CPPFLAGS = -m64 -I$(HAMA_HOME)/../../../../c++/src/main/native/utils/api -I$(HAMA_HOME)/../../../../c++/src/main/native/pipes/api

testProtocol: testProtocol.cc
	$(CC) $(CPPFLAGS) $< -L$(HAMA_HOME)/../../../../c++/target/native -lhadooputils -lcrypto -lpthread -g -Wall -O2 -o $@

clean:
	rm -f testProtocol
