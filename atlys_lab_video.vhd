----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ethan Snyder
-- 
-- Create Date:    10:48:04 02/12/2014 
-- Design Name: Atlys_lab_video			
-- Module Name:    atlys_lab_video - Behavioral 
-- Project Name: Lab 2				
-- Target Devices: 
-- Tool versions: 
-- Description: top level of lab 2
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

entity atlys_lab_video is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  up: in STD_LOGIC; 
			  down: in STD_LOGIC; 
			  faster: in STD_logic; 
           tmds : out std_logic_vector(3 downto 0);
           tmdsb : out std_logic_vector(3 downto 0)
			  );
end atlys_lab_video;

architecture Behavioral of atlys_lab_video is

 component vga_sync 
     
     Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_sync : out  STD_LOGIC;
           v_sync : out  STD_LOGIC;
           v_completed : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           row :  out unsigned(10 downto 0);
           column :  out unsigned(10 downto 0));
  end component vga_sync ;



-- TODO: Entity declaration (as shown on previous page)


    -- TODO: Signals, as needed
	 
	 signal pixel_clk, blue_s, red_s, green_s, v_sync, h_sync,  v_completed_sig, blank, clock_s, serialize_clk, serialize_clk_n: std_logic;  
	 signal red, green, blue: std_logic_vector (7 downto 0); 
	 signal row_sig, column_sig, paddle_y_sig, ball_y_sig, ball_x_sig: unsigned (10 downto 0); 
begin

    -- Clock divider - creates pixel clock from 100MHz clock
    inst_DCM_pixel: DCM
    generic map(
                   CLKFX_MULTIPLY => 2,
                   CLKFX_DIVIDE   => 8,
                   CLK_FEEDBACK   => "1X"
               )
    port map(
                clkin => clk,
                rst   => reset,
                clkfx => pixel_clk
            );

    -- Clock divider - creates HDMI serial output clock
    inst_DCM_serialize: DCM
    generic map(
                   CLKFX_MULTIPLY => 10, -- 5x speed of pixel clock
                   CLKFX_DIVIDE   => 8,
                   CLK_FEEDBACK   => "1X"
               )
    port map(
                clkin => clk,
                rst   => reset,
                clkfx => serialize_clk,
                clkfx180 => serialize_clk_n
            );

    -- TODO: VGA component instantiation
	

	  Inst_vga_sync: vga_sync PORT MAP(
				clk => pixel_clk,
				reset => reset, 
				h_sync => h_sync, 
				v_sync=> v_sync, 
				v_completed =>  v_completed_sig, 
				blank => blank, 
				row => row_sig,
				column => column_sig
	         																						
				);
			
	
				
				
	Inst_pixel_gen: entity work.pong_pixel_gen(Behavioral) PORT MAP(
				row => row_sig,
				column => column_sig,
				blank => blank,
				ball_x => ball_x_sig,
				ball_y => ball_y_sig,
				paddle_y => paddle_y_sig,
				r => red,
				g=>green,
				b=>blue
	 );

	Inst_pong_control: entity work.pong_control(Behavioral) PORT MAP(
				clk => pixel_clk,
				reset => reset, 
				up => up, 
				down => down, 
				v_completed => v_completed_sig,
				ball_x => ball_x_sig,
				ball_y => ball_y_sig,
				paddle_y => paddle_y_sig,
				faster => faster
	 );	 

    inst_dvid: entity work.dvid 
    port map(
                clk       => serialize_clk,
                clk_n     => serialize_clk_n, 
                clk_pixel => pixel_clk,
                red_p     => red,
                green_p   => green,
                blue_p    => blue,
                blank     => blank,
                hsync     => h_sync,
                vsync     => v_sync,
                -- outputs to TMDS drivers
                red_s     => red_s,
                green_s   => green_s,
                blue_s    => blue_s,
                clock_s   => clock_s
            );

    -- Output the HDMI data on differential signalling pins
    OBUFDS_blue  : OBUFDS port map
        ( O  => TMDS(0), OB => TMDSB(0), I  => blue_s  );
    OBUFDS_red   : OBUFDS port map
        ( O  => TMDS(1), OB => TMDSB(1), I  => green_s );
    OBUFDS_green : OBUFDS port map
        ( O  => TMDS(2), OB => TMDSB(2), I  => red_s   );
    OBUFDS_clock : OBUFDS port map
        ( O  => TMDS(3), OB => TMDSB(3), I  => clock_s );

end Behavioral;

