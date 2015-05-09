----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:24:58 11/06/2014 
-- Design Name: 
-- Module Name:    DAC_clk - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DACclk is
    Port ( clk : in  STD_LOGIC;
           dclk : out  STD_LOGIC);
end DACclk;

architecture Behavioral of DACclk is
signal temp : STD_LOGIC; 
begin 
process(clk)
begin
if(clk'EVENT AND clk = '1') then
if(temp = '0')then
temp <= '1';
else
temp <= '0';
end if;
end if;
end process;
dclk <= temp;
end Behavioral;

