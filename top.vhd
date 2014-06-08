library IEEE;
use IEEE.std_logic_1164.all;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
  port(MCLK1: in  STD_LOGIC;
       RS_RX: in  STD_LOGIC;
       RS_TX: out STD_LOGIC);
end top;

architecture rtl of top is
  signal iclk, clk: std_logic;

  component loopback
    port(CLK: in std_logic;
         RxD: in std_logic;
         TxD: out std_logic);
  end component;

begin
  ib: IBUFG
    port map(i => MCLK1,
             o => iclk);

  bg: BUFG
    port map(i => iclk,
             o => clk);

  lp: LOOPBACK
    port map(CLK => CLK,
             RxD => RS_RX,
             TxD => RS_TX);

end rtl;
