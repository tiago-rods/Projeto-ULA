LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.projeto_pkg.all;


ENTITY sum_sub_rippleCarry IS
PORT 
( 
		x, y : IN STD_LOGIC_VECTOR (3 downto 0); -- numeros a serem somados
		Cin  : IN STD_LOGIC; --carry in, 0 se soma e 1 se subtração
		Soma : OUT STD_LOGIC_VECTOR (3 downto 0); --resultado da soma/subtração
		Cout : OUT STD_LOGIC --carry out
);

END sum_sub_rippleCarry;

ARCHITECTURE estrutura OF sum_sub_rippleCarry IS

SIGNAL carry : STD_LOGIC_VECTOR (4 downto 0); --carries intermediarios 
begin 

carry(0) <= Cin; -- carry inicial recebe o carry in

st0 : fullAdder PORT MAP (x(0), y(0), Cin, Soma(0), carry(1)); -- instanciação de cada fileira da soma
st1 : fullAdder PORT MAP (x(1), y(1), carry(1), Soma(1), carry(2));
st2 : fullAdder PORT MAP (x(2), y(2), carry(2), Soma(2), carry(3));
st3 : fullAdder PORT MAP (x(3), y(3), carry(3), Soma(3), carry(4));

Cout <= carry(4); --carry out recebe o carry final

END ARCHITECTURE;
