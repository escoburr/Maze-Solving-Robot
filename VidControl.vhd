----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:30:57 11/06/2014 
-- Design Name: 
-- Module Name:    VidControl - Behavioral 
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

entity VidControl is
    Port ( fcsig : out STD_LOGIC;
	        padone : in STD_LOGIC_VECTOR(8 downto 0);
			  padtwo : in STD_LOGIC_VECTOR(8 downto 0);
			  squarex : in STD_LOGIC_VECTOR(9 downto 0);
			  squarey : in STD_LOGIC_VECTOR(8 downto 0);
			  Hsync_in : in  STD_LOGIC_VECTOR(9 downto 0);
           Vsync_in : in  STD_LOGIC_VECTOR(9 downto 0);
           dclk : in  STD_LOGIC;
           H : out  STD_LOGIC;
           V : out  STD_LOGIC;
			  red_out : out STD_LOGIC_VECTOR(7 downto 0);
			  blue_out : out STD_LOGIC_VECTOR(7 downto 0);
			  green_out : out STD_LOGIC_VECTOR(7 downto 0)
			 );
end VidControl;

architecture Behavioral of VidControl is
signal integer_h : integer range 0 to 1023;
signal integer_v : integer range 0 to 1023;
signal integer_padone : integer;
signal integer_padtwo : integer;
signal ballx : integer range 190 to 770 :=190;
signal bally : integer range 80 to 390 :=80;
signal fc : std_logic := '0';
signal chaoscontrol : integer range 0 to 2040 := 0;

begin		
process(Hsync_in,dclk)
begin
if(dclk'EVENT and dclk ='1')then
if(Hsync_in < "0000010000")then -- front porch
		H <= '1';
elsif(Hsync_in >= "0000010000" and Hsync_in < "0001110000")then -- sync pulse
		H <= '0';
elsif(Hsync_in >= "0001110000" and Hsync_in < "0010100000")then -- back porch
		H <= '1';
elsif(Hsync_in > "0010100000")then
	H <= '1';
end if;
end if;
end process;

process(Vsync_in,dclk)
begin
if(dclk'EVENT and dclk ='1')then
if (Vsync_in = "0000000000") then
chaoscontrol<=chaoscontrol+1;
if (chaoscontrol = 2040) then
fcsig<='1';
else
fcsig<='0';
end if;
end if;
if(Vsync_in < "0000001010")then -- front porch
		V <= '1';
elsif(Vsync_in >= "0000001010" and Vsync_in < "0000001100")then -- sync pulse
		V <= '0';
elsif(Vsync_in >= "0000001100" and Vsync_in < "0000101101")then -- back porch
		V <= '1';
elsif(Vsync_in > "0000101101")then
		V <= '1';
end if;
end if;
end process;

process(Hsync_in,Vsync_in,dclk)
begin
--"0010100000"
if(dclk'EVENT and dclk = '1')then
integer_h<=(conv_integer(Hsync_in));
integer_v<=(conv_integer(Vsync_in));
if(integer_h > 160 and integer_h < 800 and integer_v > 45 and integer_v < 60)then
		red_out <= "00000000";		
		green_out <= "11111111";
		blue_out <= "00000000";    --top green
elsif(integer_h > 160 and integer_h < 175 and integer_v > 59 and integer_v < 525)then
		red_out <= "00000000";		
		green_out <= "11111111";
		blue_out <= "00000000"; --top left edge green
elsif(integer_h > 785 and integer_h < 800 and integer_v > 59 and integer_v < 525)then
		red_out <= "00000000";		
		green_out <= "11111111";
		blue_out <= "00000000"; --top right edge green		
elsif(integer_h > 175 and integer_h < 785 and integer_v > 60 and integer_v < 80)then
		red_out <= "11111101";		
		green_out <= "11010111";
		blue_out <= "11111011";   --top border
elsif(integer_h > 175 and integer_h < 785 and integer_v > 490 and integer_v < 510)then
		red_out <= "11111101";		
		green_out <= "11010111";
		blue_out <= "11111011";   --bottom border		
elsif(integer_h > 160 and integer_h < 800 and integer_v > 510 and integer_v < 525)then
		red_out <= "00000000";		
		green_out <= "11111111";
		blue_out <= "00000000";    --bottom green
elsif(integer_h > 175 and integer_h < 190 and integer_v > 79 and integer_v < 200)then
		red_out <= "11111101";		
		green_out <= "11010111";
		blue_out <= "11111011";  --top left border
elsif(integer_h > 770 and integer_h < 785 and integer_v > 79 and integer_v < 200)then
			red_out <= "11111101";		
		green_out <= "11010111";
		blue_out <= "11111011";  --top right border
elsif(integer_h > 175 and integer_h < 190 and integer_v > 390 and integer_v < 491)then
		red_out <= "11111101";		
		green_out <= "11010111";
		blue_out <= "11111011";  --bottom left border
elsif(integer_h > 770 and integer_h < 785 and integer_v >390 and integer_v < 491)then
		red_out <= "11111101";		
		green_out <= "11010111";
		blue_out <= "11111011";  --bottom right border
elsif((integer_h > 160 and integer_h < 800 and integer_v > 200 and integer_v < 390) or (integer_h > 190 and integer_h < 770 and integer_v > 80 and integer_v < 490))then
		red_out <= "00000000";		
		green_out <= "11111111";
		blue_out <= "00000000";    --middle green	
else
		red_out <= (OTHERS => '0');		
		green_out <= (OTHERS => '0');
		blue_out <= (OTHERS => '0');
end if;		
if(integer_h > 477 and integer_h < 483) then   -- middle black partitions
	if ((integer_v >85 and integer_v < 116) or (integer_v >126 and integer_v < 157))then
		red_out <= (OTHERS => '0');		
		green_out <= (OTHERS => '0');
		blue_out <= (OTHERS => '0');	
	elsif ((integer_v >167 and integer_v < 198) or (integer_v >208 and integer_v < 239))then
		red_out <= (OTHERS => '0');		
		green_out <= (OTHERS => '0');
		blue_out <= (OTHERS => '0');
   elsif ((integer_v >249 and integer_v < 280) or (integer_v >290 and integer_v < 321)) then
		red_out <= (OTHERS => '0');		
		green_out <= (OTHERS => '0');
		blue_out <= (OTHERS => '0');		
	elsif ((integer_v >331 and integer_v < 362) or (integer_v >372 and integer_v < 403)) then
		red_out <= (OTHERS => '0');		
		green_out <= (OTHERS => '0');
		blue_out <= (OTHERS => '0');
	elsif ((integer_v >413 and integer_v < 444) or (integer_v >454 and integer_v < 485)) then
		red_out <= (OTHERS => '0');		
		green_out <= (OTHERS => '0');
		blue_out <= (OTHERS => '0');		
	end if;	
end if;

ballx <= conv_integer(squarex)+190;
bally <= conv_integer(squarey)+80;

if (integer_h > ballx and integer_h < ballx+10 and integer_v >bally and integer_v < bally+10) then
		red_out <= "10101010";		
		green_out <= "01111110";
		blue_out <= "01001110";
end if;


integer_padone <= conv_integer(padone)+80;
integer_padtwo <= conv_integer(padtwo)+80;


if (integer_h > 190 and integer_h < 210 and integer_v > integer_padone and integer_v < integer_padone+100 ) then
		red_out <= "00000000";		
		green_out <= "00000000";
		blue_out <= "11111111";
end if;
if (integer_h > 750 and integer_h < 770 and integer_v > integer_padtwo and integer_v < integer_padtwo+100 ) then
		red_out <= "11111111";		
		green_out <= "00000000";
		blue_out <= "00000000";
end if;
end if;
end process;
end Behavioral;
