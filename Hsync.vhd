----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:43:27 11/06/2014 
-- Design Name: 
-- Module Name:    Hsync - Behavioral 
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

entity Hsync is
    Port ( dclk : in  STD_LOGIC;
           Hcount : out  STD_LOGIC_VECTOR(9 downto 0));
end Hsync;

architecture Behavioral of Hsync is
signal counter : STD_LOGIC_VECTOR(9 downto 0); 

begin
process (dclk)
begin
if (dclk'Event and dclk='1') then
if(counter = "1100100000") then
counter <= "0000000000";
else
counter <= counter + "0000000001";
end if;
end if;
end process;
Hcount <= counter;
end Behavioral;

