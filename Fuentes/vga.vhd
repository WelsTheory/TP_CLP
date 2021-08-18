library IEEE;
use IEEE.std_logic_1164.all;

entity vga is
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
end;

architecture vga_arq of vga is
-- declaración
	component sync_vga is
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
	
	component clk_vga
        port
         (
          clk_vga           : out    std_logic;
          clk_in1           : in     std_logic
         );
        end component;

	signal clk_vga_p : std_logic;

begin
	vga_inst_clk : clk_vga
           port map ( 
  
           clk_vga => clk_vga_p,
           -- Clock in ports
           clk_in1 => clk_i
         );
    
	vga_sync: sync_vga
		port map(
			clk_i    => clk_vga_p,
			rst_i    => rst_i,
			h_sync   => h_sync,
			v_sync   => v_sync,
			visible  => visible,
			pxlh_num => pxlh_num,
			pxlv_num => pxlv_num
		);

end;
