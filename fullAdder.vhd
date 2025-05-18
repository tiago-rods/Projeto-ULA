LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.projeto_pkg.all;

entity fullAdder IS
	PORT 
	(
		 x, y, Cin  : IN STD_LOGIC;
		 Soma, Cout : OUT STD_LOGIC
	);
END fullAdder;

ARCHITECTURE logica of fullAdder IS
SIGNAL xor_xy : STD_LOGIC;

BEGIN
	xor_xy  <= (x XOR y); -- soma 2 números via XOR
	Soma <= (xor_xy XOR Cin); -- soma os dois números com o carry in
	Cout <= (x AND y) or (xor_xy AND Cin); -- gera o carry out 
END logica;
