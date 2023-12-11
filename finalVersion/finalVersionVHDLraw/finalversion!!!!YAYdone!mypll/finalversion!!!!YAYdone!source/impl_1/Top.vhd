library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Top is port(
	input: in std_logic;
	output_pll_core: out std_logic; --12
	hsync_output : out std_logic;
	vsync_output : out std_logic;
	rgb_output: out std_logic_vector(5 downto 0);
    latch : out std_logic;     
	data1 : in std_logic;
	
	nesclk : out std_logic;
	
	latch2 : out std_logic;     			
	data2 : in std_logic;
	
	nesclk2 : out std_logic;
	
	debug: out std_logic;
	debug2: out std_logic
    
);
end entity Top;

architecture synth of Top is 
	component mypll is
    port(
        ref_clk_i: in std_logic;
        rst_n_i: in std_logic;
        outcore_o: out std_logic;
        outglobal_o: out std_logic
    );
end component mypll;
	
	component NES is	
		port(		
		    latch : out std_logic;     			
			data : in std_logic;
			dataout : out unsigned(7 downto 0);
			nesclk : out std_logic;
			clk3 : in std_logic
		);
	
	end component;	
		
	component NES2 is	
		port(		
		    latch2 : out std_logic;     			
			data2 : in std_logic;
			dataout2 : out unsigned(7 downto 0);
			nesclk2 : out std_logic;
			clk32 : in std_logic
		);
	
	end component;	

	component physics is 
		port(
	  tank_x1 : out unsigned(9 downto 0):= 10d"400";
	  tank_y1 : out unsigned(9 downto 0):= 10d"100";
      ball_x1 : out unsigned(9 downto 0) ; -- row
      ball_y1 : out unsigned(9 downto 0) ; -- col
	  
	  tank_x2 : out unsigned(9 downto 0):= 10d"400";
	  tank_y2 : out unsigned(9 downto 0):= 10d"600";
      ball_x2 : out unsigned(9 downto 0) ; -- row
      ball_y2 : out unsigned(9 downto 0) ; -- col
	  
	  
	  
	     angle_up : in std_logic;
	     angle_down : in std_logic;
		 move_right : in std_logic;
	     move_left : in std_logic;
		 
		 angle_up2 : in std_logic;
	     angle_down2 : in std_logic;
		 move_right2 : in std_logic;
	     move_left2 : in std_logic;
		 fire2 : in std_logic ;
		 
         frame_clk : in std_logic;
		 player : in std_logic ;
		 fire: in std_logic ;
		 fired_output : out std_logic;
		 game_over : in std_logic
		 
	  );
	  end component;
	
	component vga port (
			clk : in std_logic;
			hsync : out std_logic;
			vsync : out std_logic;
			row : out unsigned (9 downto 0); -- includes vsync rows
			col : out unsigned (9 downto 0); -- includes hsync rows
			full_frame_clk : out std_logic;
			valid : out std_logic
	);
	end component vga;
	
	component pattern_gen port(
		frame_clk : in std_logic;
		clk : in std_logic;
		row_idx : in unsigned(9 downto 0);
		col_idx : in unsigned(9 downto 0);
			  tank_x1 : out unsigned(9 downto 0):= 10d"400";
     R_hit : out std_logic := '0';
	 L_hit : out std_logic := '0';
	  tank_y1 : in unsigned(9 downto 0):= 10d"100";
      ball_x1 : in unsigned(9 downto 0) ; -- row
      ball_y1 : in unsigned(9 downto 0) ; -- col
	  
	  tank_x2 : in unsigned(9 downto 0):= 10d"400";
	  tank_y2 : in unsigned(9 downto 0):= 10d"600";
      ball_x2 : in unsigned(9 downto 0) ; -- row
      ball_y2 : in unsigned(9 downto 0) ; -- col
	  
		valid_input: in std_logic;
		rgb: out std_logic_vector(5 downto 0);
	    start_screen : in std_logic;
		
		hit : out std_logic;
	    playing_screen : in std_logic;
		Game_overscreen : in std_logic;
		fire: in std_logic
	);
	end component pattern_gen;


	component GameLogic port(
	    clk : in std_logic;
        Start_Button : in std_logic;
		Select_Button : in std_logic;
	    PlayingScreen : out std_logic;
		
		hit : in std_logic;
		player : out std_logic  ;
		R_hit : in std_logic;
	    L_hit : in std_logic ;
	    StartScreen : out std_logic;
		GameoverScreen : out std_logic
	);
	end component GameLogic;


component HSOSC is
		generic (
			CLKHF_DIV : String := "0b00"); -- Divide 48MHz clock by 2�N (0-3)
		port(
			CLKHFPU : in std_logic := 'X'; -- Set to 1 to power up
			CLKHFEN : in std_logic := 'X'; -- Set to 1 to enable output
			CLKHF : out std_logic := 'X'); -- Clock output
	end component;
	
	

signal output_pll_global: std_logic;
signal row_output : unsigned(9 downto 0);
signal col_output : unsigned(9 downto 0);
signal valid_output: std_logic;
signal Dataout1 : unsigned(7 downto 0);
signal Dataout22 : unsigned(7 downto 0);
signal wire1 : std_logic;
signal player1 :  std_logic := '1';
signal player2 :  std_logic := '0';
signal angle : unsigned(2 downto 0) := "001";
signal fired_status : std_logic; 
signal game_start  : std_logic := '1';
signal game_over  : std_logic := '0';
signal col_ball1 : unsigned(9 downto 0); -- player 1 col, row
signal row_ball1 : unsigned(9 downto 0); 
signal col_ball2 : unsigned(9 downto 0); -- player 1 col, row
signal row_ball2 : unsigned(9 downto 0); 
signal Playing_state_wire : std_logic;
signal start_state_wire : std_logic;

signal TankX1: unsigned(9 downto 0); 
signal TankY1: unsigned(9 downto 0); 
signal TankX2: unsigned(9 downto 0); 
signal TankY2: unsigned(9 downto 0); 
signal hitwire : std_logic;
signal player_wire : std_logic;
signal hsyncvga, vsyncvga: std_logic;
signal clk3_wire : std_logic;
signal R_hit_wire , L_hit_wire : std_logic;
signal Game_over_wire: std_logic;
signal Game_over_screenwire : std_logic := '0';
signal rgbcolor : std_logic_vector(5 downto 0);

begin
	
	debug <= dataout1(6);
	debug2 <= Playing_state_wire;
	pll_test : mypll port map (
			ref_clk_i => input,
			rst_n_i => '1',
			outcore_o => output_pll_core,
			outglobal_o =>  output_pll_global
	);
	vga_test : vga port map (
		clk => output_pll_global,
		hsync => hsyncvga,
		vsync => vsyncvga,
		row => row_output,
		col => col_output,
		full_frame_clk => wire1,
		valid => valid_output
	);

	pattern_gen_test : pattern_gen port map (
	
		frame_clk => wire1,
		clk => output_pll_global,
		row_idx => row_output,
		col_idx => col_output,
		tank_x1 => TankX1,
		tank_y1 => TankY1,
		tank_x2 => TankX2,
		tank_y2 => TankY2,
		ball_x1  => row_ball1,
	    ball_y1 => col_ball1,
		ball_x2  => row_ball2,
	    ball_y2 => col_ball2 + 420,
		valid_input => valid_output,
		rgb => rgbcolor,
		
		
		hit => hitwire,
	    R_hit => R_hit_wire,
	    L_hit => L_hit_wire,
		
		start_screen => start_state_wire,
		
		playing_screen => Playing_state_wire,
		Game_overscreen => Game_over_screenwire,
		
		fire => fired_status
		
		
		
		
	);
	

osc : HSOSC generic map ( CLKHF_DIV => "0b00")
		port map (CLKHFPU => '1',
			CLKHFEN => '1',
			CLKHF => clk3_wire);
			
			
NES0: NES
	port map(
		    latch => latch, 			
			data => data1,
			dataout => Dataout1,
			nesclk => nesclk,
            clk3 => clk3_wire
	);
	
NES20: NES2
	port map(
		    latch2 => latch2, 			
			data2 => data2,
			dataout2 => Dataout22,
			nesclk2 => nesclk2,
            clk32 =>clk3_wire
	);


physics_test : physics
	port map(
		 ball_x1 => row_ball1,
         ball_y1 => col_ball1,
		 tank_x1 => TankX1,
		 tank_y1 => TankY1,
		 ball_x2 => row_ball2,
         ball_y2 => col_ball2,
		 tank_x2 => TankX2,
		 tank_y2 => TankY2,
		 
		 
		 angle_up => Dataout1(2),
		 angle_down => Dataout1(3),
		 move_right => Dataout1(0), 
	     move_left => Dataout1(1),
		 fire => Dataout1(7),
		 
		 angle_up2 => Dataout22(2),
		 angle_down2 => Dataout22(3),
		 move_right2 => Dataout22(0), 
	     move_left2 => Dataout22(1),
		 fire2 => Dataout22(7),
		 
         frame_clk => wire1,
		 player => player_wire,
		
		 fired_output => fired_status,
		 
		 game_over => Game_over_screenwire
	);
 
GameLogic_test : GameLogic
port map ( 

	    clk => wire1,
        Start_Button => Dataout1(4),
		Select_Button => Dataout1(5),
		
		hit => hitwire,
		player => player_wire,
		R_hit => R_hit_wire,
	    L_hit => L_hit_wire,
		
		PlayingScreen => Playing_state_wire,
		
		StartScreen => start_state_wire,
		GameoverScreen => Game_over_screenwire
);

process (output_pll_global) begin
		if rising_edge(output_pll_global) then
			rgb_output <= rgbcolor;
			hsync_output <= hsyncvga;
			vsync_output <= vsyncvga;
		end if;
	end process;





	

end architecture synth;
