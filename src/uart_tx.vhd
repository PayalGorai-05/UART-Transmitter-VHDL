library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
    Port (
        clk       : in  STD_LOGIC;
        reset     : in  STD_LOGIC;
        tx_start  : in  STD_LOGIC;
        data_in   : in  STD_LOGIC_VECTOR(7 downto 0);

        tx_serial : out STD_LOGIC;
        tx_done   : out STD_LOGIC
    );
end uart_tx;

architecture Behavioral of uart_tx is

    type state_type is (IDLE, START, DATA, STOP);
    signal state : state_type := IDLE;

    signal bit_count : integer range 0 to 7 := 0;
    signal shift_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    signal tx_reg   : STD_LOGIC := '1';
    signal done_reg : STD_LOGIC := '0';

    ------------------------------------------------
    -- BAUD GENERATOR
    ------------------------------------------------
    signal baud_counter : integer range 0 to 3 := 0;
    signal baud_tick    : STD_LOGIC := '0';

begin

    tx_serial <= tx_reg;
    tx_done   <= done_reg;

    ------------------------------------------------
    -- BAUD RATE GENERATOR
    ------------------------------------------------
    process(clk, reset)
    begin

        if reset = '1' then

            baud_counter <= 0;
            baud_tick <= '0';

        elsif rising_edge(clk) then

            if baud_counter = 3 then

                baud_counter <= 0;
                baud_tick <= '1';

            else

                baud_counter <= baud_counter + 1;
                baud_tick <= '0';

            end if;

        end if;

    end process;

    ------------------------------------------------
    -- UART FSM
    ------------------------------------------------
    process(clk, reset)
    begin

        if reset = '1' then

            state <= IDLE;
            tx_reg <= '1';
            done_reg <= '0';
            bit_count <= 0;

        elsif rising_edge(clk) then

            if baud_tick = '1' then

                case state is

                    --------------------------------
                    when IDLE =>

                        tx_reg <= '1';
                        done_reg <= '0';

                        if tx_start = '1' then

                            shift_reg <= data_in;
                            bit_count <= 0;

                            state <= START;

                        end if;

                    --------------------------------
                    when START =>

                        tx_reg <= '0';

                        state <= DATA;

                    --------------------------------
                    when DATA =>

                        tx_reg <= shift_reg(bit_count);

                        if bit_count = 7 then

                            state <= STOP;

                        else

                            bit_count <= bit_count + 1;

                        end if;

                    --------------------------------
                    when STOP =>

                        tx_reg <= '1';
                        done_reg <= '1';

                        state <= IDLE;

                end case;

            end if;

        end if;

    end process;

end Behavioral;