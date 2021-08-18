library IEEE;
use IEEE.std_logic_1164.all;

entity vga_top_ping is
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
end;

architecture vga_top_ping_arq of vga_top_ping is
-- declaración

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

	component ping_pong is
        generic(
			color_bits      : natural := 3;
			pixelh_total    : natural := 800;
			pixelv_total    : natural := 525;
			h_video         : natural := 640;
			v_video         : natural := 480
		);
		port(
			pixelh_i      : in natural range 0 to pixelh_total;
			pixelv_i      : in natural range 0 to pixelv_total;
			visible_i     : in std_logic;
			rbg_red       : out std_logic_vector(color_bits-1 downto 0) := (others => '0');
			rbg_green     : out std_logic_vector(color_bits-1 downto 0) := (others => '0');
			rbg_blue      : out std_logic_vector(color_bits-1 downto 0) := (others => '0')  
		);
    end component;
	
	signal rbg_reg, rgb_next: std_logic_vector(2 downto 0); 

	signal visible_enable : std_logic;
	signal pixelh_enable  : natural range 0 to pixelh_total;
	signal pixelv_enable  : natural range 0 to pixelv_total;

begin
	vga_inst: vga
		port map(
			clk_i    => clk_i,
			rst_i    => rst_i,
			h_sync   => h_sync,
			v_sync   => v_sync,
			visible  => visible_enable,
			pxlh_num => pixelh_enable,
			pxlv_num => pixelv_enable
		);
    ping_pong_inst : ping_pong
		port map(
			pixelh_i			=>	pixelh_enable,
			pixelv_i			=>	pixelv_enable,
			visible_i	        =>	visible_enable,
            rbg_red				=>	rbg_red,   
			rbg_green			=>	rbg_green, 
			rbg_blue 			=>	rbg_blue
		);

end;
