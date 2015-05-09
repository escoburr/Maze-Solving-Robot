----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:57:51 11/06/2014 
-- Design Name: 
-- Module Name:    portmap - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity portmap is
Port(
	SW0			 :    in STD_LOGIC;
	SW1			 :    in STD_LOGIC;
	SW2			 :    in STD_LOGIC;
	SW3			 :    in STD_LOGIC;	
	clk			 : 	in STD_LOGIC;
	DAC_CLK 		 :	   out STD_LOGIC;
	H 				 : 	out STD_LOGIC;
	V 				 : 	out STD_LOGIC;	
	Rout 			 : 	out STD_LOGIC_VECTOR(7 downto 0);	
	Bout 			 : 	out STD_LOGIC_VECTOR(7 downto 0);	
	Gout 			 : 	out STD_LOGIC_VECTOR(7 downto 0)
	);		
end portmap;

architecture Behavioral of portmap is
component DACclk
PORT (
		clk : in  STD_LOGIC;
      dclk : out  STD_LOGIC
	  );
	  
end component;

component Hsync
PORT (
		dclk : in  STD_LOGIC;
      Hcount : out  STD_LOGIC_VECTOR(9 downto 0)
	  );
	  
end component;

component Vsync
PORT ( dclk : in STD_LOGIC;
		Hcount : in  STD_LOGIC_VECTOR(9 downto 0);
      Vcount : out  STD_LOGIC_VECTOR(9 downto 0)
	  );
end component;

component VidControl
    Port ( fcsig : out STD_LOGIC;
			  squarex : in STD_LOGIC_VECTOR(9 downto 0);
			  squarey : in STD_LOGIC_VECTOR(8 downto 0);
	        padone : in STD_LOGIC_VECTOR(8 downto 0);
			  padtwo : in STD_LOGIC_VECTOR(8 downto 0);
			  Hsync_in : in  STD_LOGIC_VECTOR(9 downto 0);
           Vsync_in : in  STD_LOGIC_VECTOR(9 downto 0);
           dclk : in  STD_LOGIC;
           H : out  STD_LOGIC;
           V : out  STD_LOGIC;
			  red_out : out STD_LOGIC_VECTOR(7 downto 0);
			  blue_out : out STD_LOGIC_VECTOR(7 downto 0);
			  green_out : out STD_LOGIC_VECTOR(7 downto 0)
			 );
end component;

component reg8
    Port ( d : in  STD_LOGIC_VECTOR (7 downto 0);
           q : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC
			);
end component;		

component paddle
    Port ( Vval : in STD_LOGIC;
			  S0 : in STD_LOGIC;
			  S1 : in STD_LOGIC;
			  S2 : in STD_LOGIC;
			  S3 : in STD_LOGIC;			  
			  pone : out  STD_LOGIC_VECTOR (8 downto 0);
           ptwo : out  STD_LOGIC_VECTOR (8 downto 0));
end component;	

component ball
    Port ( Vval : in STD_LOGIC;
		     pyone : in  STD_LOGIC_VECTOR (8 downto 0);
           pytwo : in  STD_LOGIC_VECTOR (8 downto 0);
           yout : out  STD_LOGIC_VECTOR (8 downto 0);
           xout : out  STD_LOGIC_VECTOR (9 downto 0));
end component;

signal Hout : STD_LOGIC_VECTOR(9 downto 0);
signal Vout : STD_LOGIC_VECTOR(9 downto 0);
signal red : STD_LOGIC_VECTOR(7 downto 0);
signal blue : STD_LOGIC_VECTOR(7 downto 0);
signal green : STD_LOGIC_VECTOR(7 downto 0);
signal dclk : STD_LOGIC;
signal paddleone : STD_LOGIC_VECTOR(8 downto 0);
signal paddletwo : STD_LOGIC_VECTOR(8 downto 0);
signal ballx : STD_LOGIC_VECTOR(9 downto 0);
signal bally : STD_LOGIC_VECTOR(8 downto 0);
signal Vsig : STD_LOGIC;
signal Bsig : STD_LOGIC;
signal slowmedown : integer range 0 to 840000;
signal chaoscontrol : integer range 0 to 1680000;
signal fc : STD_LOGIC;

begin

 DAClk :	DACclk 
PORT MAP (
		clk => clk,
      dclk => dclk
	  );	 
	 
	 
	Hsyn : Hsync 
	PORT MAP (
		dclk => dclk,
      Hcount => Hout
	  );	 
	  
	Vsyn : Vsync 
	PORT MAP ( dclk => dclk,
		Hcount => Hout,
      Vcount => Vout
	  );

Decoder : VidControl
    Port MAP ( fcsig => fc,
			  squarex => ballx,
			  squarey => bally,
	        padone => paddleone,
			  padtwo => paddletwo,
			  Hsync_in => Hout,
           Vsync_in => Vout,
           dclk => dclk,
           H => H,
           V => V,
			  red_out => red ,
			  blue_out => blue,
			  green_out => green
			 );
			 
red8 : reg8
    Port Map( d => red,
           q => Rout,
           clk => dclk
			);	

blue8 : reg8
    Port Map( d => blue,
           q => Bout,
           clk => dclk
			);	

green8 : reg8
    Port Map( d => green,
           q => Gout,
           clk => dclk
			);				 

pads : paddle 
    Port Map ( Vval => fc,
			  S0 => SW0,
			  S1 => SW1,
			  S2 => SW2,
			  S3 => SW3,
			  pone => paddleone,
           ptwo => paddletwo
);


square : ball
    Port Map( Vval => fc,
			  pyone => paddleone,
           pytwo => paddletwo,
           yout => bally,
           xout => ballx
);

process (fc)
begin
--if (fcsig='1') then



--end if;
end process;
DAC_CLK <= dclk;	
end Behavioral;

