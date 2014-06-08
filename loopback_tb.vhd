library IEEE;
use IEEE.std_logic_1164.all;


entity loopback_tb is
end loopback_tb;

architecture rtl of loopback_tb is
  signal CLK: std_logic;
  signal TXD: std_logic;
  signal RXD: std_logic;

  -- global clock period
  constant CP: time := 15.15 ns;
  -- bit rate (1 / 9600bps)
  constant BR: time := 104166 ns;

  component loopback
    port(CLK: in std_logic;
         RXD: in std_logic;
         TXD: out std_logic);
  end component;

begin
  lp: loopback
    port map(CLK => CLK,
             RXD => RXD,
             TXD => TXD);

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

    RXD <= '1';

    wait for (16 * BR);

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

--    wait for (2 * BR);

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
