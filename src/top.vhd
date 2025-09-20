library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
    port (
        clk     : in std_logic;
        led     : out std_logic
    );
end entity;

architecture rtl of top is
begin
    proc_name: process(clk)
        variable counter    : integer range 0 to 13499999 := 0;
    begin    
        if rising_edge(clk) then
            if counter = 13499999 then
                counter := 0;
                led <= not led;
            else 
                counter := counter + 1;
            end if; 
        end if;
    end process proc_name;
end architecture rtl;
