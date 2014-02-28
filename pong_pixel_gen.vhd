----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ethan Snyder
-- 
-- Create Date:    10:45:15 02/12/2014 
-- Design Name: Pong_Pixel_Gen
-- Module Name:    pong_pixel_gen - Behavioral 
-- Project Name: Lab 2
-- Target Devices: 
-- Tool versions: 
-- Description: creates the pixel generation for putting the letters AF in the middle of a screen
-- and generatest the pixel gen for a paddle and ball for a pong game. 
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

entity pong_pixel_gen is
    Port ( row : in  unsigned (10 downto 0);
           column : in  unsigned (10 downto 0);
           blank : in  STD_LOGIC;
           ball_x : in  unsigned (10 downto 0);
           ball_y : in  unsigned (10 downto 0);
           paddle_y : in  unsigned (10 downto 0);
           r,g,b : out  STD_LOGIC_vector (7 downto 0)
			  
			  );
end pong_pixel_gen;

architecture Behavioral of pong_pixel_gen is

begin


	process (row, column, blank)
	begin 
		r <= "00000000"; 
		g <= "00000000"; 
		b <= "00000000";
				
		if (blank = '0') then
		--ball
			if (column >  0 and column < 3 ) then 
				if (row < paddle_y+30 and row > paddle_y-30) then 
					r <= "11111111"; 
					g <= "00000000"; 
					b <= "00000000";
					elsif ((column < ball_x+3 and column > ball_x-3) and (row > ball_y-3 and row < ball_y +3)) then  
				r <= "00000000"; 
				g <= "11111111"; 
				b <= "00000000";
				end if;
			elsif (column >  155 and column < 205 ) then 
				if (row < 340 and row > 140) then 
					r <= "00000000"; 
					g <= "00000000"; 
					b <= "11111111";
				elsif	((column < ball_x+3 and column > ball_x-3) and (row > ball_y-3 and row < ball_y +3)) then  
				r <= "00000000"; 
				g <= "11111111"; 
				b <= "00000000";
				end if; 
			elsif ( column > 204 and column < 255) then 
				if (row > 140 and row < 190) then 
					r <= "00000000"; 
					g <= "00000000"; 
					b <= "11111111";
				elsif (row > 240 and row < 290) then 
					r <= "00000000"; 
					g <= "00000000"; 
					b <= "11111111";
				elsif	((column < ball_x+3 and column > ball_x-3) and (row > ball_y-3 and row < ball_y +3)) then  
				r <= "00000000"; 
				g <= "11111111"; 
				b <= "00000000";
				end if; 
			elsif ( column > 254 and column < 305) then 
				if (row < 340 and row > 140) then 
					r <= "00000000"; 
					g <= "00000000"; 
					b <= "11111111";
					elsif	((column < ball_x+3 and column > ball_x-3) and (row > ball_y-3 and row < ball_y +3)) then  
				r <= "00000000"; 
				g <= "11111111"; 
				b <= "00000000";
				end if; 
			elsif ( column > 369 and column < 420) then 
				if (row < 340 and row > 140) then 
					r <= "00000000"; 
					g <= "00000000"; 
					b <= "11111111";
					elsif	((column < ball_x+3 and column > ball_x-3) and (row > ball_y-3 and row < ball_y +3)) then  
				r <= "00000000"; 
				g <= "11111111"; 
				b <= "00000000";
				end if; 
			elsif ( column > 419 and column < 520) then 
				if (row > 140 and row < 190) then 
					r <= "00000000"; 
					g <= "00000000"; 
					b <= "11111111";
				
				elsif (row > 240 and row < 290) then 
					r <= "00000000"; 
					g <= "00000000"; 
					b <= "11111111";
					elsif	((column < ball_x+3 and column > ball_x-3) and (row > ball_y-3 and row < ball_y +3)) then  
				r <= "00000000"; 
				g <= "11111111"; 
				b <= "00000000";
				end if; 
				elsif	((column < ball_x+3 and column > ball_x-3) and (row > ball_y-3 and row < ball_y +3)) then  
				r <= "00000000"; 
				g <= "11111111"; 
				b <= "00000000";
			end if; 
		end if;
	end process; 
end Behavioral;