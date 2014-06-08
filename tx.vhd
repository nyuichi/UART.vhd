library IEEE;
use IEEE.std_logic_1164.all;

entity Tx is
  generic(wtime : integer);
  port(sysclk : in std_logic;
       TxD : out std_logic;
       DIN : in std_logic_vector(7 downto 0);
       GO : in std_logic;
       BUSY : out std_logic);
end Tx;

architecture RTL of Tx is
  signal clk : std_logic;
  signal clk_cnt : integer range 0 to wtime; -- 9600bps

  signal d_ready : std_logic := '0';

  type rx_state is (IDLING, STARTING, WRITING, STOPPING);

  signal state : rx_state := IDLING;

  signal d_cnt : integer range 0 to 7;
  signal d_buf : std_logic_vector(7 downto 0) := (others => '1');
  signal d_dat : std_logic := '1';

begin

  -- clock generators
  clk <= '1' when clk_cnt = wtime else '0';
  process(sysclk)
  begin
    if rising_edge(sysclk) then
      if clk_cnt = wtime then
        clk_cnt <= 0;
      else
        clk_cnt <= clk_cnt + 1;
      end if;
    end if;
  end process;

  -- state machine
  process(sysclk)
  begin
    if rising_edge(sysclk) then
      if GO = '1' then
        d_ready <= '1';
        d_buf <= DIN;
      elsif clk = '1' then
        case state is
          when IDLING =>
            d_dat <= '1';
            if d_ready = '1' then
              state <= STARTING;
            end if;
          when STARTING =>
            state <= WRITING;
            d_cnt <= 0;
            d_dat <= '0';
          when WRITING =>
            d_dat <= d_buf(d_cnt);
            if d_cnt = 7 then
              state <= STOPPING;
            else
              d_cnt <= d_cnt + 1;
            end if;
          when STOPPING =>
            d_dat <= '1';
            d_ready <= '0';
            state <= IDLING;
        end case;
      end if;
    end if;
  end process;

  TxD <= d_dat;
  BUSY <= '0' when d_ready = '0' else '1';

end RTL;
