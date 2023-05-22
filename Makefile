GHDL = ghdl
GHDLFLAGS = --std=08
OBJ = lfsr.vhdl
UNIT = lfsr_tb

aer :
	$(GHDL) -a $(GHDLFLAGS) $(OBJ)
	$(GHDL) -e $(GHDLFLAGS) $(UNIT)
	$(GHDL) -r $(GHDLFLAGS) $(UNIT)

clean :
	$(GHDL) --clean $(GHDLFLAGS)
	$(GHDL) --remove $(GHDLFLAGS)
