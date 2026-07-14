// =============================================================================
// Module: systolic_array
// Mo ta : Mang Systolic Array kich thuoc N x N, ghep tu cac PE (pe_mac).
//         - a_in[i]  : du lieu hang thu i cua ma tran A, dua vao tu canh trai
//         - b_in[j]  : du lieu cot thu j cua ma tran B, dua vao tu canh tren
//         - c_out[i][j] : ket qua C[i][j] = sum_k A[i][k] * B[k][j]
//
//         Du lieu A phai duoc dua vao theo kieu "skewed" (lech pha dan theo
//         chi so hang) va du lieu B lech pha dan theo chi so cot - viec nay
//         do testbench / bo dieu khien ben ngoai dam nhiem.
// =============================================================================

module systolic_array #(
    parameter N          = 4,
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
) (
    input  wire                                    clk,
    input  wire                                    rst_n,
    input  wire                                    clear_acc,

    input  wire signed [DATA_WIDTH-1:0]            a_in [0:N-1],
    input  wire signed [DATA_WIDTH-1:0]            b_in [0:N-1],

    output wire signed [ACC_WIDTH-1:0]             c_out [0:N-1][0:N-1]
);

    // day noi noi bo giua cac PE
    // a_wire[i][j] : gia tri a di vao PE(i,j) tu ben trai (j = 0 la canh ngoai)
    // b_wire[i][j] : gia tri b di vao PE(i,j) tu phia tren (i = 0 la canh ngoai)
    wire signed [DATA_WIDTH-1:0] a_wire [0:N-1][0:N];
    wire signed [DATA_WIDTH-1:0] b_wire [0:N][0:N-1];

    genvar i, j;
    generate
        // noi input tu ben ngoai vao canh trai / canh tren cua mang
        for (i = 0; i < N; i = i + 1) begin : GEN_A_EDGE
            assign a_wire[i][0] = a_in[i];
        end
        for (j = 0; j < N; j = j + 1) begin : GEN_B_EDGE
            assign b_wire[0][j] = b_in[j];
        end

        // sinh mang N x N cac PE
        for (i = 0; i < N; i = i + 1) begin : ROW
            for (j = 0; j < N; j = j + 1) begin : COL
                pe_mac #(
                    .DATA_WIDTH (DATA_WIDTH),
                    .ACC_WIDTH  (ACC_WIDTH)
                ) u_pe (
                    .clk        (clk),
                    .rst_n      (rst_n),
                    .clear_acc  (clear_acc),
                    .a_in       (a_wire[i][j]),
                    .b_in       (b_wire[i][j]),
                    .a_out      (a_wire[i][j+1]),
                    .b_out      (b_wire[i+1][j]),
                    .c_out      (c_out[i][j])
                );
            end
        end
    endgenerate

endmodule
