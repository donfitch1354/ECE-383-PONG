383_Pong
========

FPGA VHDL code for a simple game


Basic Idea: The point of this lab was to create a simple game using a previously written VGA sync module, a pong control module, and a pixel generation module all instantiated in a central top level video module. The game (pong) needed to have a ball that moved constantly and was bounded correctly and a paddle controlled by two buttons. Additionally the game needed to have a large AF in the center of the screen. The block diagram for the project is shown below (image courtesy of Will Parks)

![alt tag](https://github-camo.global.ssl.fastly.net/1d4026f9081063d064f714087fa2f332b740ef06/687474703a2f2f692e696d6775722e636f6d2f6178776a6a32522e706e67)



Pong Pixel Gen Module: 

    entity pong_pixel_gen is
      Port (  
              row : in  unsigned (10 downto 0);
              column : in  unsigned (10 downto 0);
              blank : in  STD_LOGIC;
              ball_x : in  unsigned (10 downto 0);
              ball_y : in  unsigned (10 downto 0);
              paddle_y : in  unsigned (10 downto 0);
              r,g,b : out  STD_LOGIC_vector (7 downto 0)
			  
			  );
end pong_pixel_gen;

inputs row and column specify which pixel is being written to. Blank is self-explainatory and ballx / bally / paddle_y are all inputs from the pong control module that dictate game logic. r,g,b specify output pixel values to send to the vga controller. 

the biggest issue I had in this module was that I wrote the AF logo by columns rather than modularly so in order to make the ball go under the logo i had to add 6 ball write statements instead of just one at the end of the AF 
logo logic. 



Pong Control Module: 
	
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
    
Up, down  and faster were inputs from the video module that were linked to physical inputs via the UCF file. V_completed signaled the completion of one screen on the monitor and was used as the basic clock for all control logic. The biggest issue I had in this module was a very scattered approach. I ended up using 10 states in the actual game logic. In reality, I probably only needed about 6 (i used have split the logic into movement, current state, and direction). 
    
  
    Testing and debugging
    
    changes were not commited to GIT due to an inability to use the lab computer on the site. The biggest probems overall were in the control module due to a poor approach. next time i will do a lot more initial planning and maintain an open mind to scrapping code that is inefficient or incorrect. 
    
    Conclusion
    
    Modularity is very helpful (achieved B functionality in just two tries due to the modular nature of my code) in that it makes adding functionality, troubleshooting, and code readability much easier than in a more 
    generalized approach. 
