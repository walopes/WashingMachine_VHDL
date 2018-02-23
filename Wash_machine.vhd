--
-- AP6 - Exercicio 1 - Maquina de lavar roupas
-- 
-- OBS.: Melhorar condicao de parada, sinal de ST (tampa) e variável com multipla atribuicao (da erro essa merda)

--------------------- LIBRARY ---------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

--------------------- ENTITY ----------------------

ENTITY WashMachine IS
	PORT( liga, sn, st, rst, clk: IN STD_LOGIC;  -- liga eh botao
			m_ctl: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			ve, als, br, vs, bs: OUT STD_LOGIC);
END WashMachine;

--------------------- ARCHITECTURE ------------------

ARCHITECTURE logic OF WashMachine IS

	-------------------- COMPONENT -------------------
	COMPONENT debouncer IS
	PORT( clk, rst, ch_in: IN STD_LOGIC;
			led: BUFFER STD_LOGIC -- BUFFER pq o sinal eh lido mas eh processado tambem
	);
	END COMPONENT;
	--------------------------------------------------

	
	--SIGNAL clk_1s: STD_LOGIC;
	SIGNAL rst_temp: STD_LOGIC := '1';
	SIGNAL tempo: INTEGER RANGE 0 TO 15 := 0;
	SIGNAL liga_deb: STD_LOGIC;
	--SIGNAL estado: INTEGER RANGE 0 TO 8 := 0;
	TYPE estado IS (SD0,SD1,SD2,SD3,SD4,SD5,SD6,SD7);
	SIGNAL estado_atual, estado_prox: estado;
	
BEGIN
	
		
	U1: debouncer PORT MAP(clk,rst,liga,liga_deb);
	
	-- Temporizador utilizado nas transicoes
	Temporizador: PROCESS(rst_temp,clk)
			VARIABLE count: INTEGER RANGE 0 TO 49999999 := 0;
		BEGIN
			IF(rst_temp = '1') THEN -- reset interno do programa
				count:=0;
				tempo <= 0;
			ELSIF(clk'EVENT AND clk = '1') THEN	
				IF(count = 49999999) THEN
					count := 0;
					tempo <= tempo + 1;
				ELSE
					count := count + 1;
				END IF;
			END IF;
		END PROCESS Temporizador;
	
	-- Comutacao de estados da FSM
	FSM: PROCESS(rst,clk)
		BEGIN
			IF(rst = '1') THEN
				estado_atual <= SD0;
			ELSIF(clk'EVENT AND clk = '1') THEN
				estado_atual <= estado_prox;
			END IF;
		END PROCESS FSM;
	
	-- Tratamento dos estados
	PROCESS(clk,estado_atual,liga_deb,st,rst)
	
		BEGIN
			
			IF(rst = '1') THEN
				rst_temp <= '1';
			ELSIF(clk = '1' AND clk'EVENT)	THEN
			
				CASE estado_atual IS
				
					WHEN SD0 => 
							VE <= '0';
							ALS <= '0';
							M_CTL <= "00";
							BR <= '0';
							VS <= '0';
							BS <= '0';
							
							rst_temp <= '0';
						IF(liga_deb = '1') THEN
							estado_prox <= SD1;
							rst_temp <= '1';
						END IF;
						
					WHEN SD1 => 
							VE <= '1';
							ALS <= '0';
							M_CTL <= "00";
							BR <= '0';
							VS <= '0';
							BS <= '0';
							
							rst_temp <= '0';
						IF(liga_deb = '0' OR st = '1') THEN
							estado_prox <= SD0;
							rst_temp <= '1';
						ELSIF(tempo = 15) THEN
							estado_prox <= SD2;
							rst_temp <= '1';
						ELSIF(sn = '1') THEN
							estado_prox <= SD3;
							rst_temp <= '1';
						END IF;
						
					WHEN SD2 => 
							VE <= '0';
							ALS <= '1';
							M_CTL <= "00";
							BR <= '0';
							VS <= '0';
							BS <= '0';
							
							rst_temp <= '0';
						IF(liga_deb = '0' OR st = '1') THEN
							estado_prox <= SD0;
							rst_temp <= '1';
						ELSIF(tempo = 3) THEN
							estado_prox <= SD0;
							--liga_deb <= '0';
							rst_temp <= '1';							
						END IF;
						
					
					WHEN SD3 => 
							VE <= '0';
							ALS <= '0';
							M_CTL <= "01";
							BR <= '1';
							VS <= '0';
							BS <= '0';
							
							rst_temp <= '0';
						IF(liga_deb = '0' OR st = '1') THEN
							estado_prox <= SD0;
							rst_temp <= '1';
						ELSIF(tempo = 5) THEN
							estado_prox <= SD4;
							rst_temp <= '1';
						ELSE
							
						END IF;
						
					
					WHEN SD4 => 
							VE <= '0';
							ALS <= '0';
							M_CTL <= "00";
							BR <= '0';
							VS <= '0';
							BS <= '0';
							
							rst_temp <= '0';
						IF(liga_deb = '0' OR st = '1') THEN
							estado_prox <= SD0;
							rst_temp <= '1';
						ELSIF(tempo = 5) THEN
							estado_prox <= SD5;
							rst_temp <= '1';					
						END IF;
						
					
					WHEN SD5 => 
							VE <= '0';
							ALS <= '0';
							M_CTL <= "01";
							BR <= '0';
							VS <= '0';
							BS <= '0';
							
							rst_temp <= '0';
						IF(liga_deb = '0' OR st = '1') THEN
							estado_prox <= SD0;
							rst_temp <= '1';
						ELSIF(tempo = 5) THEN
							estado_prox <= SD6;
							rst_temp <= '1';							
						END IF;
						
					WHEN SD6 => 
							VE <= '0';
							ALS <= '0';
							M_CTL <= "00";
							BR <= '0';
							VS <= '1';
							BS <= '1';
							
							rst_temp <= '0';
						IF(liga_deb = '0' OR st = '1') THEN
							estado_prox <= SD0;
							rst_temp <= '1';
						ELSIF(tempo = 5) THEN
							estado_prox <= SD7;
							rst_temp <= '1';
						END IF;
						
					WHEN SD7 => 
							VE <= '1';
							ALS <= '0';
							M_CTL <= "10";
							BR <= '0';
							VS <= '1';
							BS <= '1';
							
							rst_temp <= '0';
						IF(liga_deb = '0' OR st = '1') THEN
							estado_prox <= SD0;
							rst_temp <= '1';
						ELSIF(tempo = 5) THEN
							estado_prox <= SD0;
							rst_temp <= '1';
						END IF;
						
					WHEN OTHERS => 
							VE <= '0';
							ALS <= '0';
							M_CTL <= "10";
							BR <= '0';
							VS <= '1';
							BS <= '1';
							
							rst_temp <= '0';
						IF(liga_deb = '0' OR st = '1') THEN
							estado_prox <= SD0;
							rst_temp <= '1';
						ELSIF(tempo = 5) THEN
							estado_prox <= SD0;
							rst_temp <= '1';
						END IF;
						
				END CASE;
			END IF;
		END PROCESS;
	
END;
------------------------------------------------------
