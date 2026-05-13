//median testbench
`timescale 1ns/1ps
`include "median.v"

module tb;
 
reg    [5:0] a0, a1, a2, a3, a4;
wire   [5:0] out;

    median DUT (.a0(a0),.a1(a1),.a2(a2),.a3(a3),.a4(a4),.out(out));

    // legal one-hot candidates

    reg [5:0] cand [0:5];

    // expected result
 
    reg [5:0] exp_out;

    // loop vars / counters
  
    integer i0, i1, i2, i3, i4;
    integer total_case, pass_case, fail_case;

    // golden model variables
	
    integer x0, x1, x2, x3, x4;
    integer t0, t1, t2, t3, t4;
    integer tmp;

    initial begin
    
        // waveform dump
     
        $dumpfile("median.vcd");
        $dumpvars(0, tb);

        // legal one-hot set
 
        cand[0] = 6'b000001;
        cand[1] = 6'b000010;
        cand[2] = 6'b000100;
        cand[3] = 6'b001000;
        cand[4] = 6'b010000;
        cand[5] = 6'b100000;

        // initialize
		
        a0 = 6'b000001;
        a1 = 6'b000001;
        a2 = 6'b000001;
        a3 = 6'b000001;
        a4 = 6'b000001;

        exp_out    = 6'b000000;
        total_case = 0;
        pass_case  = 0;
        fail_case  = 0;

        #5;
        // =====================================================
        // Corner Case 1 : already sorted
        // Expect median = 000100 (index 2)
        // =====================================================
        a0 = 6'b000001; a1 = 6'b000010; a2 = 6'b000100; a3 = 6'b001000; a4 = 6'b010000;
        exp_out = 6'b000100;
        #5;
        total_case = total_case + 1;
        if (out !== exp_out) begin
            fail_case = fail_case + 1;
            $display("[FAIL][CC1] already sorted");
            $display("a0=%b a1=%b a2=%b a3=%b a4=%b", a0, a1, a2, a3, a4);
            $display("DUT out=%b | EXP out=%b", out, exp_out);
        end
        else begin
            pass_case = pass_case + 1;
        end

        // =====================================================
        // Corner Case 2 : reverse sorted
        // Expect median = 001000 (index 3)
        // =====================================================
        a0 = 6'b100000; a1 = 6'b010000; a2 = 6'b001000; a3 = 6'b000100; a4 = 6'b000010;
        exp_out = 6'b001000;
        #5;
        total_case = total_case + 1;
        if (out !== exp_out) begin
            fail_case = fail_case + 1;
            $display("[FAIL][CC2] reverse sorted");
            $display("a0=%b a1=%b a2=%b a3=%b a4=%b", a0, a1, a2, a3, a4);
            $display("DUT out=%b | EXP out=%b", out, exp_out);
        end
        else begin
            pass_case = pass_case + 1;
        end

        // =====================================================
        // Corner Case 3 : clustered values
        // Expect median = 000100 (index 2)
        // =====================================================
        a0 = 6'b000001; a1 = 6'b000100; a2 = 6'b000100; a3 = 6'b000100; a4 = 6'b100000;
        exp_out = 6'b000100;
        #5;
        total_case = total_case + 1;
        if (out !== exp_out) begin
            fail_case = fail_case + 1;
            $display("[FAIL][CC3] clustered values");
            $display("a0=%b a1=%b a2=%b a3=%b a4=%b", a0, a1, a2, a3, a4);
            $display("DUT out=%b | EXP out=%b", out, exp_out);
        end
        else begin
            pass_case = pass_case + 1;
        end

        // =====================================================
        // Corner Case 4 : boundary spread
        // Expect median = 001000 (index 3)
        // =====================================================
        a0 = 6'b000001; a1 = 6'b000010; a2 = 6'b001000; a3 = 6'b010000; a4 = 6'b100000;
        exp_out = 6'b001000;
        #5;
        total_case = total_case + 1;
        if (out !== exp_out) begin
            fail_case = fail_case + 1;
            $display("[FAIL][CC4] boundary spread");
            $display("a0=%b a1=%b a2=%b a3=%b a4=%b", a0, a1, a2, a3, a4);
            $display("DUT out=%b | EXP out=%b", out, exp_out);
        end
        else begin
            pass_case = pass_case + 1;
        end

        // Exhaustive test : 6^5 = 7776 legal cases

        for (i0 = 0; i0 < 6; i0 = i0 + 1) begin
            for (i1 = 0; i1 < 6; i1 = i1 + 1) begin
                for (i2 = 0; i2 < 6; i2 = i2 + 1) begin
                    for (i3 = 0; i3 < 6; i3 = i3 + 1) begin
                        for (i4 = 0; i4 < 6; i4 = i4 + 1) begin

                            // ---------------------------------
                            // apply inputs
                            // ---------------------------------
                            a0 = cand[i0];
                            a1 = cand[i1];
                            a2 = cand[i2];
                            a3 = cand[i3];
                            a4 = cand[i4];

                            // ---------------------------------
                            // convert one-hot to integer index
                            // ---------------------------------
                            if      (a0 == 6'b000001) x0 = 0;
                            else if (a0 == 6'b000010) x0 = 1;
                            else if (a0 == 6'b000100) x0 = 2;
                            else if (a0 == 6'b001000) x0 = 3;
                            else if (a0 == 6'b010000) x0 = 4;
                            else if (a0 == 6'b100000) x0 = 5;

                            if      (a1 == 6'b000001) x1 = 0;
                            else if (a1 == 6'b000010) x1 = 1;
                            else if (a1 == 6'b000100) x1 = 2;
                            else if (a1 == 6'b001000) x1 = 3;
                            else if (a1 == 6'b010000) x1 = 4;
                            else if (a1 == 6'b100000) x1 = 5;

                            if      (a2 == 6'b000001) x2 = 0;
                            else if (a2 == 6'b000010) x2 = 1;
                            else if (a2 == 6'b000100) x2 = 2;
                            else if (a2 == 6'b001000) x2 = 3;
                            else if (a2 == 6'b010000) x2 = 4;
                            else if (a2 == 6'b100000) x2 = 5;

                            if      (a3 == 6'b000001) x3 = 0;
                            else if (a3 == 6'b000010) x3 = 1;
                            else if (a3 == 6'b000100) x3 = 2;
                            else if (a3 == 6'b001000) x3 = 3;
                            else if (a3 == 6'b010000) x3 = 4;
                            else if (a3 == 6'b100000) x3 = 5;

                            if      (a4 == 6'b000001) x4 = 0;
                            else if (a4 == 6'b000010) x4 = 1;
                            else if (a4 == 6'b000100) x4 = 2;
                            else if (a4 == 6'b001000) x4 = 3;
                            else if (a4 == 6'b010000) x4 = 4;
                            else if (a4 == 6'b100000) x4 = 5;

                            // ---------------------------------
                            // copy to temp values for sorting
                            // ---------------------------------
                            t0 = x0;
                            t1 = x1;
                            t2 = x2;
                            t3 = x3;
                            t4 = x4;

                            // ---------------------------------
                            // sort 5 integers (simple bubble style)
                            // ---------------------------------
                            if (t0 > t1) begin tmp = t0; t0 = t1; t1 = tmp; end
                            if (t1 > t2) begin tmp = t1; t1 = t2; t2 = tmp; end
                            if (t2 > t3) begin tmp = t2; t2 = t3; t3 = tmp; end
                            if (t3 > t4) begin tmp = t3; t3 = t4; t4 = tmp; end

                            if (t0 > t1) begin tmp = t0; t0 = t1; t1 = tmp; end
                            if (t1 > t2) begin tmp = t1; t1 = t2; t2 = tmp; end
                            if (t2 > t3) begin tmp = t2; t2 = t3; t3 = tmp; end

                            if (t0 > t1) begin tmp = t0; t0 = t1; t1 = tmp; end
                            if (t1 > t2) begin tmp = t1; t1 = t2; t2 = tmp; end

                            if (t0 > t1) begin tmp = t0; t0 = t1; t1 = tmp; end

                            // ---------------------------------
                            // median is the middle one: t2
                            // ---------------------------------
                            case (t2)
                                0: exp_out = 6'b000001;
                                1: exp_out = 6'b000010;
                                2: exp_out = 6'b000100;
                                3: exp_out = 6'b001000;
                                4: exp_out = 6'b010000;
                                5: exp_out = 6'b100000;
                                default: exp_out = 6'bxxxxxx;
                            endcase

                            // wait DUT settle
   
                            #5;

                            // compare
       
                            total_case = total_case + 1;

                            if (out !== exp_out) begin
                                fail_case = fail_case + 1;
                                $display("[FAIL] case=%0d", total_case);
                                $display("a0=%b a1=%b a2=%b a3=%b a4=%b", a0, a1, a2, a3, a4);
                                $display("idx: x0=%0d x1=%0d x2=%0d x3=%0d x4=%0d", x0, x1, x2, x3, x4);
                                $display("sorted: %0d %0d %0d %0d %0d", t0, t1, t2, t3, t4);
                                $display("DUT out=%b | EXP out=%b", out, exp_out);
                            end
                            else begin
                                pass_case = pass_case + 1;
                            end

                        end
                    end
                end
            end
        end


        // summary
        // -----------------------------------------------------
		
		$display("========================================");
			$display("Median Testbench Summary");
			$display("Total cases : %0d", total_case);
			$display("Pass cases  : %0d", pass_case);
			$display("Fail cases  : %0d", fail_case);
			$display("========================================");

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
 
 //==============================================================

endmodule
