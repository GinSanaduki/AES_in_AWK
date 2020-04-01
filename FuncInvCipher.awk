#!/usr/bin/gawk -f
# FuncInvCipher.awk

# FIPS 197  P.21 Figure 12
function invCipher(){
	AddRoundKey(nr);
	for(i = nr - 1; i > 0; i--){
		invShiftRows();
		invSubBytes();
		AddRoundKey(i);
		invMixColumns();
	}
	invShiftRows();
	invSubBytes();
	AddRoundKey(0);
}

# FIPS 197  P.22 5.3.2
function invSubBytes(SB_AND_From,SB_AND_Res){
	for(j = 0; j < NBb; j = j + 4){
		for(k = 0; k < 4; k++){
			SB_AND_From = strtonum(data_Arrays[j + k]);
			SB_AND_Res = and(SB_AND_From,Mask);
			data_Arrays[j + k] = invSbox_Arrays[SB_AND_Res];
		}
	}
}

# FIPS 197  P.22 Figure 13
function invShiftRows(){
	for(j in data_Arrays){
		cw[j] = data_Arrays[j];
	}
	cw_mask = 3;
	for(j = 0; j < NBb; j = j + 16){
		for(k = 1; k < 4; k++){
			invSR_Cnt = 0;
			for(n = 0; n < 4; n++){
				invSR_sub();
			}
		}
	}
	for(j in cw){
		data_Arrays[j] = cw[j];
	}
	delete cw;
}

function invSR_sub(){
	data_pointer = j + k + invSR_Cnt * 4;
	cw_pointer = k + invSR_Cnt;
	cw_pointer = and(cw_pointer,cw_mask);
	cw_pointer = j + k + cw_pointer * 4;
	cw[cw_pointer] = data_Arrays[data_pointer];
	invSR_Cnt++;
}

function invMixColumns(invMC_n){
	for(j = 0; j < NBb; j = j + 4){
		x_pt = j;
		mul_data_0 = mul(data_Arrays[j + 0],14);
		mul_data_1 = mul(data_Arrays[j + 1],11);
		mul_data_2 = mul(data_Arrays[j + 2],13);
		mul_data_3 = mul(data_Arrays[j + 3],9);
		MixColumns_subs();
		
		mul_data_0 = mul(data_Arrays[j + 1],14);
		mul_data_1 = mul(data_Arrays[j + 2],11);
		mul_data_2 = mul(data_Arrays[j + 3],13);
		mul_data_3 = mul(data_Arrays[j + 0],9);
		MixColumns_subs();
		
		mul_data_0 = mul(data_Arrays[j + 2],14);
		mul_data_1 = mul(data_Arrays[j + 3],11);
		mul_data_2 = mul(data_Arrays[j + 0],13);
		mul_data_3 = mul(data_Arrays[j + 1],9);
		MixColumns_subs();
		
		mul_data_0 = mul(data_Arrays[j + 3],14);
		mul_data_1 = mul(data_Arrays[j + 0],11);
		mul_data_2 = mul(data_Arrays[j + 1],13);
		mul_data_3 = mul(data_Arrays[j + 2],9);
		MixColumns_subs();
		x_pt = 0;
		
	}
	for(j in x){
		data_Arrays[j] = x[j];
	}
	delete x;
}

