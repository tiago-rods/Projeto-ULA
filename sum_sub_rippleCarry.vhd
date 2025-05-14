LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.projeto_pkg.all;


ENTITY sum_sub_rippleCarry IS
PORT 
( 
		x, y : IN STD_LOGIC_VECTOR (3 downto 0);
		Cin  : IN STD_LOGIC;
		Soma : OUT STD_LOGIC_VECTOR (3 downto 0);
		Cout : OUT STD_LOGIC
);

END sum_sub_rippleCarry;

ARCHITECTURE estrutura OF sum_sub_rippleCarry IS

COMPONENT fullAdder is
PORT 
(
		x, y, Cin  : IN STD_LOGIC;
		Soma, Cout : OUT STD_LOGIC
);

END fullAdder;

SIGNAL carry : STD_LOGIC_VECTOR (4 downto 0);
begin 

carry(0) <= Cin;

st0 : entity fullAdder PORT MAP (x(0), y(0), Cin, Soma(0), carry(1));
st1 : entity fullAdder PORT MAP (x(1), y(1), carry(1), Soma(1), carry(2));
st2 : entity fullAdder PORT MAP (x(2), y(2), carry(2), Soma(2), carry(3));
st3 : entity fullAdder PORT MAP (x(3), y(3), carry(3), Soma(3), carry(4));

Cout <= carry(4);

END ARCHITECTURE;
