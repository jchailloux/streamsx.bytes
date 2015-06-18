/*
 * Base64 encode/decode comes from http://www.adp-gmbh.ch/cpp/common/base64.html
 */
#ifndef FUNCTIONS_H_
#define FUNCTIONS_H_
// Define SPL types and functions.
#include "SPL/Runtime/Function/SPLFunctions.h"
//#include "bytes/Transformation.h"
#include "util.h"
#include <iomanip>
#include "boost/dynamic_bitset.hpp"

using namespace SPL;
using namespace std;

// Define the C++ namespace here.
namespace com{
namespace ibm{
namespace streamsx{
namespace bytes{
	namespace conversion{
		inline rstring decodeBase64(const string& encoded_string){
			SPLAPPTRC(L_DEBUG, "base64 string to decode : " <<encoded_string , SPL_OPER_DBG);
			int in_len = encoded_string.size();
			int i = 0;
			int j = 0;
			int in_ = 0;
			unsigned char char_array_4[4], char_array_3[3];
			string ret;

			while (in_len-- && ( encoded_string[in_] != '=') && is_base64(encoded_string[in_])) {
				char_array_4[i++] = encoded_string[in_]; in_++;
				if (i ==4) {
					for (i = 0; i <4; i++)
						char_array_4[i] = base64_chars.find(char_array_4[i]);

					char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
					char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
					char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

					for (i = 0; (i < 3); i++)
						ret += char_array_3[i];
						i = 0;
					}
				}

				if (i) {
					for (j = i; j <4; j++)
						char_array_4[j] = 0;

					for (j = 0; j <4; j++)
						char_array_4[j] = base64_chars.find(char_array_4[j]);

					char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
					char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
					char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

					for (j = 0; (j < i - 1); j++)
						ret += char_array_3[j];
			}

			return ret;
		}
		inline rstring encodeBase64(const string& input){
			SPLAPPTRC(L_DEBUG, "string to endecode in base64 : " <<input, SPL_OPER_DBG);
			string ret;
			int i = 0;
			int j = 0;
			unsigned char char_array_3[3];
			unsigned char char_array_4[4];

			const char* bytes_to_encode =input.c_str();
			unsigned int in_len=strlen(bytes_to_encode);

			while (in_len--) {
				char_array_3[i++] = *(bytes_to_encode++);
				if (i == 3) {
					char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
					char_array_4[1] = ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
					char_array_4[2] = ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
					char_array_4[3] = char_array_3[2] & 0x3f;

					for(i = 0; (i <4) ; i++)
						ret += base64_chars[char_array_4[i]];
					i = 0;
				}
			}

			if (i){
				for(j = i; j < 3; j++)
					char_array_3[j] = '\0';

				char_array_4[0] = (char_array_3[0] & 0xfc) >> 2;
				char_array_4[1] = ((char_array_3[0] & 0x03) << 4) + ((char_array_3[1] & 0xf0) >> 4);
				char_array_4[2] = ((char_array_3[1] & 0x0f) << 2) + ((char_array_3[2] & 0xc0) >> 6);
				char_array_4[3] = char_array_3[2] & 0x3f;

				for (j = 0; (j < i + 1); j++)
					ret += base64_chars[char_array_4[j]];

				while((i++ < 3))
					ret += '=';
			}

			return ret;
		}
		inline rstring convertFromASCIIToHex(const string& inputString){
			SPLAPPTRC(L_DEBUG, "ASCII String to convert into Hexadecimal :  " <<inputString , SPL_OPER_DBG);
			ostringstream oss;
			for (int i = 0; i < (int)inputString.length (); ++i){
				int c=(int)inputString[i];
				if(c < 0){
					c=c+256;
				}
		        oss << uppercase << hex << setw(2) << setfill('0')<< c;
		    }
			return oss.str();
		}
		inline rstring convertFromHexToASCII(const string& inputString){
			SPLAPPTRC(L_DEBUG, "Hexadecimal String to convert into ASCII :  " <<inputString , SPL_OPER_DBG);
			ostringstream oss;
			ostringstream temp;
			for(int i = 0; i < (int)(inputString.length()-1); i+=2) {
				temp <<inputString[i]<<inputString[i+1];
			    oss << (char)strtol(temp.str().c_str(),NULL,16);
				temp.str("");
			}
			return oss.str();
		}
		inline rstring convertFromASCIIToBinary(const string& inputString){
			SPLAPPTRC(L_DEBUG, "ASCII String to convert into Binary :  " <<inputString , SPL_OPER_DBG);
			ostringstream oss;
			for (int i = 0; i < (int)inputString.length (); ++i){
		        oss << bitset<8>(inputString[i]);
		    }
			return oss.str();
		}
		inline rstring convertFromBinaryToASCII(const string& inputString){
			SPLAPPTRC(L_DEBUG, "Binary String to convert into ASCII :  " <<inputString , SPL_OPER_DBG);
			string output(inputString.size() / 8, 0);
			for (int i = 0; i < (int)inputString.size(); i++) {
				if (inputString[i] == '1') {
					output[i / 8] |= 1 << (7 - (i % 8));
				}
			}
			return output;
		}
		inline rstring convertFromHexToBinary(const string& inputString){
			SPLAPPTRC(L_DEBUG, "Hexadecimal String to convert into Binary :  " <<inputString , SPL_OPER_DBG);
			ostringstream oss;
			std::locale loc;
			for (int i = 0; i < (int)inputString.length (); ++i){
//				cout << inputString [i] << "-"<<std::toupper(inputString [i],loc)<<" = " << HexToBin[std::toupper(inputString [i],loc)]<<endl;
				oss << HexToBin[std::toupper(inputString [i],loc)];
			}
			return oss.str();
		}
		inline rstring convertFromHexToBinaryUsingDictionnary(const string& inputString,std::map<char,string> dic){
			SPLAPPTRC(L_DEBUG, "Hexadecimal String to convert into Binary using dictionnary:  " <<inputString , SPL_OPER_DBG);
			ostringstream oss;
			for (int i = 0; i < (int)inputString.length (); ++i){
//				cout << inputString [i] << "-"<<std::toupper(inputString [i],loc)<<" = " << HexToBin[std::toupper(inputString [i],loc)]<<endl;
				oss << dic[inputString [i]];
			}
			return oss.str();
		}
		inline rstring convertFromBinaryToHex(const string& inputString){
			SPLAPPTRC(L_DEBUG, "Binary String to convert into Hexadecimal :  " <<inputString , SPL_OPER_DBG);
			ostringstream oss;
			for (int i = 0; i < (int)inputString.length (); i+=8){
				bitset<8> b(SPL::Functions::String::subSlice(inputString,i,(i+8)));
				oss << hex << setfill('0') << setw(2) << uppercase <<  b.to_ulong() ;
		    }
			return oss.str();
		}
		inline rstring reverseBinaryString(const string& input){
			SPLAPPTRC(L_DEBUG, "Reverse Binary String  :  " <<input , SPL_OPER_DBG);
			ostringstream oss;
			boost::dynamic_bitset<> b(input);
			boost::dynamic_bitset<> out;
			unsigned int sz=b.size();
			for (unsigned int i = 0; i < sz; i++)
				out[(sz-1) - i] = b[i];
			oss << out;
			return oss.str();
		}
	}
	namespace transformation{
		inline string getBitStringFromInt(int input){
			if ((input>=-128) && (input <=127)){
				SPLAPPTRC(L_DEBUG, input << " is int8", SPL_OPER_DBG);
				bitset<8> b(input);
				return b.to_string();
			}else
			if ((input>=-32768) && (input <=32767)){
				SPLAPPTRC(L_DEBUG, input << " is int16", SPL_OPER_DBG);
				bitset<16> b(input);
				return b.to_string();
			}else
			if ((input>=-2147483648) && (input <=2147483647)){
				SPLAPPTRC(L_DEBUG, input << " is int32", SPL_OPER_DBG);
				bitset<32> b(input);
				return b.to_string();
			}else{
//			if ((input>=-9223372036854775808) && (input <=9223372036854775807 )){
				SPLAPPTRC(L_DEBUG, input << " is int64", SPL_OPER_DBG);
				bitset<64> b(input);
				return b.to_string();
			}
		}
		inline string getBitStringFromUnsignedInt(long input){
			if ((input>=0) && (input <=255)){
				SPLAPPTRC(L_DEBUG, input << " is uint8", SPL_OPER_DBG);
				bitset<8> b(input);
				return b.to_string();
			}else
			if ((input>=0) && (input <=65535)){
				SPLAPPTRC(L_DEBUG, input << " is uint16", SPL_OPER_DBG);
				bitset<16> b(input);
				return b.to_string();
			}else
			if ((input>=0) && (input <=4294967295)){
				SPLAPPTRC(L_DEBUG, input << " is uint32", SPL_OPER_DBG);
				bitset<32> b(input);
				return b.to_string();
			}else{
//			if ((input>=0) && (input <=18446744073709551615 )){
				SPLAPPTRC(L_DEBUG, input << " is uint64", SPL_OPER_DBG);
				bitset<64> b(input);
				return b.to_string();
			}
		}
		inline long getUnsignedIntFromBinaryString(string input){
			boost::dynamic_bitset<> b(input);
			return b.to_ulong();
		}
		inline double getValueFromBinaryString(string input,string format,double factor,double offset,double limit){
			unsigned int value=getUnsignedIntFromBinaryString(input);
			double result=0.0;
			char output [50];
	    	if((value>=limit)&&(limit > 0)){
				sprintf(output, format.c_str(), (value * factor + (offset*2)) );
	    	}else{
				sprintf(output, format.c_str(), (value * factor+offset));
	    	}
	    	result=atof(output);
	    	return result;
		}
		inline string rotateLeft(string input,unsigned int shift){
			boost::dynamic_bitset<> b(input);
			boost::dynamic_bitset<> rol;
			ostringstream oss;
			rol=	(b >> (b.size()-shift)) | (b << shift);
			oss<<rol;
			return oss.str();
		}
		inline string rotateRight(string input,unsigned int shift){
			boost::dynamic_bitset<> b(input);
			boost::dynamic_bitset<> ror;
			ostringstream oss;
			ror=	(b << (b.size()-shift)) | (b >> shift);
			oss<<ror;
			return oss.str();
		}


	}

}}}} // End of namespace

#endif // End of FUNCTIONS_H_
