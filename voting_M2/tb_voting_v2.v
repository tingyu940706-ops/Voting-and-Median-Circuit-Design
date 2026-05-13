//voting testbench v2

`timescale 1ns/1ps
`include "voting_v2.v"

module tb;

    // DUT I/O

    reg  [4:0] a0, a1, a2, a3, a4;
    wire [4:0] out;
    wire [2:0] count;

    voting DUT (.a0(a0),.a1(a1),.a2(a2),.a3(a3),.a4(a4),.out(out),.count(count));

    // legal one-hot candidates
 
    reg [4:0] cand [0:4];

    // expected values
	
    reg [4:0] exp_out; //expected winner 
    reg [2:0] exp_count; //expected votes

    // counters / loop vars
	
    integer i0, i1, i2, i3, i4;
    integer total_case, pass_case, fail_case;

    integer cnt0, cnt1, cnt2, cnt3, cnt4;
    integer best_idx, best_cnt;

    initial begin
	
        // waveform dump
		
        $dumpfile("voting_v2.vcd");
        $dumpvars(0, tb);
		
        // legal one-hot set ,cand stand for candidate
   
        cand[0] = 5'b00001;
        cand[1] = 5'b00010;
        cand[2] = 5'b00100;
        cand[3] = 5'b01000;
        cand[4] = 5'b10000;

        // initialize
  
        a0 = 5'b00000;
        a1 = 5'b00000;
        a2 = 5'b00000;
        a3 = 5'b00000;
        a4 = 5'b00000;

        exp_out   = 5'b00000;
        exp_count = 3'b000;

        total_case = 0;
        pass_case  = 0;
        fail_case  = 0;

        #5;

        // =====================================================
        // Corner Case 1 : all same
        // =====================================================
        a0 = 5'b00001; a1 = 5'b00001; a2 = 5'b00001; a3 = 5'b00001; a4 = 5'b00001;

        cnt0 = 5; cnt1 = 0; cnt2 = 0; cnt3 = 0; cnt4 = 0;
        best_idx = 0; best_cnt = cnt0;  // This section ensures the simulation starts from a clean initial state.
        if (cnt1 >= best_cnt) begin best_cnt = cnt1; best_idx = 1; end
        if (cnt2 >= best_cnt) begin best_cnt = cnt2; best_idx = 2; end
        if (cnt3 >= best_cnt) begin best_cnt = cnt3; best_idx = 3; end
        if (cnt4 >= best_cnt) begin best_cnt = cnt4; best_idx = 4; end

        case (best_idx)
            0: exp_out = 5'b00001;
            1: exp_out = 5'b00010;
            2: exp_out = 5'b00100;
            3: exp_out = 5'b01000;
            4: exp_out = 5'b10000;
        endcase
        exp_count = best_cnt[2:0];

        #5;
        total_case = total_case + 1;
        if ((out !== exp_out) || (count !== exp_count)) begin
            fail_case = fail_case + 1;
            $display("[FAIL] case=%0d", total_case);
            $display("a0=%b a1=%b a2=%b a3=%b a4=%b", a0, a1, a2, a3, a4);
            $display("DUT out=%b count=%b | EXP out=%b count=%b", out, count, exp_out, exp_count);
        end
        else
            pass_case = pass_case + 1;

        // =====================================================
        // Corner Case 2 : all different
        // =====================================================
        a0 = 5'b00001; a1 = 5'b00010; a2 = 5'b00100; a3 = 5'b01000; a4 = 5'b10000;

        cnt0 = 1; cnt1 = 1; cnt2 = 1; cnt3 = 1; cnt4 = 1;
        best_idx = 0; best_cnt = cnt0;
        if (cnt1 >= best_cnt) begin best_cnt = cnt1; best_idx = 1; end
        if (cnt2 >= best_cnt) begin best_cnt = cnt2; best_idx = 2; end
        if (cnt3 >= best_cnt) begin best_cnt = cnt3; best_idx = 3; end
        if (cnt4 >= best_cnt) begin best_cnt = cnt4; best_idx = 4; end

        case (best_idx)
            0: exp_out = 5'b00001;
            1: exp_out = 5'b00010;
            2: exp_out = 5'b00100;
            3: exp_out = 5'b01000;
            4: exp_out = 5'b10000;
        endcase
        exp_count = best_cnt[2:0];

        #5;
        total_case = total_case + 1;
        if ((out !== exp_out) || (count !== exp_count)) begin
            fail_case = fail_case + 1;
            $display("[FAIL] case=%0d", total_case);
            $display("a0=%b a1=%b a2=%b a3=%b a4=%b", a0, a1, a2, a3, a4);
            $display("DUT out=%b count=%b | EXP out=%b count=%b", out, count, exp_out, exp_count);
        end
        else
            pass_case = pass_case + 1;

        // =====================================================
        // Corner Case 3 : 3-1-1
        // =====================================================
        a0 = 5'b00100; a1 = 5'b00100; a2 = 5'b00100; a3 = 5'b00001; a4 = 5'b10000;

        cnt0 = 1; cnt1 = 0; cnt2 = 3; cnt3 = 0; cnt4 = 1;
        best_idx = 0; best_cnt = cnt0;
        if (cnt1 >= best_cnt) begin best_cnt = cnt1; best_idx = 1; end
        if (cnt2 >= best_cnt) begin best_cnt = cnt2; best_idx = 2; end
        if (cnt3 >= best_cnt) begin best_cnt = cnt3; best_idx = 3; end
        if (cnt4 >= best_cnt) begin best_cnt = cnt4; best_idx = 4; end

        case (best_idx)
            0: exp_out = 5'b00001;
            1: exp_out = 5'b00010;
            2: exp_out = 5'b00100;
            3: exp_out = 5'b01000;
            4: exp_out = 5'b10000;
        endcase
        exp_count = best_cnt[2:0];

        #5;
        total_case = total_case + 1;
        if ((out !== exp_out) || (count !== exp_count)) begin
            fail_case = fail_case + 1;
            $display("[FAIL] case=%0d", total_case);
            $display("a0=%b a1=%b a2=%b a3=%b a4=%b", a0, a1, a2, a3, a4);
            $display("DUT out=%b count=%b | EXP out=%b count=%b", out, count, exp_out, exp_count);
        end
        else
            pass_case = pass_case + 1;

        // =====================================================
        // Corner Case 4 : 2-2-1
        // =====================================================
        a0 = 5'b00001; a1 = 5'b00001; a2 = 5'b00100; a3 = 5'b00100; a4 = 5'b01000;

        cnt0 = 2; cnt1 = 0; cnt2 = 2; cnt3 = 1; cnt4 = 0;
        best_idx = 0; best_cnt = cnt0;
        if (cnt1 >= best_cnt) begin best_cnt = cnt1; best_idx = 1; end
        if (cnt2 >= best_cnt) begin best_cnt = cnt2; best_idx = 2; end
        if (cnt3 >= best_cnt) begin best_cnt = cnt3; best_idx = 3; end
        if (cnt4 >= best_cnt) begin best_cnt = cnt4; best_idx = 4; end

        case (best_idx)
            0: exp_out = 5'b00001;
            1: exp_out = 5'b00010;
            2: exp_out = 5'b00100;
            3: exp_out = 5'b01000;
            4: exp_out = 5'b10000;
        endcase
        exp_count = best_cnt[2:0];

        #5;
        total_case = total_case + 1;
        if ((out !== exp_out) || (count !== exp_count)) begin
            fail_case = fail_case + 1;
            $display("[FAIL] case=%0d", total_case);
            $display("a0=%b a1=%b a2=%b a3=%b a4=%b", a0, a1, a2, a3, a4);
            $display("DUT out=%b count=%b | EXP out=%b count=%b", out, count, exp_out, exp_count);
        end
        else
            pass_case = pass_case + 1;

        // =====================================================
        // Exhaustive test : 5^5 = 3125 legal cases
        // =====================================================
        for (i0 = 0; i0 < 5; i0 = i0 + 1) begin
            for (i1 = 0; i1 < 5; i1 = i1 + 1) begin
                for (i2 = 0; i2 < 5; i2 = i2 + 1) begin
                    for (i3 = 0; i3 < 5; i3 = i3 + 1) begin
                        for (i4 = 0; i4 < 5; i4 = i4 + 1) begin

                            a0 = cand[i0];
                            a1 = cand[i1];
                            a2 = cand[i2];
                            a3 = cand[i3];
                            a4 = cand[i4];

                            // count candidate frequency
                            cnt0 = 0; cnt1 = 0; cnt2 = 0; cnt3 = 0; cnt4 = 0;

                            if (a0 == 5'b00001) cnt0 = cnt0 + 1;
                            if (a1 == 5'b00001) cnt0 = cnt0 + 1;
                            if (a2 == 5'b00001) cnt0 = cnt0 + 1;
                            if (a3 == 5'b00001) cnt0 = cnt0 + 1;
                            if (a4 == 5'b00001) cnt0 = cnt0 + 1;

                            if (a0 == 5'b00010) cnt1 = cnt1 + 1;
                            if (a1 == 5'b00010) cnt1 = cnt1 + 1;
                            if (a2 == 5'b00010) cnt1 = cnt1 + 1;
                            if (a3 == 5'b00010) cnt1 = cnt1 + 1;
                            if (a4 == 5'b00010) cnt1 = cnt1 + 1;

                            if (a0 == 5'b00100) cnt2 = cnt2 + 1;
                            if (a1 == 5'b00100) cnt2 = cnt2 + 1;
                            if (a2 == 5'b00100) cnt2 = cnt2 + 1;
                            if (a3 == 5'b00100) cnt2 = cnt2 + 1;
                            if (a4 == 5'b00100) cnt2 = cnt2 + 1;

                            if (a0 == 5'b01000) cnt3 = cnt3 + 1;
                            if (a1 == 5'b01000) cnt3 = cnt3 + 1;
                            if (a2 == 5'b01000) cnt3 = cnt3 + 1;
                            if (a3 == 5'b01000) cnt3 = cnt3 + 1;
                            if (a4 == 5'b01000) cnt3 = cnt3 + 1;

                            if (a0 == 5'b10000) cnt4 = cnt4 + 1;
                            if (a1 == 5'b10000) cnt4 = cnt4 + 1;
                            if (a2 == 5'b10000) cnt4 = cnt4 + 1;
                            if (a3 == 5'b10000) cnt4 = cnt4 + 1;
                            if (a4 == 5'b10000) cnt4 = cnt4 + 1;

                            // find winner
                            best_idx = 0;
                            best_cnt = cnt0;

                            if (cnt1 >= best_cnt) begin best_cnt = cnt1; best_idx = 1; end
                            if (cnt2 >= best_cnt) begin best_cnt = cnt2; best_idx = 2; end
                            if (cnt3 >= best_cnt) begin best_cnt = cnt3; best_idx = 3; end
                            if (cnt4 >= best_cnt) begin best_cnt = cnt4; best_idx = 4; end

                            case (best_idx)
                                0: exp_out = 5'b00001;
                                1: exp_out = 5'b00010;
                                2: exp_out = 5'b00100;
                                3: exp_out = 5'b01000;
                                4: exp_out = 5'b10000;
                            endcase

                            exp_count = best_cnt[2:0];

                            #5;

                            total_case = total_case + 1;

                            if ((out !== exp_out) || (count !== exp_count)) begin
                                fail_case = fail_case + 1;
                                $display("[FAIL] case=%0d", total_case);
                                $display("a0=%b a1=%b a2=%b a3=%b a4=%b", a0, a1, a2, a3, a4);
                                $display("DUT out=%b count=%b | EXP out=%b count=%b", out, count, exp_out, exp_count);
                            end
                            else begin
                                pass_case = pass_case + 1;
                            end

                        end
                    end
                end
            end
        end

        // -----------------------------------------------------
        // summary
        // -----------------------------------------------------
    $display("==============================================");
    $display("Total cases : %0d", total_case);
    $display("Pass cases  : %0d", pass_case);
    $display("Fail cases  : %0d", fail_case);
    $display("==============================================");

    if (fail_case == 0) begin
        $display("==============================================================");
        $display("                 🎉  Simulation Finish ! 🎉");
        $display("==============================================================");
        $display("*******************************************************");
        $display("**                                                   **");
        $display("**                Congratulations !!                 **");
        $display("**                 All test passed!!                   **");
        $display("**                                                   **");
        $display("**************************************************************");
        $display("");
        $display("⠀⠀⠀⠀⠀⠀⠀⠀       ⠀⠀⠀⠀⢀⣤⣤⣄⠀⣀⣀⣀⠀⠀⠀⠀");
        $display("⠀⠀⠀       ⣴⠟⠛⠓⠶⣤⠴⠶⢶⡿⠁⣶⣽⣯⠉⠁⠹⡆⠀⠀⠀");
        $display("⠀⠀       ⠀⣿⠀⠀⠀⠀⠀⠀⠀⢸⡁⢼⣿⡏⠙⠻⣾⡛⢿⣆⠀⠀");
        $display("⠀⠀       ⠀⣻⠋⠀⠀⠀⠀⠀⠀⠈⠓⠶⠞⠷⣤⣼⣯⠟⣸⡟⠀⠀");
        $display("⠀       ⠀⢸⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠶⠞⢙⣆⣀⠀");
        $display("       ⢠⡶⢾⡶⠤⠀⢠⣤⠀⠀⠀⠀⠀⠀⠀⠀⣤⡄⠀⠚⢩⡏⠉⠁");
        $display("⠀       ⢀⣼⣷⠒⠀⠈⠋⠀⠀⠀⢶⡲⠀⠀⠀⠛⠁⠀⡈⣹⠛⠛⠀");
        $display("⠀       ⠀⢠⡼⠷⣯⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠿⠛⠷⠆⠀");
        $display("       ⠀⠀⠈⠀⠀⠀⠉⠙⠓⠒⠶⠶⠶⠶⠒⠚⠛⠉⠁⠀⠀⠀⠀⠀");
        $display("");
        $display("==============================================================");
    end
    else begin
        $display("-----------------------------------------------------");
        $display("     [!] Some tests failed.                         ");
        $display("     Keep going! Please check your logic carefully. ");
        $display("     You've got this, don't give up!                ");
        $display("-----------------------------------------------------");
    end

    $finish;
		
		
		
end		
		
//========================================================================

endmodule