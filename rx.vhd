library IEEE;
use IEEE.std_logic_1164.all;

entity Rx is
  generic(wtime : integer);
  port(sysclk : in std_logic;
       RxD : in std_logic;
       DOUT : out std_logic_vector(7 downto 0);
       BUSY : out std_logic);
end Rx;

architecture RTL of Rx is
  signal clk : std_logic;
  signal clk_cnt : integer range 0 to wtime; -- 9600bps
  signal clk_whalf : std_logic := '0';
  signal clk_wrun : std_logic := '0';

  type rx_state is (IDLING, STARTING, READING, STOPPING);

  signal state : rx_state := IDLING;

  signal d_cnt : integer range 0 to 7;
  signal d_buf : std_logic_vector(7 downto 0);
  signal d_dat : std_logic_vector(7 downto 0) := (others => '0');

begin

  -- clock generators
  clk <= '1' when clk_cnt = wtime else '0';
  process(sysclk)
  begin
    if rising_edge(sysclk) then
      if clk_whalf = '1' and clk_wrun = '0' then
        clk_cnt <= wtime / 2;            -- wait for a half period
        clk_wrun <= '1';
      elsif clk_cnt = wtime then
        clk_cnt <= 0;
        clk_wrun <= '0';
      else
        clk_cnt <= clk_cnt + 1;
      end if;
    end if;
  end process;

  -- state machine
  process(sysclk)
  begin
    if rising_edge(sysclk) then
      case state is
        when IDLING =>
          if RxD = '0' then
            state <= STARTING;
            clk_whalf <= '1';
          end if;
        when STARTING =>
          clk_whalf <= '0';
          if clk = '1' then
            state <= READING;
            d_cnt <= 0;
            d_buf <= (others => '0');
          end if;
        when READING =>
          if clk = '1' then
            d_buf <= RxD & d_buf(7 downto 1);
            if d_cnt = 7 then
              state <= STOPPING;
            else
              d_cnt <= d_cnt + 1;
            end if;
          end if;
        when STOPPING =>
          if clk = '1' then
            state <= IDLING;
            d_dat <= d_buf;
          end if;
      end case;
    end if;
  end process;

  DOUT <= d_dat;
  BUSY <= '0' when state = IDLING else '1';

end RTL;
