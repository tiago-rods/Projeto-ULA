LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.projeto_pkg.all;

ENTITY multiplicador IS
PORT
(
    m, q  : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    P     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END multiplicador;

ARCHITECTURE logica OF multiplicador IS

-- Declaração do componente
COMPONENT fullAdder IS --full adder será utilizado para fazer as somas de produtos parciais
PORT 
(
    x, y, Cin  : IN STD_LOGIC;
    Soma, Cout : OUT STD_LOGIC
);
END COMPONENT;

-- Sinais intermediários
SIGNAL PP : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Produtos parciais
SIGNAL C1 : STD_LOGIC; -- Carry do primeiro estágio

BEGIN 

-- Cálculo dos produtos parciais
PP(0) <= m(1) AND q(0);
PP(1) <= m(0) AND q(1);
PP(2) <= m(1) AND q(1);

-- Primeiro bit do produto (sem carry)
P(0) <= m(0) AND q(0); -- primeiro bit do produto não é somado com nenhum carry nem produto parcial

-- Primeiro estágio: soma PP(0) + PP(1)
st1: fullAdder PORT MAP(PP(0), PP(1), '0', P(1), C1);

-- Segundo estágio: soma PP(2) + carry do primeiro estágio
st2: fullAdder PORT MAP(PP(2), '0', C1, P(2), P(3));

END ARCHITECTURE;