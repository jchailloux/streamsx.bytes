#ifndef FUNCTIONS_H_
#define FUNCTIONS_H_
// Define SPL types and functions.
#include "SPL/Runtime/Function/SPLFunctions.h"
#include <BytesLib.h>
//#include <cstdint>
//#include <iomanip>
//#include <ios>
//#include <iostream>
//#include <bitset>
//#include <stdlib.h>
//#include <map>
//#include "boost/assign.hpp"

// Define the C++ namespace here.
namespace Bytes {
	// SPL authors recommend using the SPL namespace here.
	// This will allow us to use rich functions offered by the SPL API.
	using namespace SPL;
	using namespace std;

	inline rstring ASCIIToHexString(const string& inputString){
		return Bytes::BytesClass::ASCIIToHexString(inputString);
	}

	inline rstring ASCIIToBinaryString(const string& inputString){
		return Bytes::BytesClass::ASCIIToBinaryString(inputString);
	}

	inline rstring IntegerToBinaryString(const int& inputInteger){
		return Bytes::BytesClass::IntegerToBinaryString(inputInteger);
	}
	inline rstring HexStringToBinaryString(const string& inputString){
		return Bytes::BytesClass::HexStringToBinaryString(inputString);
	}
	inline rstring getIntStringFromBinary(const string& inputString){
		return Bytes::BytesClass::getIntStringFromBinary(inputString);
	}
	inline rstring getASCIIFromBinary(const string& inputString){
		return Bytes::BytesClass::getASCIIFromBinary(inputString);
	}
	inline rstring getASCIIWordFromBinary(const string& inputString,const string& separator){
		return Bytes::BytesClass::getASCIIWordFromBinary(inputString,separator);
	}
	inline rstring getIntWordFromBinary(const string& inputString,const string& separator){
		return Bytes::BytesClass::getIntWordFromBinary(inputString,separator);
	}
	inline rstring getHexWordFromBinary(const string& inputString,const string& separator){
		return Bytes::BytesClass::getHexWordFromBinary(inputString,separator);
	}

} // End of namespace

#endif // End of FUNCTIONS_H_
