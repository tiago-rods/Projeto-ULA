LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE projeto_pkg IS

COMPONENT fullAdder IS --component do somador completo
	PORT 
	(
		 x, y, Cin  : IN STD_LOGIC; --numeros a serem somados
		 Soma, Cout : OUT STD_LOGIC --resultado e carry out
	);
END COMPONENT;

COMPONENT multiplicador IS --component do multiplicador
PORT
(
    m, q  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);--numeros a serem multiplicados
    P     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)--produto final
);
END COMPONENT;

COMPONENT sum_sub_rippleCarry IS --component do somador ripple carry de 4bits
PORT 
( 
		x, y : IN STD_LOGIC_VECTOR (3 downto 0);--numeros a serem somados
		Cin  : IN STD_LOGIC;-- carry in, 0 se soma, 1 se subtração
		Soma : OUT STD_LOGIC_VECTOR (3 downto 0); --resultado da soma/sub
		Cout : OUT STD_LOGIC--carry out
);

END COMPONENT;

COMPONENT comparador IS --component do comparador 
    PORT (
        a, b    : IN std_logic_vector(3 downto 0); -- 2 numeros de 4 bits 
        AgtB, AltB, AeqB : OUT std_logic	-- resultados, A maior que B, A menor que B, A igual a B
    );
END COMPONENT;

END PACKAGE;