<p align="center">
    <a href="https://www.gnu.org/licenses/gpl-3.0.ja.html"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg" alt="Licenses"></a>
</p>

# AES_in_AWK  
AWK (GAWK) version implementation for the purpose of understanding AES from the specification  
AESを仕様から理解することを目的とした、AWK(GAWK)版実装です。  

元は、有限会社ピイジェイ様が作成された、Java版の実装を移植しました。  
Javaでは、byte型では-127から128までなので、そのあたりの実装がAWKとは違っています。  

どうにもソースコードのコメントが文字化けが直らずに読めないので、読める部分で移植し、後は省きました。  

https://www.pjc.co.jp/  
ピイジェイ  

https://free.pjc.co.jp/Java/index.html  
AES JAVA言語によるサンプルプログラム・ソース・ソフトウェアの配布 PJC  

ライセンスは、移植元がGPL V3でリリースしていたので、GPL V3としています。

# gawkと他awkの相互互換のための説明  
# Description for the mutual compatibility of gawk and other awk  

ビット演算について  
About bit operations

	* 論理積、論理和、排他的論理和については、以下のリンクに掲載されている実装を参照してください。  
	* チェック機構までは保証しているわけではないので、そのあたりを突き詰めていると時間ばかりかかって仕方がなかったり、
    そのほかのビットシフトなど、アルゴリズムを書くのがしんどい方は、  
    bourne shellのletや算術式を「sh -c」でsystem関数で呼んで評価させる手もあります。  
    	* 当然ながら、何回もこんなコールをする処理では、当然実行速度には難があるでしょう。  

	* For the logical product, logical sum, and exclusive logical sum, refer to the implementation listed in the following link.
	* The check mechanism is not guaranteed, so if you try to find it, it will take time and you can't help it.  
	* If it is difficult to write an algorithm such as bit shift, there is also a way to call let and arithmetic expression of bourne shell by "sh -c" with system function and evaluate it.  
	* Of course, in the process of making such a call many times, naturally the execution speed will be difficult.  

	* 時間城年代記:mawkのためのビット演算関数  
	http://blog.livedoor.jp/kikwai/archives/52263266.html  

	* awk と bit 演算（平林浩一）  
	http://www.mogami.com/unix/awk-02.html  

# 使い方
# Usage

```bash
gawk -f AES_Transfer.awk
```

```

$ ls -1
AES_Transfer.awk
FuncCipher.awk
FuncInvCipher.awk

$ time gawk -f AES_Transfer.awk
<FIPS 197  P.35 Appendix C.1 AES-128 TEST>

PLAINTEXT : 00112233445566778899aabbccddeeff
KEY : 000102030405060708090a0b0c0d0e0f
Encryption : 69c4e0d86a7b0430d8cdb78070b4c55a
Decryption : 00112233445566778899aabbccddeeff

<FIPS 197  P.38 Appendix C.2 AES-192 TEST>

PLAINTEXT : 00112233445566778899aabbccddeeff
KEY : 000102030405060708090a0b0c0d0e0f1011121314151617
Encryption : dda97ca4864cdfe06eaf70a0ec0d7191
Decryption : 00112233445566778899aabbccddeeff

<FIPS 197  P.42 Appendix C.3 AES-256 TEST>

PLAINTEXT : 00112233445566778899aabbccddeeff
KEY : 000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f
Encryption : 8ea2b7ca516745bfeafc49904b496089
Decryption : 00112233445566778899aabbccddeeff

AES TEST END

real    0m0.025s
user    0m0.016s
sys     0m0.000s

$

```

