project HW2 two stage op amplifier

.prot
.lib '/home/u0819823/C018/models/cic018.l' tt
.unprot

.param vdd=1.8
.param ib=0.6u
.param vbias1=1.2
.param C1=1p
.param Cc=0.1p
.param Rz=200k
.param width=1.2u
.param length=0.4u

M1 n1 nin- n3 0 N_18 W=width L=length 
M2 n2 nin+ n3 0 N_18 W=width L=length 
M3 n1 n1 ndd ndd P_18 W=width L=length 
M4 n2 n1 ndd ndd P_18 W=width L=length 
M5 n3 nb 0 0 N_18 W=2*width L=length 
Mbias nb nb 0 0 N_18 W=length L=length
M6 n4 n2 ndd ndd P_18 W=2*width L=length 
M7 n4 nb 0 0 N_18 W=2*width L=length


Cc n2 n5 Cc
Cl n4 0 C1

Rz n5 n4 Rz

Vdd ndd 0 vdd
Vin- nin- 0 vbias1
Vin+ nin+ 0 vbias1
Ibias ndd nb ib

**0
.op
.option post=1
.option accurate=1
.option probe=0
.temp=27

**1
**Output Swing analysis
.alter
Vin- nin- n4 0 
Vin+ nin+ 0 pwl(0 0 1m 1.8)
.tran 0.1n 1m

**2
**Slew Rate analysis
.alter
Vin+ nin+ 0 DC vbias1 pulse(0.5 1.8 1u 1n 1n 10u 20u)
Vin- nin- n4 0
.tran 0.1n 80u

**3
**PSRR
.alter
Vdd ndd 0 vdd ac 1
Vin- nin- 0 vbias1
vin+ nin+ 0 vbias1
.ac DEC 100 1 100Meg
.probe vdb(n4) $This is the result of PSR
**PSRR=Adm/PSR

**4
**CMRR
.alter
Vdd ndd 0 vdd 
Vin- nin- 0 vbias1 ac 1
Vin+ nin+ 0 vbias1 ac 1
**.ac DEC 100 1 100Meg
.probe vdb(n4) $This result is Acm
**CMRR=Adm/Acm


**5
**Ac analysis
.alter
Vin- nin- 0 vbias1 ac 1
Vin+ nin+ 0 vbias1
**.ac dec 100 1 100Meg
.probe vdb(n4) vp(n4)
.meas ac UGB when vdb(n4)=0
.meas ac PM find=par('vp(n4)') when vdb(n4)=0
.meas ac VMAX max vdb(n4)

.END