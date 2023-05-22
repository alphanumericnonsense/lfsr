library ieee;
use ieee.std_logic_1164.all;

entity lfsr is
    -- some five-term primitive polynomials:
    -- 1,11,35,77,128 -> 0x20000000000800000801 (x^128 mod minpoly)
    -- 1,121,178,241,256 -> 0x2000000000000000400000000000002000000000000000000000000000001
    -- 1,125,321,419,512 -> 0x800000000000000000000000200000000000000000000000000000000000000000000000020000000000000000000000000000001
    generic(
        width_g : positive := 256;
        seed_g : std_logic_vector(width_g - 1 downto 0) := 256x"1";
        poly_g : std_logic_vector(width_g -1 downto 0) :=  256x"2000000000000000400000000000002000000000000000000000000000001";
        steps_g : positive := 1
    );
    port(
        clk, rst : in std_logic := '0';
        prnd : out std_logic_vector(width_g - 1 downto 0) := (others => '0')
    );
end entity lfsr;

architecture fibonacci of lfsr is

begin
    fib_main : process(clk) is
        variable state : std_logic_vector(width_g - 1 downto 0) := seed_g;
        variable new_bit : std_logic := '0';
    begin
        if rising_edge(clk) then
            if rst then
                state := seed_g;
            else
                for i in 1 to steps_g loop
                    new_bit := xor (poly_g and state);
                    state := state(width_g - 2 downto 0) & new_bit;
                end loop;
            end if;
            prnd <= state;
        end if;
    end process fib_main;
end architecture fibonacci;

library ieee;
use ieee.std_logic_1164.all;

entity lfsr_tb is
    generic(
        width_g : positive := 256;
        seed_g : std_logic_vector(width_g - 1 downto 0) := 256x"1";
        poly_g : std_logic_vector(width_g -1 downto 0) :=  256x"2000000000000000400000000000002000000000000000000000000000001";
        steps_g : positive := 1;
        iters : positive := 512
    );
end entity lfsr_tb;

architecture test of lfsr_tb is
    signal prnd_s : std_logic_vector(width_g - 1 downto 0);
    signal clk_s, rst_s : std_logic := '0';
begin
    CLOCK : process(clk_s) is

    begin
        clk_s <= not clk_s after 1 ns;
    end process CLOCK;

    CONTROL : process(clk_s) is
        variable count : natural := 0;
    begin
        if rising_edge(clk_s) then
            if count < iters then
                report to_string(prnd_s);
                count := count + 1;
            else
                std.env.stop;
            end if;
        end if;
    end process CONTROL;

    DUT : entity work.lfsr
        generic map(
            width_g => width_g,
            seed_g => seed_g,
            poly_g => poly_g,
            steps_g => steps_g
        )
        port map(
            clk => clk_s,
            rst => rst_s,
            prnd => prnd_s
        );
end architecture test;
