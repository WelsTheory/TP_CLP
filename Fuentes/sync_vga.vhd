library IEEE;
use IEEE.std_logic_1164.all;

entity sync_vga is
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

architecture sync_vga_arq of sync_vga is
	-- Parte declarativa:
    constant period_pixelh : natural := h_video + h_back_porch + h_front_porch + h_sync_p;
    constant period_pixelv : natural := v_video + v_back_porch + v_front_porch + v_sync_p;

begin
	-- Parte descriptiva:
	vga_sync: process(clk_i, rst_i)

	variable h_counter	: natural range 0 to period_pixelh := 0;
	variable v_counter	: natural range 0 to period_pixelv := 0;

	begin
		if rst_i = '0'	then
			h_counter 		:= 0;
			v_counter 		:= 0;
			h_sync			<= '1';
			v_sync			<= '1';
			visible	        <= '0';
			pxlh_num		<= 0;
			pxlv_num		<= 0;

		elsif rising_edge(clk_i) then
            -- avanzar horizontal y vertical
			if (h_counter = period_pixelh - 1) then
				h_counter := 0;
				if (v_counter = period_pixelv -1) then -- Vertical are lines, not pixels.
					v_counter := 0;
				else
					v_counter := v_counter + 1;
				end if;
			else
				h_counter := h_counter + 1;
			end if;
            
            -- h_sync debe ser 0 sólo en sincro horizontal
            -- v_sync debe ser 0 sólo en sincro vertical
			if(	h_counter < (h_video + h_front_porch) or h_counter >= (h_video + h_front_porch + h_sync_p)) then
				h_sync	<= '1';
			else
				h_sync	<= '0';
			end if;

			if(	v_counter < (v_video + v_front_porch) or v_counter >= (v_video + v_front_porch + v_sync_p)) then
				v_sync	<= '1';
			else
				v_sync	<= '0';
			end if;

			-- Calcular la posición del pixel
			if(h_counter < h_video) then
				pxlh_num <= h_counter;
			end if;
			if(v_counter < v_video) then
				pxlv_num <= v_counter;
			end if;

			-- Zona visible activa
			if((h_counter < h_video) and (v_counter < v_video)) then
				visible <= '1';
			else
				visible <= '0';
			end if;			
			
		end if;
	end process vga_sync;
end;