streamsx.bytes
==============

This toolkit provides

	Functions to manipulate data operator to parse a message and extract bits from it based on a JSON definition

		Conversion
			decodeBase64			: Decode a base64 string
								MQ==					->		1

			encodeBase64			: Encode a string into it's base64 representation
								IBM					->		SUJN

			convertFromASCIIToHex		: Convert an ASCII string into Hexadecimal string
								22					->		3232

			convertFromHexToASCII		: Convert an Hexadecimal string into an ASCII string
								49424D					->		IBM

			convertFromASCIIToBinary	: Convert an ASCII string into a Binary string
								22					-> 		0011001000110010

			convertFromBinaryToASCII	: Convert a Binary string into an ASCII string
								010010010100001001001101		->		IBM

			convertFromHexToBinary		: Convert an Hexadecimal string into a Binary string
								3232					->		0011001000110010

			convertFromBinaryToHex		: Convert a Binary string into an Hexadecimal string
								010010010100001001001101		->		49424D


		Transformation
			getBitStringFromInt		: Get the Binary string of an integer
								18178					->		0100011100000010

			getBitStringFromUnsignedInt	: Get the Binary string of an unsigned integer
								18178					->		0100011100000010

			getUnsignedIntFromBinaryString	: Get the unsigned int represented by a Binary string
								0100011100000010			->		18178

			rotateLeft			: Rotate a Binary string to the left
								0100011100000010 			->		0000001001000111 (ROL 8)

			rotateRight			: Rotate a Binary string to the right
								0100011100000010 			->		0010010001110000 (ROR 4)

			getValueFromBinaryString	: Get the value (float64) of a Binary string using the formula y=factor * x + offset
							 with the precision you specified (%.xf) and applying correction if limit is specified
								1100000010("%.3f",0.0625,-32,512)	->		-15.875
								00111011111("%.9f",0.17578125,100,0)	->		184.19921875
	Operator to parse message

		BytesParse				: Operator that parse a message using a message definition provided in a JSON format.
							 The definition is provided as a parameter
							 The tuple for the output port must contain the ExtractedParameter schema (provided by the toolkit).

							 A punctuation is generated when the input message is parsed.

	Type 
		ExtractedParameter			: The tuple schema for parsed data 


