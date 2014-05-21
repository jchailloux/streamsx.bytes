#include "BytesLib.h"

#include <sstream>
#include <string>
#include <iomanip>
//#include <ios>
//#include <iostream>
#include <bitset>
#include <stdlib.h>
#include <map>
#include "boost/assign.hpp"
#include <SPL/Runtime/Function/SPLFunctions.h>

using namespace std;
using namespace Bytes;
/*
std::map<char, std::string> BytesClass::HexToBin = {
		{'0', "0000"},
		{'1', "0001"},
		{'2', "0010"},
		{'3', "0011"},
		{'4', "0100"},
		{'5', "0101"},
		{'6', "0110"},
		{'7', "0111"},
		{'8', "1000"},
		{'9', "1001"},
		{'A', "1010"},
		{'B', "1011"},
		{'C', "1100"},
		{'D', "1101"},
		{'E', "1110"},
		{'F', "1111"}
};
*/
std::map<char, std::string> BytesClass::HexToBin =  boost::assign::map_list_of
						('0', "0000")
						('1', "0001")
						('2', "0010")
						('3', "0011")
						('4', "0100")
						('5', "0101")
						('6', "0110")
						('7', "0111")
						('8', "1000")
						('9', "1001")
						('A', "1010")
						('B', "1011")
						('C', "1100")
						('D', "1101")
						('E', "1110")
						('F', "1111")
							;

std::string BytesClass::hello()
{
    return "hello world";
}

std::string BytesClass::ASCIIToHexString(const string inputString){
	ostringstream oss;
	for (int i = 0; i < inputString.length (); ++i){
        oss << hex << (int)inputString[i];
    }
	return oss.str();
}

std::string BytesClass::ASCIIToBinaryString(const string inputString){
	ostringstream oss;
	for (int i = 0; i < inputString.length (); ++i){
        oss << bitset<8>(inputString[i]);
    }
	return oss.str();
}

std::string BytesClass::IntegerToBinaryString(const int inputInteger){
	ostringstream oss;
	oss<< hex << setfill('0') << setw(sizeof(inputInteger)) << uppercase << inputInteger;
	return oss.str();
}
std::string BytesClass::HexStringToBinaryString(const string inputString){
	ostringstream oss;
	for (int i = 0; i < inputString.length (); ++i){
		oss << HexToBin[inputString [i]];
	}
	return oss.str();
}
std::string BytesClass::getIntStringFromBinary(const string inputString){
	ostringstream oss;
	int result=0;
	for (int i = 0; i < inputString.length (); i++){
		result = (result << 1) + inputString[i] - '0';
	}
	oss << result;
	return oss.str();
}
std::string BytesClass::getASCIIFromBinary(const string inputString){
	string output(inputString.size() / 8, 0);
	for (int i = 0; i < inputString.size(); i++) {
		if (inputString[i] == '1') {
			output[i / 8] |= 1 << (7 - (i % 8));
		}
	}
	return output;
}
std::string BytesClass::getASCIIWordFromBinary(const string inputString,const string separator){
	ostringstream oss;
	for (int i = 0; i < inputString.length (); i+=8){
		if(i > 0){
			oss << separator;
		}
		oss << getASCIIFromBinary(SPL::Functions::String::subSlice(inputString,i,(i+8)));
    }
	return oss.str();
}
std::string BytesClass::getIntWordFromBinary(const string inputString,const string separator){
	ostringstream oss;
	for (int i = 0; i < inputString.length (); i+=8){
		if(i > 0){
			oss << separator;
		}
		oss << getIntStringFromBinary(SPL::Functions::String::subSlice(inputString,i,(i+8)));
    }
	return oss.str();
}
std::string BytesClass::getHexWordFromBinary(const string inputString,const string separator){
	ostringstream oss;
	for (int i = 0; i < inputString.length (); i+=8){
		bitset<8> b(SPL::Functions::String::subSlice(inputString,i,(i+8)));
		if(i > 0){
			oss << separator;
		}
		oss << hex << setfill('0') << setw(2) << uppercase <<  b.to_ulong() ;
    }
	return oss.str();
}
