#!/usr/bin/gawk -f
# FuncCipher.awk

# FIPS 197  P.15 Figure 5
function Cipher(){
	AddRoundKey("0");
	for(i = 1; i < nr; i++){
		SubBytes();
		ShiftRows();
		MixColumns();
		AddRoundKey(i);
	}
	SubBytes();
	ShiftRows();
	AddRoundKey(i);
}

# FIPS 197  P.16 Figure 6
function SubBytes(SB_AND_From,SB_AND_Res){
	for(j = 0; j < NBb; j = j + 4){
		for(k = 0; k < 4; k++){
			SB_AND_From = strtonum(data_Arrays[j + k]);
			SB_AND_Res = and(SB_AND_From,Mask);
			data_Arrays[j + k] = Sbox_Arrays[SB_AND_Res];
		}
	}
}

# FIPS 197  P.17 Figure 8
function ShiftRows(cw_pointer,data_pointer){
	for(j in data_Arrays){
		cw[j] = data_Arrays[j];
	}
	dp_mask = 3;
	for(j = 0; j < NBb; j = j + 16){
		for(k = 1; k < 4; k++){
			SR_Cnt = 0;
			for(n = 0; n < 4; n++){
				SR_sub();
			}
		}
	}
	for(j in cw){
		data_Arrays[j] = cw[j];
	}
	delete cw;
}

function SR_sub(){
	cw_pointer = j + k + SR_Cnt * 4;
	data_pointer = k + SR_Cnt;
	data_pointer = and(data_pointer,dp_mask);
	data_pointer = j + k + data_pointer * 4;
	cw[cw_pointer] = data_Arrays[data_pointer];
	SR_Cnt++;
}

# FIPS 197  P.18 Figure 9
function MixColumns(){
	for(j = 0; j < NBb; j = j + 4){
		x_pt = j;
		mul_data_0 = mul(data_Arrays[j + 0],2);
		mul_data_1 = mul(data_Arrays[j + 1],3);
		mul_data_2 = mul(data_Arrays[j + 2],1);
		mul_data_3 = mul(data_Arrays[j + 3],1);
		MixColumns_subs();
		
		mul_data_0 = mul(data_Arrays[j + 1],2);
		mul_data_1 = mul(data_Arrays[j + 2],3);
		mul_data_2 = mul(data_Arrays[j + 3],1);
		mul_data_3 = mul(data_Arrays[j + 0],1);
		MixColumns_subs();
		
		mul_data_0 = mul(data_Arrays[j + 2],2);
		mul_data_1 = mul(data_Arrays[j + 3],3);
		mul_data_2 = mul(data_Arrays[j + 0],1);
		mul_data_3 = mul(data_Arrays[j + 1],1);
		MixColumns_subs();
		
		mul_data_0 = mul(data_Arrays[j + 3],2);
		mul_data_1 = mul(data_Arrays[j + 0],3);
		mul_data_2 = mul(data_Arrays[j + 1],1);
		mul_data_3 = mul(data_Arrays[j + 2],1);
		MixColumns_subs();
		x_pt = 0;
		
	}
	for(j in x){
		data_Arrays[j] = x[j];
	}
	delete x;
}

function MixColumns_subs(){
	x[x_pt] = xor(mul_data_0,mul_data_1);
	x[x_pt] = xor(x[x_pt],mul_data_2);
	x[x_pt] = xor(x[x_pt],mul_data_3);
	x_pt++;
}

# FIPS 197 P.10 4.2
function mul(mul_dt,mul_n){
	mul_x = 0;
	mul_Mask = strtonum("0x100");
	for(k = 8; k > 0; k = rshift(k,1)){
		mul_x = lshift(mul_x,1);
		mul_AND = and(mul_x,mul_Mask);
		if(mul_AND != 0){
			X1B = strtonum("0x1b");
			mul_x = xor(mul_x,X1B);
			mul_x = and(mul_x,Mask);
		}
		mul_AND = and(mul_n,k);
		if(mul_AND != 0){
			mul_x = xor(mul_x,mul_dt);
		}
	}
	return mul_x;
}

# FIPS 197  P.19 Figure 10
function AddRoundKey(ARK_n){
	for(m = 0; m < NBb; m = m + 4){
		# data[i] ^= w[i+NB*n];
		Pos1 = m;
		Pos2 = Pos1 + NBb * ARK_n;
		Exor_data(Pos1,Pos2);
	}
}

function Exor_data(Exor_Pos1,Exor_Pos2){
	# w[pos1+0] = (byte) (w[pos2+0] ^ temp[0]);
	for(j = 0; j < 4; j++){
		data_Arrays[Exor_Pos1 + j] = xor(data_Arrays[Exor_Pos1 + j],w[Exor_Pos2 + j]);
	}
}

function Exor_w(Exor_Pos1,Exor_Pos2){
	# w[pos1+0] = (byte) (w[pos2+0] ^ temp[0]);
	for(j = 0; j < 4; j++){
		w[Exor_Pos1 + j] = xor(w[Exor_Pos2 + j],temp[j]);
	}
}

