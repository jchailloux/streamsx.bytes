#ifndef BYTES_LIB
#define BYTES_LIB

#include <string>
#include "boost/assign.hpp"

namespace Bytes {

    class BytesClass
    {
    public:
        static std::string hello();
    	static std::map<char, std::string> HexToBin;
/*
    	static std::map<char, string> HexToBin = boost::assign::map_list_of
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
*/

    	static std::string ASCIIToHexString(const std::string inputString);

    	static std::string ASCIIToBinaryString(const std::string inputString);
    	static std::string IntegerToBinaryString(const int inputInteger);
    	static std::string HexStringToBinaryString(const std::string inputString);
    	static std::string getIntStringFromBinary(const std::string inputString);
    	static std::string getASCIIFromBinary(const std::string inputString);
    	static std::string getASCIIWordFromBinary(const std::string inputString,const std::string separator);
    	static std::string getIntWordFromBinary(const std::string inputString,const std::string separator);
    	static std::string getHexWordFromBinary(const std::string inputString,const std::string separator);

			};
};

#endif /* MY_SAMPLE_LIB */
