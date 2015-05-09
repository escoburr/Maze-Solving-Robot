----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:17:48 11/20/2014 
-- Design Name: 
-- Module Name:    ball - Behavioral 
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ball is
    Port ( Vval : in STD_LOGIC;
	        pyone : in  STD_LOGIC_VECTOR (8 downto 0);
           pytwo : in  STD_LOGIC_VECTOR (8 downto 0);
           yout : out  STD_LOGIC_VECTOR (8 downto 0);
           xout : out  STD_LOGIC_VECTOR (9 downto 0));
end ball;

architecture Behavioral of ball is
signal int_ypos : integer range 0 to 310 := 150;
signal int_xpos : integer range 0 to 580 := 290;
signal int_pone : integer;
signal int_ptwo : integer;
signal xy : std_logic_vector(1 downto 0) := "11";

begin
process (Vval)
begin
if (Vval = '1') then

int_pone<=conv_integer(pyone);
int_ptwo<=conv_integer(pytwo);

if (((int_ypos+10 > int_pone)or(int_ypos+10 > int_ptwo)) or ((int_ypos < int_pone+100)or(int_ypos < int_ptwo+100))) then
if (int_xpos < 21 or int_xpos+10 > 559) then
xy(0)<=NOT(xy(0));
end if;
else 
if (int_xpos < 1 or int_xpos+10 > 579) then
xy(0)<=NOT(xy(0));
end if;
end if;

if(int_ypos < 1 or int_ypos+10 >309) then
xy(1)<=NOT(xy(1));
end if;

if (xy(1) = '1') then
int_ypos<=int_ypos+1;
elsif (xy(1) = '0') then
int_ypos<=int_ypos-1;
end if;

if (xy(0) = '1') then
int_xpos<=int_xpos+1;
elsif (xy(0) = '0') then
int_xpos<=int_xpos-1;
end if;

yout <= std_logic_vector(to_unsigned(int_ypos, 9));
xout <= std_logic_vector(to_unsigned(int_xpos, 10));

end if;
end process;
end Behavioral;

