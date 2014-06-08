library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity loopback is
  port(CLK : in std_logic;
       RxD : in std_logic;
       TxD : out std_logic);
end loopback;

architecture RTL of loopback is
  signal DOUT : std_logic_vector(7 downto 0);
  signal DIN : std_logic_vector(7 downto 0);
  signal Tx_GO : std_logic := '0';
  signal Rx_BUSY : std_logic;
  signal Tx_BUSY : std_logic;

  component UART
    port(CLK : in std_logic;
         RxD : in std_logic;
         TxD : out std_logic;
         DOUT : out std_logic_vector(7 downto 0);
         DIN : in std_logic_vector(7 downto 0);
         Tx_GO : in std_logic;
         Rx_BUSY : out std_logic;
         Tx_BUSY : out std_logic);
  end component;

  signal prev_busy : std_logic := '0';
  signal data_ready : std_logic := '0';

begin
  uUART : UART
    port map(CLK => CLK,
             RxD => RxD,
             TxD => TxD,
             DOUT => DOUT,
             DIN => DIN,
             Tx_GO => Tx_GO,
             Rx_BUSY => Rx_BUSY,
             Tx_BUSY => Tx_BUSY);

  process(clk)
  begin
    if rising_edge(clk) then
      -- read
      if prev_busy /= Rx_BUSY then
        if Rx_BUSY = '0' then
          if 97 <= conv_integer(DOUT) and conv_integer(DOUT) <= 122 then
            DIN <= DOUT - x"20";
          else
            DIN <= DOUT;
          end if;
          data_ready <= '1';
        end if;
        prev_busy <= Rx_BUSY;
      end if;
      -- write
      if Tx_BUSY = '0' and Tx_GO = '0' and data_ready = '1'then
        Tx_GO <= '1';
        data_ready <= '0';
      else
        Tx_GO <= '0';
      end if;
    end if;
  end process;

end RTL;
