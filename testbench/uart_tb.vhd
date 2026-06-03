library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_tb is
end uart_tb;

architecture Behavioral of uart_tb is

component uart_tx
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        tx_start  : in  STD_LOGIC;
        data_in   : in  STD_LOGIC_VECTOR(7 downto 0);

        tx_serial : out STD_LOGIC;
        tx_done   : out STD_LOGIC
    );
end component;

signal clk       : STD_LOGIC := '0';
signal reset     : STD_LOGIC := '0';
signal tx_start  : STD_LOGIC := '0';

signal data_in   : STD_LOGIC_VECTOR(7 downto 0);

signal tx_serial : STD_LOGIC;
signal tx_done   : STD_LOGIC;

begin

uut: uart_tx
port map(
    clk => clk,
    reset => reset,
    tx_start => tx_start,
    data_in => data_in,
    tx_serial => tx_serial,
    tx_done => tx_done
);

------------------------------------------------
-- CLOCK
------------------------------------------------
clk_process : process
begin

    while true loop

        clk <= '0';
        wait for 10 ns;

        clk <= '1';
        wait for 10 ns;

    end loop;

end process;

------------------------------------------------
-- STIMULUS
------------------------------------------------
stimulus : process
begin

    reset <= '1';
    wait for 40 ns;

    reset <= '0';

    ------------------------------------------------
    -- TRANSMIT 10101010
    ------------------------------------------------
    data_in <= "10101010";

tx_start <= '1';
wait for 120 ns;
tx_start <= '0';

    wait;

end process;

end Behavioral;