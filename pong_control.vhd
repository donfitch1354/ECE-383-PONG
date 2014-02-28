----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ethan Snyder
-- 
-- Create Date:    10:46:53 02/12/2014 
-- Design Name: Pong Control
-- Module Name:    pong_control - Behavioral 
-- Project Name: Lab 2
-- Target Devices: 
-- Tool versions: 
-- Description: Creates game control logic for the pong game
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity pong_control is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           up : in  STD_LOGIC;
           down : in  STD_LOGIC;
			  faster : in std_logic; 
           v_completed : in  STD_LOGIC;
           ball_x : out  unsigned (10 downto 0);
           ball_y : out  unsigned (10 downto 0);
           paddle_y : out  unsigned (10 downto 0)
			  );
end pong_control;

architecture Behavioral of pong_control is
	type state_type is (top, right, bottom, game_over, new_game, good_hit, good_hitcc, topcc, bottomcc, rightcc);
	
	constant speed : natural := 800;
	
	constant boundary_left : natural := 3;
	constant boundary_right : natural := 620;
	constant boundary_top : natural := 0;
	constant boundary_bottom : natural :=480;
	
	signal state_reg, state_next   : state_type;
	signal ball_x_reg, ball_y_reg, paddle_y_reg, ball_x_next, ball_y_next, paddle_y_next: unsigned (10 downto 0); 
	signal  count_next, count_reg, count_next_2, count_reg_2: unsigned (10 downto 0); 
	signal  clockwise_flag: std_logic; 
begin
--------------counter--------------------
--counter logic
	count_next <=	(others => '0') when count_reg >= speed else
						count_reg + 1 when v_completed = '1' else
						count_reg; 

-- counter register
		process (clk, reset)
			begin
			if reset = '1' then 
				count_reg <= "00000000000"; 
			elsif rising_edge(clk) then 
				count_reg <= count_next +1; 
			end if;
		end process; 












---------------------------paddle-----------------------------
	

 
 --next state paddle register
		process (clk, reset) 
		begin 
			if reset = '1' then 
				paddle_y_next <="00001100100"; 
			elsif rising_edge(clk) then 
				paddle_y_next <= paddle_y_reg; 
			end if; 
		end process; 
		
-- next state logic for paddle
		process (paddle_y_reg, count_next, up, down) 
		begin 
		 paddle_y_reg <= paddle_y_next; 
			
			if count_next = speed then
			  if (up = '1' and paddle_y_next > 31) then 
					paddle_y_reg <= paddle_y_next - 1;
				elsif (down = '1' and paddle_y_next < 449) then 
					paddle_y_reg <= paddle_y_next + 1; 
				else 
					paddle_y_reg <= paddle_y_next; 
				end if; 
			end if; 
		end process; 
		
--outputs for paddle 	
	paddle_y <= paddle_y_next;


----------------------- ball---------------------



-- state register
		process (clk, reset)
		begin
			if reset = '1' then
				state_reg <= new_game;
			elsif rising_edge(clk) then
				state_reg <= state_next;
			end if; 
		end process; 


	
	-- next state logic. a CC after a state means that the state is for when the ball is
	-- making a counter-clockwise rotation. There are 10 states. One for new game, one for game over,
	-- and four for clockwise movement and four for counter-clockwise movement. This was way over-complicated
	-- in the way I did it. 
	process ( state_reg , count_next ) 
			begin

				state_next<=state_reg;
	
				case state_reg is
				
					when new_game=>
						if (ball_x_reg < boundary_right and ball_y_reg < boundary_bottom ) then 
							state_next <= new_game;
						elsif ( ball_x_reg = boundary_right and ball_y_reg < boundary_bottom) then 
							state_next <= right; 
						elsif (ball_x_reg < boundary_right and ball_y_reg = boundary_bottom) then 
							state_next <= bottomcc; 
						end if;
						
					when right=>
						if (ball_x_reg > boundary_left and ball_y_reg < boundary_bottom) then 
							state_next <= right;
						elsif ( ball_x_reg = boundary_left and ball_y_reg <boundary_bottom) then 
							state_next <= good_hitcc; 
						elsif (ball_x_reg > boundary_left and ball_y_reg = boundary_bottom) then 
							state_next <= bottom; 
						end if;
						
					when bottom => 
						if (ball_x_reg > boundary_left and ball_y_reg > boundary_top) then 
							state_next <= bottom;
						elsif ( ball_x_reg = boundary_left and ball_y_reg >boundary_top) then 
							if (ball_y_reg < paddle_y_reg +30 and ball_y_reg > paddle_y_reg -30) then
							if (ball_y_reg < paddle_y_reg +30) then 
							state_next <= good_hitcc;
							elsif (ball_y_reg > paddle_y_reg -30) then
							state_next <= good_hit;
							end if; 
							elsif (ball_y_reg > paddle_y_reg +30 or ball_y_reg < paddle_y_reg -30)then
							state_next <= good_hit; 
							end if; 
						elsif (ball_x_reg > boundary_left and ball_y_reg = boundary_top) then 
							state_next <= topcc; 
						end if;
						
					when good_hit => 
						if (ball_x_reg < boundary_right and ball_y_reg > boundary_top ) then 
							state_next <= good_hit;
						elsif ( ball_x_reg = boundary_right and ball_y_reg > boundary_top) then 
							state_next <= rightcc; 
						elsif (ball_x_reg < boundary_right and ball_y_reg = boundary_top) then 
							state_next <= top;
						end if;
						
					when top =>
						if (ball_x_reg < boundary_right and ball_y_reg < boundary_bottom ) then 
							state_next <= new_game;
						elsif ( ball_x_reg = boundary_right and ball_y_reg < boundary_bottom) then 
							state_next <= right; 
						elsif (ball_x_reg < boundary_right and ball_y_reg = boundary_bottom) then 
							state_next <= bottomcc;
						end if;
	
					when rightcc=>
						if (ball_x_reg > boundary_left and ball_y_reg > boundary_top) then 
							state_next <= rightcc;
						elsif ( ball_x_reg = boundary_left and ball_y_reg > boundary_top) then 
							state_next <= good_hit; 
						elsif (ball_x_reg > boundary_left and ball_y_reg = boundary_top) then 
							state_next <= topcc; 
						end if;
						
					when bottomcc => 
						if (ball_x_reg < boundary_right and ball_y_reg > boundary_top) then 
							state_next <= bottomcc;
						elsif ( ball_x_reg = boundary_right and ball_y_reg >boundary_top) then 
							state_next <=  rightcc;
						elsif (ball_x_reg < boundary_right and ball_y_reg = boundary_top) then 
							state_next <= topcc; 
						end if;
						
					when topcc =>
						if (ball_x_reg > boundary_left and ball_y_reg < boundary_bottom ) then 
							state_next <= topcc;
						elsif ( ball_x_reg = boundary_left and ball_y_reg < boundary_bottom) then 
							if (ball_y_reg < paddle_y_reg +30 and ball_y_reg > paddle_y_reg -30) then
								if (ball_y_reg < paddle_y_reg +30) then 
								state_next <= good_hit;
							elsif  ( ball_y_reg < paddle_y_reg) then 
								state_next <= good_hitcc;
							end if;  
							elsif (ball_y_reg > paddle_y_reg +30 or ball_y_reg < paddle_y_reg -30)then
							state_next <= good_hitcc; 
							end if; 
						elsif (ball_x_reg > boundary_left and ball_y_reg = boundary_bottom) then 
							state_next <= bottom;
						end if;
						
				
					when good_hitcc => 
						if (ball_x_reg < boundary_right and ball_y_reg < boundary_bottom ) then 
							state_next <= good_hitcc;
						elsif ( ball_x_reg = boundary_right and ball_y_reg < boundary_bottom) then 
							state_next <= rightcc; 
						elsif (ball_x_reg < boundary_right and ball_y_reg = boundary_bottom) then 
							state_next <= bottomcc;
						end if;
						
					when game_over => 
							state_next <= good_hit; 
					end case; 
				
			end process;

-- output logic--

	process (ball_x_reg, ball_y_reg, count_next, state_next)
	begin 
		ball_x_next <= ball_x_reg;
		ball_y_next <= ball_y_reg;
		if (faster = '0') then 
				if count_next = speed then
					case state_next is 
						when new_game =>
							ball_x_next <= ball_x_reg+1;
							ball_y_next <= ball_y_reg+1;
						when right =>
							ball_x_next <= ball_x_reg-1;
							ball_y_next <= ball_y_reg+1;
						when bottom =>
							ball_x_next <= ball_x_reg-1;
							ball_y_next <= ball_y_reg-1;
						when top =>
							ball_x_next <= ball_x_reg+1;
							ball_y_next <= ball_y_reg+1; 
						when good_hit => 
							ball_x_next <= ball_x_reg+1;
							ball_y_next <= ball_y_reg-1;
						when rightcc =>
							ball_x_next <= ball_x_reg-1;
							ball_y_next <= ball_y_reg-1;
						when bottomcc =>
							ball_x_next <= ball_x_reg+1;
							ball_y_next <= ball_y_reg-1;
						when topcc =>
							ball_x_next <= ball_x_reg-1;
							ball_y_next <= ball_y_reg+1; 
						when good_hitcc => 
							ball_x_next <= ball_x_reg+1;
							ball_y_next <= ball_y_reg+1;
						when game_over => 
							ball_x_next <= ball_x_reg+0;
							ball_y_next <= ball_y_reg+0;

							
					end case; 
				end if;
		elsif (faster = '1') then 
			if (count_next = speed  ) then
					case state_next is 
						when new_game =>
							ball_x_next <= ball_x_reg+2;
							ball_y_next <= ball_y_reg+2;
						when right =>
							ball_x_next <= ball_x_reg-2;
							ball_y_next <= ball_y_reg+2;
						when bottom =>
							ball_x_next <= ball_x_reg-2;
							ball_y_next <= ball_y_reg-2;
						when top =>
							ball_x_next <= ball_x_reg+2;
							ball_y_next <= ball_y_reg+2; 
						when good_hit => 
							ball_x_next <= ball_x_reg+2;
							ball_y_next <= ball_y_reg-2;
						when rightcc =>
							ball_x_next <= ball_x_reg-2;
							ball_y_next <= ball_y_reg-2;
						when bottomcc =>
							ball_x_next <= ball_x_reg+2;
							ball_y_next <= ball_y_reg-2;
						when topcc =>
							ball_x_next <= ball_x_reg-2;
							ball_y_next <= ball_y_reg+2; 
						when good_hitcc => 
							ball_x_next <= ball_x_reg+2;
							ball_y_next <= ball_y_reg+2;
						when game_over => 
							ball_x_next <= ball_x_reg+0;
							ball_y_next <= ball_y_reg+0;

							
					end case; 
				end if;

			end if; 	
	end process;
	
-- output buffer--
	process (clk, reset) 
	 begin 
		if reset = '1' then 
			ball_x_reg <= to_unsigned(100,11);
			ball_y_reg <= to_unsigned(100,11);
		elsif rising_edge(clk) then
			ball_x_reg <= ball_x_next;
			ball_y_reg <= ball_y_next; 
		end if; 
	end process; 	
-- outputs--

	ball_x <= ball_x_reg;
	ball_y <= ball_y_reg; 
end Behavioral;

