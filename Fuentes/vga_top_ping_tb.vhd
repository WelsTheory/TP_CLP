library IEEE;
use IEEE.std_logic_1164.all;

entity vga_top_ping_tb is
end;

architecture vga_top_ping_tb_arq of vga_top_ping_tb is
	
	-- Declaracion de componente
	component vga_top_ping is
		generic(
        color_bits      : natural := 3;
        pixelh_total    : natural := 800;
        pixelv_total    : natural := 525;
        h_video         : natural := 640;
        v_video         : natural := 480;
		h_front_porch   : natural := 16;
		h_back_porch    : natural := 48;
		v_front_porch   : natural := 10;
		v_back_porch    : natural := 33;
		h_sync_p        : natural := 96;
		v_sync_p        : natural := 2 	
	);
	port(
		clk_i           : in  std_logic;
		rst_i           : in  std_logic;
		h_sync          : out std_logic;      
		v_sync          : out std_logic;
		rbg_red         : out std_logic_vector(color_bits-1 downto 0) := (others => '0');
        rbg_green       : out std_logic_vector(color_bits-1 downto 0) := (others => '0');
        rbg_blue        : out std_logic_vector(color_bits-1 downto 0) := (others => '0')  
	);
	end component;

constant color_bits_tb    : natural := 3;
constant pixelh_total_tb  : natural := 800;
constant pixelv_total_tb  : natural := 525;
constant h_video_tb       : natural := 640;
constant v_video_tb       : natural := 480;
constant h_front_porch_tb : natural := 16;
constant h_back_porch_tb  : natural := 48;
constant v_front_porch_tb : natural := 10;
constant v_back_porch_tb  : natural := 33;
constant h_sync_p_tb      : natural := 96;
constant v_sync_p_tb      : natural := 2; 	

signal clk_i_tb           : std_logic := '0';
signal rst_i_tb           : std_logic := '0';
signal h_sync_tb          : std_logic := '1';      
signal v_sync_tb          : std_logic := '1';
signal rbg_red_tb         : std_logic_vector(color_bits_tb-1 downto 0) := (others => '0');
signal rbg_green_tb       : std_logic_vector(color_bits_tb-1 downto 0) := (others => '0');
signal rbg_blue_tb        : std_logic_vector(color_bits_tb-1 downto 0) := (others => '0');  

begin
	-- parte descriptiva
	-- descriptiva
    clk_i_tb        <= not clk_i_tb after 4 ns;  
    rst_i_tb        <= '1' after 10 ns;  

	vga_top_ping_inst: vga_top_ping
	   generic map(
			color_bits	        => color_bits_tb
		)
		port map(
			clk_i			    => clk_i_tb,
			rst_i    		    => rst_i_tb,
			h_sync	            => h_sync_tb,
            v_sync              => v_sync_tb,
			rbg_red     		=> rbg_red_tb,
			rbg_green   		=> rbg_green_tb,
			rbg_blue    		=> rbg_blue_tb
		);
end;

