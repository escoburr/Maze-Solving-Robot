----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:46:14 11/19/2014 
-- Design Name: 
-- Module Name:    paddle - Behavioral 
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

entity paddle is
    Port ( Vval : in STD_LOGIC;
			  S0 : in STD_LOGIC;
			  S1 : in STD_LOGIC;
			  S2 : in STD_LOGIC;
			  S3 : in STD_LOGIC;			  
			  pone : out  STD_LOGIC_VECTOR (8 downto 0);
           ptwo : out  STD_LOGIC_VECTOR (8 downto 0));
end paddle;

architecture Behavioral of paddle is
signal integer_pone : integer range 0 to 310 := 155;
signal integer_ptwo : integer range 0 to 310 := 155;
begin
process(Vval)
begin
if (Vval = '1') then

if (S0 = '1') then
if (integer_pone < 310) then
integer_pone<=integer_pone+1;
else
integer_pone<=310;
end if;
end if;

if (S1 = '1') then
if (integer_pone > 0) then
integer_pone<=integer_pone-1;
else
integer_pone<=0;
end if;
end if;

if (S2 = '1') then
if (integer_ptwo < 310) then
integer_ptwo<=integer_ptwo+1;
else
integer_ptwo<=310;
end if;
end if;

if (S3 = '1') then
if (integer_ptwo > 0) then
integer_ptwo<=integer_ptwo-1;
else
integer_ptwo<=0;
end if;
end if;

end if;

pone <= std_logic_vector(to_unsigned(integer_pone, 9));
ptwo <= std_logic_vector(to_unsigned(integer_ptwo, 9));


end process;



end Behavioral;

