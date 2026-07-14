// =============================================================================
// Module: tb_systolic_array
// Mo ta : Testbench mo phong mang Systolic Array N x N.
//         - Khoi tao 2 ma tran A, B mau
//         - Tu tinh ket qua ky vong C_expected = A x B (bang vong lap thuong)
//         - Dua du lieu A, B vao mang theo kieu "skewed" (lech pha)
//         - Sau khi du lieu chay qua het pipeline, so sanh c_out voi ky vong
// =============================================================================

`timescale 1ns/1ps

module tb_systolic_array;

    parameter N          = 4;
    parameter DATA_WIDTH = 8;
    parameter ACC_WIDTH  = 32;
    parameter CLK_PERIOD = 10;

    reg clk;
    reg rst_n;
    reg clear_acc;

    reg  signed [DATA_WIDTH-1:0] a_in [0:N-1];
    reg  signed [DATA_WIDTH-1:0] b_in [0:N-1];
    wire signed [ACC_WIDTH-1:0]  c_out [0:N-1][0:N-1];

    integer A [0:N-1][0:N-1];
    integer B [0:N-1][0:N-1];
    integer C_expected [0:N-1][0:N-1];

    integer i, j, k, cyc;
    integer errors;

    // ----------------------------------------------------------------------
    // DUT
    // ----------------------------------------------------------------------
    systolic_array #(
        .N          (N),
        .DATA_WIDTH (DATA_WIDTH),
        .ACC_WIDTH  (ACC_WIDTH)
    ) dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .clear_acc  (clear_acc),
        .a_in       (a_in),
        .b_in       (b_in),
        .c_out      (c_out)
    );

    // ----------------------------------------------------------------------
    // Clock
    // ----------------------------------------------------------------------
    initial clk = 1'b0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // ----------------------------------------------------------------------
    // Kich ban mo phong
    // ----------------------------------------------------------------------
    initial begin
        // dump song de xem bang GTKWave (neu can)
        $dumpfile("tb_systolic_array.vcd");
        $dumpvars(0, tb_systolic_array);

        rst_n     = 1'b0;
        clear_acc = 1'b1;
        errors    = 0;
        for (i = 0; i < N; i = i + 1) begin
            a_in[i] = 0;
            b_in[i] = 0;
        end

        // -------- Khoi tao ma tran mau --------
        // A[i][j] = i*N + j + 1        -> gia tri 1..16 (voi N=4)
        // B[i][j] = 2 neu i == j, con lai = 0   -> ma tran duong cheo (x2)
        // => C = A * B = 2 * A  (de kiem tra bang mat)
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                A[i][j] = i * N + j + 1;
                B[i][j] = (i == j) ? 2 : 0;
            end
        end

        // -------- Tinh ket qua ky vong bang vong lap thuong --------
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                C_expected[i][j] = 0;
                for (k = 0; k < N; k = k + 1)
                    C_expected[i][j] = C_expected[i][j] + A[i][k] * B[k][j];
            end
        end

        // -------- Reset --------
        repeat (2) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);
        clear_acc = 1'b1; // chu ky dau tien: nap gia tri MAC dau tien (khong cong don)

        // -------- Dua du lieu vao theo kieu skewed --------
        // Tai chu ky 'cyc', PE(i,*) nhan A[i][cyc-i] neu 0 <= cyc-i < N, nguoc lai = 0
        //                    PE(*,j) nhan B[cyc-j][j] neu 0 <= cyc-j < N, nguoc lai = 0
        for (cyc = 0; cyc < 2*N; cyc = cyc + 1) begin
            for (i = 0; i < N; i = i + 1) begin
                if ((cyc - i) >= 0 && (cyc - i) < N)
                    a_in[i] = A[i][cyc-i];
                else
                    a_in[i] = 0;
            end
            for (j = 0; j < N; j = j + 1) begin
                if ((cyc - j) >= 0 && (cyc - j) < N)
                    b_in[j] = B[cyc-j][j];
                else
                    b_in[j] = 0;
            end
            @(posedge clk);
            clear_acc = 1'b0; // tu chu ky thu 2 tro di: cong don vao thanh ghi tich luy
        end

        // -------- Bom them chu ky "0" de du lieu chay het qua pipeline --------
        for (i = 0; i < N; i = i + 1) begin
            a_in[i] = 0;
            b_in[i] = 0;
        end
        repeat (2*N + 2) @(posedge clk);

        // -------- So sanh ket qua --------
        #1;
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                if (c_out[i][j] !== C_expected[i][j]) begin
                    $display("[FAIL] C[%0d][%0d] = %0d (ky vong %0d)",
                              i, j, c_out[i][j], C_expected[i][j]);
                    errors = errors + 1;
                end else begin
                    $display("[ OK ] C[%0d][%0d] = %0d", i, j, c_out[i][j]);
                end
            end
        end

        if (errors == 0)
            $display("\n>>> KET QUA: TAT CA %0d PHAN TU DEU DUNG <<<\n", N*N);
        else
            $display("\n>>> KET QUA: CO %0d LOI <<<\n", errors);

        $finish;
    end

endmodule
