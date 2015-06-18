//#include <sstream>
//#include <string>
//#include <iomanip>
//#include <ios>
//#include <iostream>
#include <bitset>
//#include <stdlib.h>
//#include <map>
#include "boost/assign.hpp"
#include <SPL/Runtime/Function/SPLFunctions.h>

using namespace std;

static map<char, string> HexToBin =  boost::assign::map_list_of
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
/*
 * Reverse bitset 'bits'
 */
//template<size_t T>
//bitset<T> Reverse(const bitset<T> &bits) {
//	SPLAPPTRC(L_DEBUG, "Reverse bitset : " << bits.to_string(), SPL_OPER_DBG);
//	bitset<T> out;
//	for (size_t i = 0; i < T; i++)
//		out[(T-1) - i] = bits[i];
//	return out;
//}

/*
 * Rotate left the bitset 'x' by 'shift' bits
 */
//template<size_t T>
//bitset<T> ROL(bitset<T> x, unsigned int shift){
//  	assert(shift <= (T/2));
//  	//Twice the size of the bitset to keep bits moved outside
//	bitset<T*2> l(x.to_string());
//	bitset<T*2> r;
//	//Shift
//	l=(l << shift);
//	//Get moved bits
//	r=(l >> (x.size()));
//	//OR shift bits and moved bits + move result to reduce the bitset's size
//	bitset<T> out(((l| r) << (x.size())).to_string());
//  return  out;
//}

/*
 * Rotate right the bitset 'x' by 'shift' bits
 */
//template<size_t T>
//bitset<T> ROR(bitset<T> x, unsigned int shift){
//  	assert(shift <= (T/2));
//  	//Twice the size of the bitset to keep bits moved outside
//	bitset<T*2> l(x.to_string());
//	bitset<T*2> r;
//	//Move bits to the left to being able to shift right and keep moved bits
//	l=(l << (x.size()));
//	//Shift
//	l=(l >> shift);
//	//Get moved bits
//	r=(l << (x.size()));
//	//OR shift bits and moved bits
//	bitset<T> out((l| r).to_string());
//  return  out;
//}

/*
* get N bits from bitset
*/
//template<size_t T>
//bitset<T> getBits(const bitset<T> &bits,const size_t start,const size_t len,bool LSB) {
//	//Double check that we will deal with T bits
//  	assert(len <= T);
//  	assert(start + len <= T);
//
//  	bitset<T> result;
//  	bitset<T> input;
//  	if(LSB)
//  		input=Reverse(bits);
//  	else
//  		input=bits;
//  	for (size_t i = 0; i < len; i++){
////  		if(LSB){
////  			result[i] = bits[start + len - i - 1]; 	//LSB : left to right
////  		}else{
//  	    	result[i] = input[start + i - 1];		//MSB : right to left
////  		}
//    }
//  	return result;
//}

static const string base64_chars ="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static inline bool is_base64(unsigned char c) {
  return (isalnum(c) || (c == '+') || (c == '/'));
}
