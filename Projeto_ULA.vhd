LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.projeto_pkg.all;

ENTITY Projeto_ULA IS
PORT(
    SW      : IN  std_logic_vector (10 downto 0);
    HEX0    : OUT std_logic_vector (0 to 6);
    HEX2    : OUT std_logic_vector (0 to 6);
    HEX4    : OUT std_logic_vector (0 to 6);
    HEX6    : OUT std_logic_vector (0 to 6);
    LEDR     : OUT std_logic_vector (5 downto 0);
    HEX1    : OUT std_logic_vector (0 to 6)
);
END Projeto_ULA;

ARCHITECTURE logicaProj of Projeto_ULA IS

    SIGNAL ALUop     : std_logic_vector (2 downto 0);
    SIGNAL x         : std_logic_vector (3 downto 0); -- x e y variaveis para operações aritimeticas
    SIGNAL y         : std_logic_vector (3 downto 0);
    SIGNAL not_y     : std_logic_vector (3 downto 0); --not_y variavel para operação not
    SIGNAL result    : std_logic_vector (3 downto 0);
    
    SIGNAL sum       : std_logic_vector (3 downto 0); --variaveis para resultados de operações aritimeticas
    SIGNAL sub       : std_logic_vector (3 downto 0);
    SIGNAL mul       : std_logic_vector (3 downto 0);
    
    SIGNAL Cout_sum  : std_logic; --Carry out para soma e subtracao
    SIGNAL Cout_sub  : std_logic;
    SIGNAL zero      : std_logic; --zero flag
    SIGNAL overflow  : std_logic; --Overflow flag
    SIGNAL EQU       : std_logic;
    SIGNAL GRT       : std_logic; --Resultados do comparador
    SIGNAL LST       : std_logic;
    
    -- a e b variaveis para operações lógicas
    SIGNAL a         : std_logic_vector (3 downto 0); -- a para armazenas os valores de AND
    SIGNAL b         : std_logic_vector (3 downto 0); -- b para armazenar os valores de OR
    
    -- Sinais para detecção de overflow
   --SIGNAL overflow_sum : std_logic;
    --SIGNAL overflow_sub : std_logic;
    
BEGIN
    
    --ALUop vai indicar a operação a ser utilizada
    ALUop <= SW(2 downto 0); 
    
    --Funcionamento do NOP e entradas x e y
    x <= "0000" WHEN ALUop = "000" ELSE SW(10 downto 7); 
    y <= "0000" WHEN ALUop = "000" ELSE SW(6 downto 3);  
    
    -- Operações lógicas AND, OR e NOT
        -- AND
    a(0) <= x(0) AND y(0);
    a(1) <= x(1) AND y(1);
    a(2) <= x(2) AND y(2);
    a(3) <= x(3) AND y(3);
    
    --OR
    b(0) <= x(0) OR y(0);
    b(1) <= x(1) OR y(1);
    b(2) <= x(2) OR y(2);
    b(3) <= x(3) OR y(3);
    
    --NOT
    not_y(0) <= NOT y(0);
    not_y(1) <= NOT y(1);
    not_y(2) <= NOT y(2);
    not_y(3) <= NOT y(3);
	 
    --Instanciação dos componentes aritiméticos:
    
    --somador 
    somador : sum_sub_rippleCarry 
    PORT MAP(
        --x 
		  x,
        --y
		  y,
        --Cin  
		  '0',
        --Soma
		  sum,
        --Cout 
		  Cout_sum
    );
    
    --subtrator
    subtrator : sum_sub_rippleCarry 
    PORT MAP(
        --x
		  x,
        --y 
		  not_y,
        --Cin 
		  '1',
        --Soma
		  sub,
        --Cout 
		  Cout_sub
    );
     
    --multiplicador (dois bits menos significativos)
    multiplicador_inst : multiplicador 
    PORT MAP(
        --m 
		  x(1 DOWNTO 0),
        --q
		  y(1 DOWNTO 0),
        --P 
		  mul
    );
     
    --Comparador
    comparador_inst: comparador
    PORT MAP(
        --a
		  x,
        --b 
		  y,
        --AeqB
		  EQU,
        --AgtB 
		  GRT,
        --AltB
		  LST
    );
     
    --detecção de Overflow para soma e subtração
   -- overflow_sum <= (x(3) AND y(3) AND NOT sum(3)) OR (NOT x(3) AND NOT y(3) AND sum(3));
    --overflow_sub <= (x(3) AND NOT y(3) AND NOT sub(3)) OR (NOT x(3) AND y(3) AND sub(3));
     
    -- Seleção do resultado baseado na operação
    result <= 
        "0000"  WHEN ALUop = "000" ELSE --NOP
        a       WHEN ALUop = "001" ELSE --AND
        b       WHEN ALUop = "010" ELSE --OR
        not_y   WHEN ALUop = "011" ELSE --NOT
        sum     WHEN ALUop = "100" ELSE --ADD
        sub     WHEN ALUop = "101" ELSE --SUB
        mul     WHEN ALUop = "110" ELSE --MUL
        "0000"; --COMP(111)
     
    -- Seleção do overflow baseado na operação
 overflow <= (not a(3) and not b(3) and sum(3)) or 
                (a(3) and b(3) and not sum(3)) when AluOp = "100" else
                (not a(3) and b(3) and sub(3)) or 
                (a(3) and not b(3) and not sub(3)) when AluOp = "101" else
                '0';
                                --COMP (111)
    
    -- Detecção de Zero
    zero <= '1' WHEN (ALUop = "000" OR result = "0000") ELSE '0';
	 
	     LEDR(0) <= Cout_sum WHEN ALUop = "100" ELSE
              Cout_sub WHEN ALUop = "101" ELSE
              '0';
    LEDR(1) <= zero;
    LEDR(2) <= overflow;
    LEDR(3) <= LST WHEN ALUop = "111" ELSE '0';
    LEDR(4) <= EQU WHEN ALUop = "111" ELSE '0';
    LEDR(5) <= GRT WHEN ALUop = "111" ELSE '0';
     
    

    -- Decodificador para os displays de 7 segmentos
    -- Display do resultado
	 with result select
    HEX6 <=     "0000001" when "0000",
                "1001111" when "0001",
                "0010010" when "0010",
                "0000110" when "0011",
                "1001100" when "0100",
                "0100100" when "0101",
                "0100000" when "0110",
                "0001111" when "0111",
                "0000000" when "1000",
                "0000100" when "1001",
                "0001000" when "1010",
                "1100000" when "1011",
                "0110001" when "1100",
                "1000010" when "1101",
                "0110000" when "1110",
                "0111000" when "1111",
                "1111111" when others;

    
    -- Display do valor de x ou a
	 WITH x select
    HEX4 <= 	 "0000001" when "0000",
                "1001111" when "0001",
                "0010010" when "0010",
                "0000110" when "0011",
                "1001100" when "0100",
                "0100100" when "0101",
                "0100000" when "0110",
                "0001111" when "0111",
                "0000000" when "1000",
                "0000100" when "1001",
                "0001000" when "1010",
                "1100000" when "1011",
                "0110001" when "1100",
                "1000010" when "1101",
                "0110000" when "1110",
                "0111000" when "1111",
                "1111111" when others;
    
    -- Display do valor de y ou b
	 with y select
    HEX2 <= 	 "0000001" when "0000",
                "1001111" when "0001",
                "0010010" when "0010",
                "0000110" when "0011",
                "1001100" when "0100",
                "0100100" when "0101",
                "0100000" when "0110",
                "0001111" when "0111",
                "0000000" when "1000",
                "0000100" when "1001",
                "0001000" when "1010",
                "1100000" when "1011",
                "0110001" when "1100",
                "1000010" when "1101",
                "0110000" when "1110",
                "0111000" when "1111",
                "1111111" when others;
    
    -- Display da operação ALUop
    HEX0 <= "0000001" WHEN ALUop = "000" ELSE -- 0 (NOP)
            "1001111" WHEN ALUop = "001" ELSE -- 1 (AND)
            "0010010" WHEN ALUop = "010" ELSE -- 2 (OR)
            "0000110" WHEN ALUop = "011" ELSE -- 3 (NOT)
            "1001100" WHEN ALUop = "100" ELSE -- 4 (ADD)
            "0100100" WHEN ALUop = "101" ELSE -- 5 (SUB)
            "0100000" WHEN ALUop = "110" ELSE -- 6 (MUL)
            "0001111" WHEN ALUop = "111" ELSE -- 7 (COMP)
            "1111111"; -- Apagado
    
    -- HEX1 - Poderia ser usado para mostrar flags ou deixado apagado
    HEX1 <= "1111111"; -- Apagado por padrão
    
END logicaProj;