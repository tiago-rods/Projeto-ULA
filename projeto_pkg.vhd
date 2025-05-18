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

COMPONENT multiplicador IS
PORT
(
    m, q  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    P     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END COMPONENT;

COMPONENT sum_sub_rippleCarry IS
PORT 
( 
		x, y : IN STD_LOGIC_VECTOR (3 downto 0);
		Cin  : IN STD_LOGIC;
		Soma : OUT STD_LOGIC_VECTOR (3 downto 0);
		Cout : OUT STD_LOGIC
);

END COMPONENT;

COMPONENT comparador IS 
    PORT (
        a, b    : IN std_logic_vector(3 downto 0); -- 2 numeros de 4 bits 
        AgtB, AltB, AeqB : OUT std_logic	-- resultados, A maior que B, A menor que B, A igual a B
    );
END COMPONENT;

END PACKAGE;