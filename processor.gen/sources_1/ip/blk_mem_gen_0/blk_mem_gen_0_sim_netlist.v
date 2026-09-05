// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2.2 (lin64) Build 6060944 Thu Mar 06 19:10:09 MST 2025
// Date        : Sun Sep  6 00:44:59 2026
// Host        : vishnu-Latitude-5400 running 64-bit Ubuntu 22.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/vishnu/processor/processor.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_10,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_10,Vivado 2024.2.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [9:0]addra;
  wire clka;
  wire [31:0]dina;
  wire [31:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.95215 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_10 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2024.2.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
Vo/CdCry+4XqWyOAGIjJkQxiiFmxV56JJA9+DRAoA73w3PX/VB2Q5+hs51IJHJDQpfz8b+RkWiDc
wzwfz369ViGuppNv4dXlNznLJnJnC7EiskELf02DdJnWWoSZpu+OHK3OSBEQ/zsd9Jo2Fo1W/rmW
MGZUU/6yH18wHS4h1Ks=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
0wk1VmWYpT58dDId4XJkh8egEYIlbnZZOGeyGy5kRkRnXHqDOWQ+oylx90YDv9xCL7Hk4eMKPCF2
m4MOF7S4hVPD0/sWpEA8P8FAe8xJ87dKWSVL4jsUlHtRrOJgD7GALPmxmP7Si18wN1nhP/Em10F8
/dLfzgj1xP3Zf5H9fEp2GcwX2TuABOVnDWshUVbBokKz/60SbCSepujD00YwhBntPBKLjT63NlmT
RTSjuWX0rpXlxj6VOXIYSdG7RSLBcpnJy64tUezG1b35R+o5DxZXCqjet77d6quzpY0zZZt9Ulht
JmIAuDRf34NavmVAN7Mtd0cnmfoh7ogGicjKvQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
F/wTwmHmqba+ezt7048nG7m9PFcFX8+e1ugB8tNrzJbpZSuJRRd6CQfWgrFM6z3Lt+Xnv27fU91W
7UPwQzlK1jnTliJBxoAq1fE2EHH6Meu6+HJfRVpgJ7fg13fbfZIfHUvNXIsh98f9heu0jLNI6weE
/vvav4FblngbAAYUgd0=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
PMW8encF5gzdNpDYeC/r8ImvAQhXqmTUs6jwRDNtn48A6Ujylle4R1SCnyZkY+FJKwRrbwQYM5xZ
q0WAIHjuqQu9pP4jSz77dIgvrGNt/Jq52Ez+a8pAE/wAoX0RiMsIeHFJYKfkmGjaCqeRtGDmk3BV
9+dy4HcmsDt9Uh4xvFjdpggdkLbiE5tjHgzwTlr5njpIBBM3Mc6IQE9aae7pv8wKGZh0ty66qFAn
4S9+ebhRZxOoWu/Dy19sbR1RkcJRag8MPJw9oRctKzduV4AF5TwH1waH32OTyX1p1716Vo25yin9
+rz315JRpqTLSkZJDH0UVGxiqyJ73W6GTzGjvQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Y9dtFDZe/9fosnZUVejOdy+XS5PuLJ0yXHKg9fuNlibvaa70MDgcUmFI1aUQMIXkh/nyrlAYhEOw
ZYwLUiCgGX9gv4rJdGQtx6W5YHqEqKc6ojSRxBAaLdRpzdYB0DpW8oIbjnXFf7e1yx+LS0ZeRvga
Fh2UzEgqmwMNRgmnJM4j2rvUiRrhCjtiaXlkc9pB80ojbMz6j5O0jOYRDx8scLtA39zyl6jlHXkZ
0NhLqQuJbbWjmec6JRtGnaM5QouDbk+MW/fNkDY31kIbegNsEOLQpMNJ83TJH5kTnsHlY9l+0XJ4
tN8eHqmH3rYC3OGyXe7Fa8ZFq6ms3GQKGeMfhA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2023_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
cxjMtMSESPI2+yc8BX2YuZW6C3RMyKfgTvyd4r8Gx1wWxH8i+oZbwjGEFrD70y8NIz21xljoxFEk
JmtYWVokBQDW3gKLSJSvxmzp0T6nMPTGtNrpUDalO3XojGO7PY5zxMgZP7ntyQop50FaRZncfqcN
5w5hYNWywr3sHm14iUZQvYkjfpfI/X0gHmaRZTUBwZnVc3yZYPKpIi/5HdJ0+dh3SqEErHU3sVTy
bnAyZkhEZ9ZbLjELJ9twQdIRF4MiHKefy97m/3WdDg2YAmsDhwVJqEDSQRrhJ1qxyCHTjvccibuz
u7FvVmHfh6hk1tUEJgfJBY2OFz8zJE//prc5iA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ez5C57juA3+sjvTiTimQXL3ngWJqcGkQ5hv2jVBj+qRGyMllvIQOBQlpQ+bYLkOWnTv/S8+6PSxT
jUx6SYCJfbiumC5jC3z/QW4c0ZC4XzIFAgVdN4am8yXHRSI8ApBLYsSyfpVsI2zGpgVek+1s684p
Gx2VLV1Wwf3TcgyHHu6+yizJ+IJrkFjBOqaNptlbq1bdEtVxRkNyJiuKh3hzbPmt386lGeCpCmeS
Ci/w6goqagrSZZ7CwRDpp6J+IHjwRIUheUuNWzxQKdW+FCjw9qNPCND4sELBajCtfBQzY23j6RZD
kUanS7/EEh2ctRvZ6ckx/Y0zFNJYqHo8Lc56aA==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
HJCYSjhpgL6sqdTzuctiBLPlx6fhwuFI2l891REPcV2cKYvrbMCYI17hADRbvcxNH4paQ5/fmqeb
rE9BqB08LRASMx7jlAdSCYKA99cNcVMsByGT1l32kX7+Gtt27iKAIwVTu34+moPXqCCM4c6jUBzB
+UAJGBtS2wc0k+kTtXp6dCXiyjYXC2UFEDt8w9CU1qb2TXkPpgxXcfR4skit7umjdS0NxiP88l7x
PvAeoTea8Nw3NyDr9766x8Q1W1rRkuRmL+1VM37vp+BJsf6MNpeE5FNpkrhdCjc0D3dtRQVsCStO
scOhLAnzS45HjTjy9siiiNpJhXtCEr+5PWuEXVj4OC+yevy5VFcClOy11RiGXUho3zn1YnCjvFUJ
HO4BCq9TThOthuOExIiymQlqo0juTKNFELWCzlCbbJMDntY4twIW1uyY76cuBTeqq0r6SuzbelbH
iF1J/Ai1WoG1NEn6/Ld8lGm+aTPi/mRUvBbdYq6Xx0I1hJ/lrwpbbvpZ

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
i2BfTRuoHRFB8ZXhJCQrSS5Kh/ofOKU6mrd8mOrx1SgmsHKu6td+g6cqGS2nIDZbr1QjP33k7Zjp
xKd5lImYtNz1lFR34XzdVY1YY4Mz0QRDBjsP/kAJr7DZAqZjrJAO3md/zSG8f5SaAh8iTo+EBM+6
afCMZ6ich+nq02odtxrZ5Uhzoa2vt9DW4DcnXj+tuoKWUoRKcWxCrh31TNiwS2b4E/El43/B29XG
FxzmoEh4GH3ZaiuU113Ld+/xkQRsMLFn1JubodEkM9sNeTHfppPAGwjUgCzk8/2hXirRJu/XaML9
VWT5S7x5yGlmti7sQnP9kzJJRUcjTTJzgE5KOQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
FexSVDj1WIebhRipXI5Gh3YLSX845WpAldeuElSHB0huSoXz+Np2tkseCkkF2eCCt8CNhVExuuEr
7/KHUlFqvHa9DLpKIOLmNFWiy8Ay2iuzmmxyL/MPPn/teKD2VjFeD6ssY8l2BwKbCD73MswOuiCc
spGmyJ2i3k6JMBpL+zswzmIpKJ3j76vYQF+o5HgmDtaakOUGTD1nQNPMyZ1ZBD9AvAC9J3eY8qZS
1Wdw7OXuMZ5CZutq7JXBHnLE0i4Zgcf2nWCg+gKKgvBZXlGpEkhs30/caJ4SGThuIkRNEUsnHcfp
jA52TVN8H4BdzJH3hCTxAhB1e5lNWlKwQ+gYEw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Lu5hRxSLFQyLllOA9u5s1HixJJG7j3i4H09yHKiH8Dp26PhhohxwUADFKakrM7CdHL8s7BqigcX0
gERo4eIo8tMf2dBC9mu7P36rm9gCwpvvyiCA52BzF7pay+3P1pMoTC4HhwPNE6jjh2wytbNC11dG
Vy58tmmu3wmLHagXe6TbdJpcYT31yQaqmU4KGKa1xKkiI3FyGRm/MzXZcSfTCQjCiqGXQH1Lnapo
2W3GdrN+nv+SFjJe5j5+T3lxn/fmOusE1hz0LsLbVXEY8ARKrO1m0K91l+AQO9q+hPuF5pSAyHKv
VzZ6TlJOmIhHrqSknN1Au5CIrbyauNSDELtQiw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27936)
`pragma protect data_block
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
Me2gkclI
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
