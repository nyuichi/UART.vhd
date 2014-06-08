library IEEE;
use IEEE.std_logic_1164.all;


entity tb_UART is
end tb_UART;

architecture rtl of tb_UART is
  signal CLK: std_logic;
  signal TXD: std_logic;
  signal RXD: std_logic;
  signal DIN: std_logic_vector(7 downto 0);
  signal DOUT: std_logic_vector(7 downto 0);
  signal TX_GO: std_logic;

  -- global clock period
  constant CP: time := 15 ns;
  -- bit rate (1 / 9600bps)
  constant BR: time := 104166 ns;

  component UART port(
    CLK: in std_logic;
    RXD: in std_logic;
    TXD: out std_logic;
    DOUT: out std_logic_vector(7 downto 0);
    DIN: in std_logic_vector(7 downto 0);
    TX_GO: in std_logic;
    RX_BUSY: out std_logic);
  end component;

begin
  uUART: UART port map(
    CLK => CLK,
    RXD => RXD,
    TXD => TXD,
    DOUT => DOUT,
    DIN => DIN,
    TX_GO => TX_GO);

  -- clock signal
  process
  begin
    CLK <= '0';
    wait for CP / 2;
    CLK <= '1';
    wait for CP / 2;
  end process;

  process
  begin
    RXD <= '1'; DIN <= x"ff"; TX_GO <= '0';

    wait for CP; DIN <= x"65";
    wait for CP; TX_GO <= '1';
    wait for CP; TX_GO <= '0';

    --wait for (16 * BR); EN_RX <= '1';
    --wait for CP; EN_RX <= '0';

    wait for BR; RXD <= '0'; -- start-bit
    wait for BR; RXD <= '1'; -- data-bit 8'hc5
    wait for BR; RXD <= '0';
    wait for BR; RXD <= '1';
    wait for BR; RXD <= '0';
    wait for BR; RXD <= '0';
    wait for BR; RXD <= '0';
    wait for BR; RXD <= '1';
    wait for BR; RXD <= '1';
    wait for BR; RXD <= '1'; -- stop-bit

    wait for (2 * BR); -- EN_RX <= '1';
    wait for CP; -- EN_RX <= '0';

    wait for BR; RXD <= '0'; -- start-bit
    wait for BR; RXD <= '0'; -- data-bit 8'hf0
    wait for BR; RXD <= '0';
    wait for BR; RXD <= '0';
    wait for BR; RXD <= '0';
    wait for BR; RXD <= '1';
    wait for BR; RXD <= '1';
    wait for BR; RXD <= '1';
    wait for BR; RXD <= '1';
    wait for BR; RXD <= '1'; -- stop-bit

--    assert false report "Simulation End." severity failure;
  end process;

end rtl;
