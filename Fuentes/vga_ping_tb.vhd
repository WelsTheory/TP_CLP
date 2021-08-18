library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ping_pong_tb is
end;

architecture ping_pong_tb_arq of ping_pong_tb is

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

    constant color_bits_tb    : natural := 3;
    constant pixelh_total_tb  : natural := 800;
    constant pixelv_total_tb  : natural := 525;
    constant h_video_tb       : natural := 640;
    constant v_video_tb       : natural := 480;

    signal visible_i_tb       : std_logic := '0';

    signal pixelh_i_tb      : natural range 0 to pixelh_total_tb := 0;
    signal pixelv_i_tb      : natural range 0 to pixelh_total_tb := 0;
    signal rbg_red_tb       : std_logic_vector(color_bits_tb-1 downto 0) := (others => '0');
    signal rbg_green_tb     : std_logic_vector(color_bits_tb-1 downto 0) := (others => '0');
    signal rbg_blue_tb      : std_logic_vector(color_bits_tb-1 downto 0) := (others => '0');  

    signal clk_i_tb         : std_logic     := '0'; 

begin
    visible_i_tb    <= '1'  after 1 ns;
    clk_i_tb        <= not clk_i_tb after 1 ns;    

	pxlh_ping: process(clk_i_tb)

    variable pxlh_aux: natural := 1;
    variable pxlv_aux: natural := 1;

    begin
        pixelh_i_tb  <= pixelh_i_tb + 1;
        pxlh_aux     := pxlh_aux + 1;
        if(pxlh_aux = pixelh_total_tb - 1 )then
            pxlh_aux    := 0;
            pixelh_i_tb <= 0;
            pixelv_i_tb <= pixelv_i_tb + 1;
            if(pxlv_aux = pixelv_total_tb - 1)then  
                pxlv_aux    := 0;
                pixelv_i_tb <= 0;
            end if;
        end if;
    end process pxlh_ping;

	ping_pong_inst: ping_pong
    generic map(
        color_bits	        => color_bits_tb,
        pixelh_total		=> pixelh_total_tb,	
        pixelv_total        => pixelv_total_tb,		
        h_video	            => h_video_tb,				
        v_video	            => v_video_tb	
    )
    port map(
        pixelh_i			=> pixelh_i_tb,
        pixelv_i		    => pixelv_i_tb,
        visible_i	        => visible_i_tb,
        rbg_red     		=> rbg_red_tb,
        rbg_green   		=> rbg_green_tb,
        rbg_blue    		=> rbg_blue_tb
    );
end;
