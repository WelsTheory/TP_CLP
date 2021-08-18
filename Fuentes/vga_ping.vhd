library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ping_pong is
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
end;

architecture ping_pong_arq of ping_pong is

-- declaración

	signal pixel_x          : natural range 0 to pixelh_total;
	signal pixel_y          : natural range 0 to pixelv_total; 
    constant MAX_X          : natural := 640;
    constant MAX_Y          : natural := 480;

    constant WALL_X_L       : natural := 32;
    constant WALL_X_R       : natural := 35;

    constant BAR_X_L        : natural := 600;
    constant BAR_X_R        : natural := 603;
    
    constant BAR_Y_SIZE     : natural := 72;
    constant BAR_Y_T        : natural := MAX_Y/2-BAR_Y_SIZE/2;
    constant BAR_Y_B        : natural := BAR_Y_T+BAR_Y_SIZE-1;

    constant BALL_SIZE      : natural := 8;

    constant BALL_X_L       : natural := 580;
    constant BALL_X_R       : natural := BALL_X_L + BALL_SIZE -1;

    constant BALL_Y_T       : natural := 238;
    constant BALL_Y_B       : natural := BALL_Y_T+BALL_SIZE-1; 

    signal wall_on,bar_on,sq_ball_on: std_logic;

begin
	pixel_x <= pixelh_i;
    pixel_y <= pixelv_i;

    wall_on     <= '1' when (WALL_X_L <= pixel_x) and (pixel_x <= WALL_X_R) else
                   '0';

    bar_on      <= '1' when (BAR_X_L <= pixel_x) and (pixel_x <= BAR_X_R) and 
                       (BAR_Y_T <= pixel_y) and (pixel_y <= BAR_Y_B) else 
                   '0';

    sq_ball_on  <= '1' when (BALL_X_L <= pixel_x) and (pixel_x <= BALL_X_R) and
                           (BALL_Y_T <= pixel_y) and (pixel_y <= BALL_Y_B) else
                   '0';

    process(visible_i,wall_on,bar_on,sq_ball_on)
    begin
        if visible_i = '0' then
            rbg_red 	<= (others => '0');
			rbg_green	<= (others => '0');
			rbg_blue	<= (others => '0');
        else
            if wall_on = '1' then 
                rbg_red 	<= (others => '0');
                rbg_green	<= (others => '0');
                rbg_blue	<= (others => '1');
            elsif bar_on = '1' then
                rbg_red 	<= (others => '0');
                rbg_green	<= (others => '1');
                rbg_blue	<= (others => '0');
            elsif sq_ball_on = '1' then
                rbg_red 	<= (others => '1');
                rbg_green	<= (others => '0');
                rbg_blue	<= (others => '1');
            else
                rbg_red 	<= (others => '1');
                rbg_green	<= (others => '1');
                rbg_blue	<= (others => '1');
            end if;
        end if;
    end process;
end;
