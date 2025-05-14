LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.projeto_pkg.all;

ENTITY comparador IS 
    PORT (
        a, b    : IN std_logic_vector(3 downto 0); -- 2 numeros de 4 bits 
        AgtB, AltB, AeqB : OUT std_logic	-- resultados, A maior que B, A menor que B, A igual a B
    );
END comparador;

ARCHITECTURE logicaComparador OF comparador IS
    SIGNAL i, j : std_logic_vector(3 downto 0); -- sinais intermediarios, i => representa igualdade
    SIGNAL igual, maior, menor : std_logic; --j => representa cálculo das diferenças
    
BEGIN
    
    -- Cálculo das igualdades bit a bit (XNOR)
    i(0) <= (a(0) XNOR b(0)); 
    i(1) <= (a(1) XNOR b(1)); 
    i(2) <= (a(2) XNOR b(2)); 
    i(3) <= (a(3) XNOR b(3)); 
     
    -- Cálculo das diferenças (maior que)
    j(0) <= (a(3) AND NOT b(3));
    j(1) <= (i(3) AND (a(2) AND NOT b(2)));
    j(2) <= (i(3) AND i(2) AND (a(1) AND NOT b(1)));
    j(3) <= (i(3) AND i(2) AND i(1) AND (a(0) AND NOT b(0)));
    
    -- Saídas intermediárias
    igual <= (i(0) AND i(1) AND i(2) AND i(3));
    maior <= (j(0) OR j(1) OR j(2) OR j(3));
    menor <= (NOT igual AND NOT maior);
    
    -- Saídas finais
    AeqB <= igual;
    AgtB <= maior;
    AltB <= menor;
    
END logicaComparador;