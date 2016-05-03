#CXXFLAGS=-O
CXXFLAGS=`itpp-config --cflags`
LIBS=`itpp-config --static --libs`
-include ~/makefile
# Configuration details. Adjust to your needs with
# LOGNAME and, for example, ifeq ($(HOSTNAME),jesus)
# LDLIBS = -litpp
NVCCFLAGS= -arch=sm_13
INCLUDES := -I. -I ../

young:: young.cpp
# Test if nvcc is available if so, then
# 	nvcc -D INCLUDECUDA=TRUE -I . -arch=sm_13 $(INCLUDECUDA) $(INCLUDETCLAP) $(CXXFLAGS) -o $@ $@.cu -litpp
# else use the usual compilation line, with some preprocessing
# 	$(CXX) -I . $(INCLUDETCLAP) $(CXXFLAGS)
	$(CXX) -I../  $(CXXFLAGS) $< -Wall -o $@ $(LIBS)
