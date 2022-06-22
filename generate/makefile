########################################
COS_VERSION?= 2210
COSDIR?=$(HOME)/ILOG/CPLEX_Studio221
PYTHON_TARGET?= 3.8
PYTHON_HOME?=$(HOME)/anaconda3
SWIGDIR?=$(HOME)/opt
#########################################


OPLDIR = $(COSDIR)/opl
LD_LIBRARY_PATH=$(OPLDIR)/bin/x86-64_linux
DYLD_LIBRARY_PATH=$(OPLDIR)/bin/x86-64_osx
#PATH=$(OPLDIR)/bin/x64_win64


all: build

clean:
	@echo ================================================
	@echo = Cleaning $(COS_VERSION)/$(PYTHON_TARGET)
	@echo ================================================
	$(MAKE) -f makefile.build COS_VERSION=$(COS_VERSION) PYTHON_TARGET=$(PYTHON_TARGET) OPLDIR=$(OPLDIR) clean

build:
	@echo ================================================
	@echo = Building for $(COS_VERSION)/$(PYTHON_TARGET)
	@echo ================================================
	$(MAKE) -f makefile.build COS_VERSION=$(COS_VERSION) PYTHON_HOME=$(PYTHON_HOME) SWIGDIR=$(SWIGDIR) PYTHON_TARGET=$(PYTHON_TARGET) OPLDIR=$(OPLDIR) install_in_src all
	@echo ================================================
	@echo = Sanity test run for $(COS_VERSION)/$(PYTHON_TARGET)
	@echo ================================================
	$(MAKE) -f makefile.build COS_VERSION=$(COS_VERSION) PYTHON_HOME=$(PYTHON_HOME) PYTHON_TARGET=$(PYTHON_TARGET) OPLDIR=$(OPLDIR) LD_LIBRARY_PATH=$(LD_LIBRARY_PATH) DYLD_LIBRARY_PATH=$(DYLD_LIBRARY_PATH) test
