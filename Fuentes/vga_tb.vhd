library IEEE;
use IEEE.std_logic_1164.all;

entity vga_tb is
end;

architecture vga_tb_arq of vga_tb is
	
	-- Declaracion de componente
	component vga is
		generic(
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
			visible         : out std_logic;
			pxlh_num        : out natural range 0 to pixelh_total;
			pxlv_num        : out natural range 0 to pixelv_total   
		);
	end component;

	constant pixelh_total_tb    : natural := 800;
	constant pixelv_total_tb    : natural := 525;

	signal clk_i_tb           : std_logic     := '1';
	signal rst_i_tb           : std_logic     := '0';
	signal h_sync_tb          : std_logic;      
	signal v_sync_tb          : std_logic;
	signal pxlh_num_tb        : natural range 0 to pixelh_total_tb;
	signal pxlv_num_tb        : natural range 0 to pixelv_total_tb; 


begin
	-- parte descriptiva
	-- descriptiva
	clk_i_tb <= not clk_i_tb after 4 ns;
	rst_i_tb <= '1' after 10 ns;

	DUT: vga
		generic map(
			pixelh_total => pixelh_total_tb,
			pixelv_total => pixelv_total_tb
		)
		port map(
			clk_i    => clk_i_tb,
			rst_i    => rst_i_tb,
			h_sync   => h_sync_tb, 
			v_sync   => v_sync_tb,
			pxlh_num => pxlh_num_tb,
			pxlv_num => pxlv_num_tb
		);
end;

