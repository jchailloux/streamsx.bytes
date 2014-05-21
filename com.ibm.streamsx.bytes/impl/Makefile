# begin_generated_IBM_copyright_prolog                             
#                                                                  
# This is an automatically generated copyright prolog.             
# After initializing,  DO NOT MODIFY OR MOVE                       
# **************************************************************** 
# THIS SAMPLE CODE IS PROVIDED ON AN "AS IS" BASIS. IBM MAKES NO   
# REPRESENTATIONS OR WARRANTIES, EXPRESS OR IMPLIED, CONCERNING    
# USE OF THE SAMPLE CODE, OR THE COMPLETENESS OR ACCURACY OF THE   
# SAMPLE CODE. IBM DOES NOT WARRANT UNINTERRUPTED OR ERROR-FREE    
# OPERATION OF THIS SAMPLE CODE. IBM IS NOT RESPONSIBLE FOR THE    
# RESULTS OBTAINED FROM THE USE OF THE SAMPLE CODE OR ANY PORTION  
# OF THIS SAMPLE CODE.                                             
#                                                                  
# LIMITATION OF LIABILITY. IN NO EVENT WILL IBM BE LIABLE TO ANY   
# PARTY FOR ANY DIRECT, INDIRECT, SPECIAL OR OTHER CONSEQUENTIAL   
# DAMAGES FOR ANY USE OF THIS SAMPLE CODE, THE USE OF CODE FROM    
# THIS [ SAMPLE PACKAGE,] INCLUDING, WITHOUT LIMITATION, ANY LOST  
# PROFITS, BUSINESS INTERRUPTION, LOSS OF PROGRAMS OR OTHER DATA   
# ON YOUR INFORMATION HANDLING SYSTEM OR OTHERWISE.                
#                                                                  
# (C) Copyright IBM Corp. 2010, 2012  All Rights reserved.         
#                                                                  
# end_generated_IBM_copyright_prolog                               
SPL_PKGCFG=$(STREAMS_INSTALL)/bin/dst-pe-pkg-config.sh
SPL_PKG=dst-spl-pe-install
SPL_INCLUDE_OPTIONS = `$(SPL_PKGCFG) --cflags $(SPL_PKG)`

ifeq ($(CXX),g++)
  PLATFORM := $(shell uname -i)
  ifeq ($(PLATFORM),ppc64)
    CXX=/opt/at5.0/bin/g++
  endif
endif

.PHONY: clean distclean

all: lib/libBytesLib.so 

lib/BytesLib.o: src/BytesLib.cpp include/BytesLib.h
	@echo Compiling 'src/BytesLib.cpp' ...
	@$(CXX) -Wall -fPIC -I include $(SPL_INCLUDE_OPTIONS) \
             -c src/BytesLib.cpp -o $@

lib/libBytesLib.so: lib/BytesLib.o
	@echo Building C++ shared library '$@'
	@$(CXX) -shared -o $@ $<

clean:
	rm -rf lib/BytesLib.o lib/libBytesLib.so

distclean: clean
