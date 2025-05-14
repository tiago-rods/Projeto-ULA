LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE projeto_pkg IS

COMPONENT fullAdder IS
	PORT 
	(
		 x, y, Cin  : IN STD_LOGIC;
		 Soma, Cout : OUT STD_LOGIC
	);
	END COMPONENT;