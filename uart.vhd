library IEEE;
use IEEE.std_logic_1164.all;

entity UART is
  port(CLK : in std_logic;
       RxD : in std_logic;
       TxD : out std_logic;
       DOUT : out std_logic_vector(7 downto 0);
       DIN : in std_logic_vector(7 downto 0);
       Tx_GO : in std_logic;
       Rx_BUSY : out std_logic;
       Tx_BUSY : out std_logic);
end UART;

architecture RTL of UART is
  component Rx
    generic(wtime : integer);
    port(sysclk : in std_logic;
         RxD : in std_logic;
         DOUT : out std_logic_vector(7 downto 0);
         BUSY : out std_logic);
  end component;

  component Tx
    generic(wtime : integer);
    port(sysclk : in std_logic;
         TxD : out std_logic;
         DIN : in std_logic_vector(7 downto 0);
         GO : in std_logic;
         BUSY : out std_logic);
  end component;

begin
  rx0 : Rx
    generic map(wtime => 578)
    port map(sysclk => clk, RxD => RxD, DOUT => DOUT, BUSY => Rx_BUSY);

  tx0 : Tx
    generic map(wtime => 578)
    port map(sysclk => clk, TxD => TxD, DIN => DIN, GO => Tx_GO, BUSY => Tx_BUSY);

end RTL;
