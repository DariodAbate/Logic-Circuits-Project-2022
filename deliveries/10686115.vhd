library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    Port ( 
           i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_start : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_address : out STD_LOGIC_VECTOR (15 downto 0);
           o_done : out STD_LOGIC;
           o_en : out STD_LOGIC;
           o_we : out STD_LOGIC;
           o_data : out STD_LOGIC_VECTOR (7 downto 0)
           );
end project_reti_logiche;


architecture Behavioral of project_reti_logiche is
component datapath is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_data : out STD_LOGIC_VECTOR (7 downto 0);
           o_address : out STD_LOGIC_VECTOR (15 downto 0);
           r0_load : in STD_LOGIC;
           r1_load : in STD_LOGIC;
           r3_load : in STD_LOGIC;
           r4_load : in STD_LOGIC;
           r5_load : in STD_LOGIC;
           r0_sel : in STD_LOGIC;
           r3_sel : in STD_LOGIC;
           r4_sel : in STD_LOGIC;
           r5_sel : in STD_LOGIC;
           read_mux :in STD_LOGIC;
           o_end : out STD_LOGIC;
           rst_count : in STD_LOGIC;
           rst_conv : in STD_LOGIC);
        
end component;

signal r0_load :  STD_LOGIC;
signal r1_load :  STD_LOGIC;
signal r3_load :  STD_LOGIC;
signal r4_load :  STD_LOGIC;
signal r5_load :  STD_LOGIC;
signal r0_sel :  STD_LOGIC;
signal r3_sel :  STD_LOGIC;
signal r4_sel : STD_LOGIC;
signal r5_sel :  STD_LOGIC;
signal read_mux : STD_LOGIC;
signal o_end :  STD_LOGIC;
signal rst_conv :  STD_LOGIC;
signal rst_count : STD_LOGIC;

 type S is(init, readW, getW, readWord, getWord, bit2_1, bit4_1, bit6_1,bit8_1, write1,
           bit4_2, bit6_2, bit6_2Next, bit8_2, bit8_2Next, write2, done, preReset);
signal cur_state, next_state : S;
    

begin
    DATAPATH0: datapath port map(
           i_clk ,
           i_rst ,
           i_data ,
           o_data ,
           o_address ,
           r0_load ,
           r1_load ,
           r3_load ,
           r4_load ,
           r5_load ,
           r0_sel ,
           r3_sel ,
           r4_sel ,
           r5_sel ,
           read_mux ,
           o_end ,
           rst_conv,
           rst_count        
    );
 
 
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= init;
        elsif i_clk'event and i_clk = '1' then
            cur_state <= next_state;
        end if;
    end process;
    
    process(cur_state, i_start, o_end)
    begin
        next_state <= cur_state;
        case cur_state is
        
            when init =>
                if i_start = '1' then
                    next_state <= readW;
                    else    
                        next_state <= init;     
                end if;
                
            when readW =>
                next_state <= getW;
           
            when getW =>
                    next_state <= readWord;
                
            when readWord =>        
                if o_end = '1' then
                    next_state <= done;
                else
                    next_state <= getWord;
                end if;
                
            when getWord =>
                next_state <= bit2_1;
                  
            when bit2_1 =>
                next_state <= bit4_1;
                
            when bit4_1 =>
                next_state <= bit6_1;
                
            when bit6_1 =>
                next_state <= bit8_1;
                
            when bit8_1 =>
                next_state <= write1;
                
            when write1 =>
                next_state <= bit4_2;
                
            when bit4_2 =>
                if o_end = '1' then
                    next_state <= bit6_2;
                else
                    next_state <= bit6_2Next;
                end if;
                
            when bit6_2 =>
                next_state <= bit8_2;
                
            when bit6_2Next =>
                next_state <= bit8_2Next;
                
            when bit8_2 =>
                next_state <= write2;
                
            when bit8_2Next =>
                next_state <= write2;
                
            when write2 =>
               if o_end = '1' then
                    next_state <= done;
                else
                    next_state <= bit4_1;
                end if;
                
            when done =>
                if i_start = '0' then
                    next_state <= preReset;
                end if;
                
            when preReset=>
                next_state <= init;
                
        end case;
    end process;
    
    process(cur_state)
    begin
        r0_load <= '0';
        r1_load <= '0';
        r3_load <= '0';
        r4_load <= '0';
        r5_load <= '0';
        r0_sel <= '1';
        r3_sel <= '1';
        r4_sel <= '0';
        r5_sel <= '0';
        read_mux <= '1';
        o_en <= '0';
        o_we <= '0';
        o_done <= '0';
        rst_conv <= '0';
        rst_count <= '0';      
        
        case cur_state is    
        
            when init =>
                r5_sel <= '1';
                r5_load <= '1';
                
            when readW =>
                r3_sel <= '0';
                r3_load <= '1';
                o_en <= '1';
                o_we <= '0';
                read_mux <= '1';
                r4_sel <= '1';
                r4_load <= '1';
                
            when getW =>
                r0_sel <= '0';
                r0_load <= '1';
                r5_sel <= '0';
                r5_load <= '1';
                
               
            when readWord =>
               read_mux <= '1';
               o_en <= '1';
               o_we <= '0';     
               
            when getWord =>
                r1_load <= '1';
                rst_conv <= '1';
                rst_count <= '1';
                r5_sel <= '0';
                r5_load <= '1';
                           
            when bit2_1 =>
                r3_sel <= '1';
                r3_load <= '1';
                
            when bit4_1 =>
                r3_load <= '1';
                r0_sel <= '1';
                r0_load <= '1';
                
            when bit6_1 =>
                r3_load <= '1';
            
            when bit8_1 =>
                r3_load <= '1';
                
            when write1 =>
                read_mux <= '0';
                o_en <= '1';
                o_we <= '1';
                r4_sel <= '0';
                r4_load <= '1';
                r3_load <= '1';
                
             when bit4_2 =>
               r3_load <= '1';
              
             when bit6_2 =>
               r3_load <= '1';
             
             when bit6_2Next =>
               r3_load <= '1';
               read_mux <= '1';
               o_en <= '1';
               o_we <= '0';
               
              when bit8_2 =>
               r3_load <= '1';
             
             when bit8_2Next =>
               r3_load <= '1';
               r1_load <= '1';
               r5_sel <= '0';
               r5_load <= '1';
               
            when write2 =>
               read_mux <= '0';
               o_en <= '1';
               o_we <= '1';
               r4_sel <= '0';
               r4_load <= '1';
               r3_load <= '1';
               
            when done =>
                o_done <= '1';
                
            when preReset=>
                o_done <= '0';      
                 
        end case;
    end process;
    
end Behavioral;    

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_data : out STD_LOGIC_VECTOR (7 downto 0);
           o_address : out STD_LOGIC_VECTOR (15 downto 0);
           r0_load : in STD_LOGIC;
           r1_load : in STD_LOGIC;
           r3_load : in STD_LOGIC;
           r4_load : in STD_LOGIC;
           r5_load : in STD_LOGIC;
           r0_sel : in STD_LOGIC;
           r3_sel : in STD_LOGIC;
           r4_sel : in STD_LOGIC;
           r5_sel : in STD_LOGIC;
           read_mux :in STD_LOGIC;
           o_end : out STD_LOGIC;
           rst_count : in STD_LOGIC;
           rst_conv : in STD_LOGIC);
end datapath;

architecture Behavioral of datapath is
signal mux_reg0:  STD_LOGIC_VECTOR (7 downto 0);
signal sub : STD_LOGIC_VECTOR(7 downto 0);
signal o_reg0 : STD_LOGIC_VECTOR (7 downto 0);

signal mux_reg4:  STD_LOGIC_VECTOR (15 downto 0);
signal mux_reg5:  STD_LOGIC_VECTOR (15 downto 0);
signal mux_sumAddr :  STD_LOGIC_VECTOR (15 downto 0);
signal add_address : STD_LOGIC_VECTOR (15 downto 0);
signal o_reg4 : STD_LOGIC_VECTOR (15 downto 0);
signal o_reg5 : STD_LOGIC_VECTOR (15 downto 0);


signal o_reg1 : STD_LOGIC_VECTOR(7 downto 0);
signal o_counter: STD_LOGIC_VECTOR(2 downto 0);
signal o_muxData:  STD_LOGIC;


type state_type is (S0, S1, S2, S3);
signal state, next_state : state_type;


signal o_cc : STD_LOGIC_VECTOR(1 downto 0);
signal sum_deser : STD_LOGIC_VECTOR(7 downto 0);
signal mux_reg3:  STD_LOGIC_VECTOR (7 downto 0);
signal o_reg3 :STD_LOGIC_VECTOR(7 downto 0);
signal o_shift :STD_LOGIC_VECTOR(7 downto 0);

begin
--sezione del datapath per controllare il numero di parole rimaste  
    with r0_sel select
        mux_reg0 <= i_data when '0',
                    sub when '1',
                    "XXXXXXXX" when others;
                    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg0 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r0_load = '1') then
                o_reg0 <= mux_reg0;
            end if;
        end if;
    end process;
    
    o_end <= '1' when (o_reg0 = "00000000") else '0';
      
    sub <= o_reg0 - "00000001";
    
--sezione del datapath per determinare l'indirizzo della RAM da cui leggere e in cui scrivere

    with r4_sel select
        mux_reg4 <= add_address when '0',
                    "0000001111101000" when '1', --indirizzo 1000
                    "XXXXXXXXXXXXXXXX" when others;
                    
    with r5_sel select
        mux_reg5 <= add_address when '0',
                    "0000000000000000" when '1',
                    "XXXXXXXXXXXXXXXX" when others;
                    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg5 <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(r5_load = '1') then
                o_reg5 <= mux_reg5;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg4 <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(r4_load = '1') then
                o_reg4 <= mux_reg4;
            end if;
        end if;
    end process;
       
    with read_mux select
         mux_sumAddr <= o_reg4 when '0',
                       o_reg5 when '1',
                       "XXXXXXXXXXXXXXXX" when others;
                       
    o_address <= mux_sumAddr;
                       
    add_address <= mux_sumAddr + "0000000000000001";
    
--sezione del datapath che gestiste la serializzazione
  with o_counter select
        o_muxData <=   o_reg1(7) when "000",
                       o_reg1(6) when "001",
                       o_reg1(5) when "010",
                       o_reg1(4) when "011",
                       o_reg1(3) when "100",
                       o_reg1(2) when "101",
                       o_reg1(1) when "110",
                       o_reg1(0) when "111",
                       'X' when others;
                       
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg1 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r1_load = '1') then
             o_reg1 <=  i_data;
            end if;
        end if;
    end process;  
    
  counter_mod7: process(i_clk, rst_count)
  begin
    if(rst_count = '1') then
        o_counter <= "000";
    elsif (i_clk'event and i_clk = '1') then
        if(o_counter = "111")then
            o_counter <= "000";
        else
            o_counter <= o_counter + "001";
        end if;
    end if;
  end process;
     
--sezione del datapath con codificatore convoluzionale, è una macchina di mealy
   state_register: process (i_clk, rst_conv)
   begin
     if (rst_conv = '1') then
        state <= S0;
     else
            if (i_clk'event and i_clk = '1') then
                
               state <= next_state;
            end if;
        end if;
end process;
 
   next_state_func: process (o_muxData, state)
   begin
      case state is
         when S0 =>
           if (o_muxData = '1') then
              next_state <= S2;
              o_cc <= "11";
           else
              next_state <= S0;
              o_cc <= "00";
           end if;
        when S1 =>
           if (o_muxData = '1') then
              next_state <= S2;
              o_cc <= "00";
           else
              next_state <= S0;
              o_cc <= "11";
           end if;
        when S2 =>
           if (o_muxData = '1') then
              next_state <= S3;
              o_cc <= "10";
           else
              next_state <= S1;
              o_cc <= "01";
           end if;
        when S3 =>
           if (o_muxData = '1') then
              next_state <= S3;
              o_cc <= "01";
           else
              next_state <= S1;
              o_cc <= "10";
           end if;
      end case;
   end process;

   
--sezione del datapath che gestisce la deserializzazione   
    sum_deser <= ("000000" & o_cc) + o_shift;
       
    with r3_sel select
        mux_reg3 <= "00000000" when '0',
                    sum_deser when '1',
                    "XXXXXXXX" when others;

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg3 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r3_load = '1') then
                o_reg3 <= mux_reg3;
                
            end if;
        end if;
    end process;
    
    o_data <= o_reg3;
    
    o_shift <= o_reg3(5 downto 0) & "00";

end Behavioral;

    