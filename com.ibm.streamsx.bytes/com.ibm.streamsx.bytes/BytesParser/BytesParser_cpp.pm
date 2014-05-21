
package BytesParser_cpp;
use strict; use Cwd 'realpath';  use File::Basename;  use lib dirname(__FILE__);  use SPL::Operator::Instance::OperatorInstance; use SPL::Operator::Instance::Context; use SPL::Operator::Instance::Expression; use SPL::Operator::Instance::ExpressionTree; use SPL::Operator::Instance::ExpressionTreeVisitor; use SPL::Operator::Instance::ExpressionTreeCppGenVisitor; use SPL::Operator::Instance::InputAttribute; use SPL::Operator::Instance::InputPort; use SPL::Operator::Instance::OutputAttribute; use SPL::Operator::Instance::OutputPort; use SPL::Operator::Instance::Parameter; use SPL::Operator::Instance::StateVariable; use SPL::Operator::Instance::Window; 
sub main::generate($$) {
   my ($xml, $signature) = @_;  
   print "// $$signature\n";
   my $model = SPL::Operator::Instance::OperatorInstance->new($$xml);
   unshift @INC, dirname ($model->getContext()->getOperatorDirectory()) . "/../impl/nl/include";
   $SPL::CodeGenHelper::verboseMode = $model->getContext()->isVerboseModeOn();
   print '/* Additional includes go here */', "\n";
   print '#include "BytesLib.h"', "\n";
   use BytesParserCommon;
   BytesParserCommon::Init($model);
   use Cwd;
   my $pwd = cwd();
   chop($::file);
   $::file =~ s/^.//;#(0.005
   my $file=$pwd . "/data/" . $::file;
   use XML::Simple;
   my $data = XMLin($file,KeepRoot => 1, KeyAttr => 1, ForceArray=>1);
   print "\n";
   SPL::CodeGen::implementationPrologue($model);
   print "\n";
   print 'using namespace SPL;', "\n";
   print 'using namespace std;', "\n";
   print '//using namespace bytes;', "\n";
   print '/*', "\n";
   print '	static std::map<char, string> HexToBin = boost::assign::map_list_of', "\n";
   print '							(\'0\', "0000")', "\n";
   print '							(\'1\', "0001")', "\n";
   print '							(\'2\', "0010")', "\n";
   print '							(\'3\', "0011")', "\n";
   print '							(\'4\', "0100")', "\n";
   print '							(\'5\', "0101")', "\n";
   print '							(\'6\', "0110")', "\n";
   print '							(\'7\', "0111")', "\n";
   print '							(\'8\', "1000")', "\n";
   print '							(\'9\', "1001")', "\n";
   print '							(\'A\', "1010")', "\n";
   print '							(\'B\', "1011")', "\n";
   print '							(\'C\', "1100")', "\n";
   print '							(\'D\', "1101")', "\n";
   print '							(\'E\', "1110")', "\n";
   print '							(\'F\', "1111")', "\n";
   print '								;', "\n";
   print '*/', "\n";
   print '/*', "\n";
   print '	rstring getIntStringFromBinary(const string& inputString){', "\n";
   print '		ostringstream oss;', "\n";
   print '		int result=0;', "\n";
   print '		for (int i = 0; i < inputString.length (); i++){', "\n";
   print '			result = (result << 1) + inputString[i] - \'0\';', "\n";
   print '		}', "\n";
   print '		oss << result;', "\n";
   print '		return oss.str();', "\n";
   print '	}', "\n";
   print '	rstring getASCIIFromBinary(const string& inputString){', "\n";
   print '		string output(inputString.size() / 8, 0);', "\n";
   print '		for (int i = 0; i < inputString.size(); i++) {', "\n";
   print '			if (inputString[i] == \'1\') {', "\n";
   print '				output[i / 8] |= 1 << (7 - (i % 8));', "\n";
   print '			}', "\n";
   print '		}', "\n";
   print '		return output;', "\n";
   print '	}', "\n";
   print '	rstring getASCIIWordFromBinary(const string& inputString,const string& separator){', "\n";
   print '		ostringstream oss;', "\n";
   print '		for (int i = 0; i < inputString.length (); i+=8){', "\n";
   print '			if(i > 0){', "\n";
   print '				oss << separator;', "\n";
   print '			}', "\n";
   print '			oss << getASCIIFromBinary(SPL::Functions::String::subSlice(inputString,i,(i+8)));', "\n";
   print '	    }', "\n";
   print '		return oss.str();', "\n";
   print '	}', "\n";
   print '	rstring getIntWordFromBinary(const string& inputString,const string& separator){', "\n";
   print '		ostringstream oss;', "\n";
   print '		for (int i = 0; i < inputString.length (); i+=8){', "\n";
   print '			if(i > 0){', "\n";
   print '				oss << separator;', "\n";
   print '			}', "\n";
   print '			oss << getIntStringFromBinary(SPL::Functions::String::subSlice(inputString,i,(i+8)));', "\n";
   print '	    }', "\n";
   print '		return oss.str();', "\n";
   print '	}', "\n";
   print '	rstring getHexWordFromBinary(const string& inputString,const string& separator){', "\n";
   print '		ostringstream oss;', "\n";
   print '		for (int i = 0; i < inputString.length (); i+=8){', "\n";
   print '			bitset<8> b(SPL::Functions::String::subSlice(inputString,i,(i+8)));', "\n";
   print '			if(i > 0){', "\n";
   print '				oss << separator;', "\n";
   print '			}', "\n";
   print '			oss << hex << setfill(\'0\') << setw(2) << uppercase <<  b.to_ulong() ;', "\n";
   print '	    }', "\n";
   print '		return oss.str();', "\n";
   print '	}', "\n";
   print '	*/', "\n";
   print '	/*', "\n";
   print '	 rstring ASCIIToBinaryString(const string& inputString){', "\n";
   print '		ostringstream oss;', "\n";
   print '		for (int i = 0; i < inputString.length (); ++i){', "\n";
   print '	        oss << bitset<8>(inputString[i]);', "\n";
   print '	    }', "\n";
   print '		return oss.str();', "\n";
   print '	}', "\n";
   print '	*/', "\n";
   print '	/*', "\n";
   print '	 rstring IntegerToBinaryString(const int& inputInteger){', "\n";
   print '		ostringstream oss;', "\n";
   print '		oss<< hex << setfill(\'0\') << setw(sizeof(inputInteger)) << uppercase << inputInteger;', "\n";
   print '		return oss.str();', "\n";
   print '	}', "\n";
   print '	*/', "\n";
   print '	/*', "\n";
   print '	 rstring HexStringToBinaryString(const string& inputString){', "\n";
   print '		ostringstream oss;', "\n";
   print '		for (int i = 0; i < inputString.length (); ++i){', "\n";
   print '			oss << HexToBin[inputString [i]];', "\n";
   print '		}', "\n";
   print '		return oss.str();', "\n";
   print '	}', "\n";
   print '	*/', "\n";
   print "\n";
   print '// Constructor', "\n";
   print 'MY_OPERATOR_SCOPE::MY_OPERATOR::MY_OPERATOR()', "\n";
   print '{', "\n";
   print '    // Initialization code goes here', "\n";
   print '}', "\n";
   print "\n";
   print '// Destructor', "\n";
   print 'MY_OPERATOR_SCOPE::MY_OPERATOR::~MY_OPERATOR() ', "\n";
   print '{', "\n";
   print '    // Finalization code goes here', "\n";
   print '}', "\n";
   print "\n";
   print '// Notify port readiness', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::allPortsReady() ', "\n";
   print '{', "\n";
   print '    // Notifies that all ports are ready. No tuples should be submitted before', "\n";
   print '    // this. Source operators can use this method to spawn threads.', "\n";
   print "\n";
   print '    /*', "\n";
   print '      createThreads(1); // Create source thread', "\n";
   print '    */', "\n";
   print '}', "\n";
   print ' ', "\n";
   print '// Notify pending shutdown', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::prepareToShutdown() ', "\n";
   print '{', "\n";
   print '    // This is an asynchronous call', "\n";
   print '}', "\n";
   print "\n";
   print '// Processing for source and threaded operators   ', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(uint32_t idx)', "\n";
   print '{', "\n";
   print '    // A typical implementation will loop until shutdown', "\n";
   print '    /*', "\n";
   print '      while(!getPE().getShutdownRequested()) {', "\n";
   print '          // do work ...', "\n";
   print '      }', "\n";
   print '    */', "\n";
   print '}', "\n";
   print "\n";
   print '// Tuple processing for mutating ports ', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Tuple & tuple, uint32_t port)', "\n";
   print '{', "\n";
   print '	const ';
   print $::inputPortZeroTupleType;
   print '& ';
   print $::inputPortZeroTupleName;
   print ' = static_cast<const ';
   print $::inputPortZeroTupleType;
   print '&>(tuple);', "\n";
   print '	';
   print $::outputPortZeroTupleType;
   print ' ';
   print $::outputPortZeroTupleName;
   print ';', "\n";
   print '	map<string,string> decodedMap;', "\n";
   print '	string  binaryString;', "\n";
   print '	string result;', "\n";
   print "\n";
   print "\n";
   print '//	struct timeval tim;  ', "\n";
   print '//    gettimeofday(&tim, NULL);  ', "\n";
   print '//    double t1=tim.tv_sec+(tim.tv_usec/1000000.0); ', "\n";
   print '    ', "\n";
   print '    ', "\n";
   print '	switch (';
   print $::id->getValueAt(0)->getCppExpression();
   print '){', "\n";
   foreach my $raw (@{$data->{raws}[0]{raw}}) {
   print "\n";
   print '	';
   my $result='';
   print "\n";
   print '		case ';
   print $raw->{id};
   print ' : {', "\n";
   print '			';
   if(lc($raw->{format}) eq 'hex' ){
   print "\n";
   print '				binaryString=Bytes::BytesClass::HexStringToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print ');', "\n";
   print '//				std::bitset<';
   print $raw->{length};
   print '> bits(string(binaryString.rbegin(),binaryString.rend()));', "\n";
   print '			';
   }
   print "\n";
   print '			';
   if(lc($raw->{format}) eq 'bin' ){
   print "\n";
   print '				binaryString=';
   print $::data->getValueAt(0)->getCppExpression();
   print ';', "\n";
   print '//				std::bitset<';
   print $raw->{length};
   print '> bits(binaryString);', "\n";
   print '			';
   }
   print "\n";
   print '			';
   if(lc($raw->{format}) eq 'dec' ){
   print "\n";
   print '				binaryString=Bytes::BytesClass::IntegerToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print ');', "\n";
   print '//				std::bitset<';
   print $raw->{length};
   print '> bits(IntegerToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print '));', "\n";
   print '			';
   }
   print "\n";
   print '			';
   if(lc($raw->{format}) eq 'str' ){
   print "\n";
   print '				binaryString=Bytes::BytesClass::stringToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print ');', "\n";
   print '//				std::bitset<';
   print $raw->{length};
   print '> bits(stringToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print '));', "\n";
   print '			';
   }
   print "\n";
   print '			';
   foreach my $packet (@{$raw->{packet}}) {
   print "\n";
   print '				';
   if(exists ($packet->{function})){
   					$result=$packet->{function};
   				}else{
   					$result="x";
   				}
   				my $f;
   				
   				if(lc($packet->{datatype}) eq 'string' ){
   					$f="Bytes::BytesClass::getASCIIFromBinary(SPL::Functions::String::subSlice(binaryString,$packet->{start},$packet->{start}+$packet->{length}))";
   				}
   				if(lc($packet->{datatype}) eq 'hexword' ){
   					$f="Bytes::BytesClass::getHexWordFromBinary(SPL::Functions::String::subSlice(binaryString,$packet->{start},$packet->{start}+$packet->{length}),\"$packet->{separator}\")";
   				}
   				if(lc($packet->{datatype}) eq 'int' ){
   #					$f="std::bitset<$packet->{length}>(SPL::Functions::String::subSlice(binaryString,$packet->{start},$packet->{start}+$packet->{length})).to_ulong()";
   					$f="Bytes::BytesClass::getIntStringFromBinary(SPL::Functions::String::subSlice(binaryString,$packet->{start},$packet->{start}+$packet->{length}))";
   
   				}
   				if(lc($packet->{datatype}) eq 'long' ){
   					$f="Bytes::BytesClass::getLongStringFromBinaryString(SPL::Functions::String::subSlice(binaryString,0,12))";
   				}
   				$result =~ s/x/$f/g;
   				
   print "\n";
   print '				//';
   print $raw->{name};
   print '(';
   print $raw->{id};
   print ') -> ';
   print $packet->{name};
   print '(';
   print $packet->{id};
   print ')', "\n";
   print '//				std::bitset<';
   print $packet->{length};
   print '> ';
   print $packet->{name};
   print ';//(stringToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print '));', "\n";
   print "\n";
   print '//			    ';
   #for (my $i = 0; $i < $packet->{length};$i++) {
   print "\n";
   print '//			    ';
   #=$packet->{name}
   print '.set(';
   #=$i
   print ',bits[';
   #=$packet->{start}+$i
   print ']);', "\n";
   print '//			    ';
   #}
   print "\n";
   print '				decodedMap["';
   print $packet->{name};
   print '"]=';
   print $result;
   print ';', "\n";
   print '			';
   }
   print "\n";
   print '			break;', "\n";
   print '		}', "\n";
   }
   print "\n";
   print '	}', "\n";
   print "\n";
   print '//	gettimeofday(&tim, NULL);  ', "\n";
   print '//  double t2=tim.tv_sec+(tim.tv_usec/1000000.0);  ', "\n";
   print '//	printf("%.6lf seconds taken to extract data\\n", t2-t1); ', "\n";
   print "\n";
   print '      OPort0Type otuple;', "\n";
   print "\n";
   print '	', "\n";
   print '	';
   	my $decodedAttributeName=$::decoded->getValueAt(0)->getSPLExpression();
   		$decodedAttributeName =~ s/"//g;
   		foreach my $attribute (@{$::outputPortZero->getAttributes()}) { 
   		my $name = $attribute->getName();
   		my $inputAttr=$::inputPortZero->getAttributeByName($name);
   		if ($inputAttr ne ''){
   		
   print "\n";
   print '		otuple.set_';
   print $name;
   print '( ';
   print $::inputPortZeroTupleName;
   print '.get_';
   print $name;
   print '());  ', "\n";
   print '		';
   }
   print "\n";
   print '		';
   		if ($name  eq $decodedAttributeName) { 
   print "\n";
   print '			otuple.set_';
   print $name;
   print '( decodedMap);  ', "\n";
   print '		';
   }
   		}
   print ' ', "\n";
   print '      submit(otuple, 0); // submit to output port 0', "\n";
   print '	submit(Punctuation::WindowMarker, 0);', "\n";
   print '}', "\n";
   print "\n";
   print '// Tuple processing for non-mutating ports', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Tuple const & tuple, uint32_t port)', "\n";
   print '{', "\n";
   print '	const ';
   print $::inputPortZeroTupleType;
   print '& ';
   print $::inputPortZeroTupleName;
   print ' = static_cast<const ';
   print $::inputPortZeroTupleType;
   print '&>(tuple);', "\n";
   print '	';
   print $::outputPortZeroTupleType;
   print ' ';
   print $::outputPortZeroTupleName;
   print ';', "\n";
   print '	map<string,string> decodedMap;', "\n";
   print '	string  binaryString;', "\n";
   print '	string result;', "\n";
   print "\n";
   print "\n";
   print '//	struct timeval tim;  ', "\n";
   print '//    gettimeofday(&tim, NULL);  ', "\n";
   print '//    double t1=tim.tv_sec+(tim.tv_usec/1000000.0); ', "\n";
   print '    ', "\n";
   print '    ', "\n";
   print '	switch (';
   print $::id->getValueAt(0)->getCppExpression();
   print '){', "\n";
   foreach my $raw (@{$data->{raws}[0]{raw}}) {
   print "\n";
   print '	';
   my $result='';
   print "\n";
   print '		case ';
   print $raw->{id};
   print ' : {', "\n";
   print '			';
   if(lc($raw->{format}) eq 'hex' ){
   print "\n";
   print '				binaryString=Bytes::BytesClass::HexStringToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print ');', "\n";
   print '//				std::bitset<';
   print $raw->{length};
   print '> bits(string(binaryString.rbegin(),binaryString.rend()));', "\n";
   print '			';
   }
   print "\n";
   print '			';
   if(lc($raw->{format}) eq 'bin' ){
   print "\n";
   print '				binaryString=';
   print $::data->getValueAt(0)->getCppExpression();
   print ';', "\n";
   print '//				std::bitset<';
   print $raw->{length};
   print '> bits(binaryString);', "\n";
   print '			';
   }
   print "\n";
   print '			';
   if(lc($raw->{format}) eq 'dec' ){
   print "\n";
   print '				binaryString=Bytes::BytesClass::IntegerToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print ');', "\n";
   print '//				std::bitset<';
   print $raw->{length};
   print '> bits(IntegerToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print '));', "\n";
   print '			';
   }
   print "\n";
   print '			';
   if(lc($raw->{format}) eq 'str' ){
   print "\n";
   print '				binaryString=Bytes::BytesClass::stringToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print ');', "\n";
   print '//				std::bitset<';
   print $raw->{length};
   print '> bits(stringToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print '));', "\n";
   print '			';
   }
   print "\n";
   print '			';
   foreach my $packet (@{$raw->{packet}}) {
   print "\n";
   print '				';
   if(exists ($packet->{function})){
   					$result=$packet->{function};
   				}else{
   					$result="x";
   				}
   				my $f;
   				
   				if(lc($packet->{datatype}) eq 'string' ){
   					$f="Bytes::BytesClass::getASCIIFromBinary(SPL::Functions::String::subSlice(binaryString,$packet->{start},$packet->{start}+$packet->{length}))";
   				}
   				if(lc($packet->{datatype}) eq 'hexword' ){
   					$f="Bytes::BytesClass::getHexWordFromBinary(SPL::Functions::String::subSlice(binaryString,$packet->{start},$packet->{start}+$packet->{length}),\"$packet->{separator}\")";
   				}
   				if(lc($packet->{datatype}) eq 'int' ){
   #					$f="std::bitset<$packet->{length}>(SPL::Functions::String::subSlice(binaryString,$packet->{start},$packet->{start}+$packet->{length})).to_ulong()";
   					$f="Bytes::BytesClass::getIntStringFromBinary(SPL::Functions::String::subSlice(binaryString,$packet->{start},$packet->{start}+$packet->{length}))";
   
   				}
   				if(lc($packet->{datatype}) eq 'long' ){
   					$f="Bytes::BytesClass::getLongStringFromBinaryString(SPL::Functions::String::subSlice(binaryString,0,12))";
   				}
   				$result =~ s/x/$f/g;
   				
   print "\n";
   print '				//';
   print $raw->{name};
   print '(';
   print $raw->{id};
   print ') -> ';
   print $packet->{name};
   print '(';
   print $packet->{id};
   print ')', "\n";
   print '//				std::bitset<';
   print $packet->{length};
   print '> ';
   print $packet->{name};
   print ';//(stringToBinaryString(';
   print $::data->getValueAt(0)->getCppExpression();
   print '));', "\n";
   print "\n";
   print '//			    ';
   #for (my $i = 0; $i < $packet->{length};$i++) {
   print "\n";
   print '//			    ';
   #=$packet->{name}
   print '.set(';
   #=$i
   print ',bits[';
   #=$packet->{start}+$i
   print ']);', "\n";
   print '//			    ';
   #}
   print "\n";
   print '				decodedMap["';
   print $packet->{name};
   print '"]=';
   print $result;
   print ';', "\n";
   print '			';
   }
   print "\n";
   print '			break;', "\n";
   print '		}', "\n";
   }
   print "\n";
   print '	}', "\n";
   print "\n";
   print '//	gettimeofday(&tim, NULL);  ', "\n";
   print '//  double t2=tim.tv_sec+(tim.tv_usec/1000000.0);  ', "\n";
   print '//	printf("%.6lf seconds taken to extract data\\n", t2-t1); ', "\n";
   print "\n";
   print '      OPort0Type otuple;', "\n";
   print "\n";
   print '	', "\n";
   print '	';
   	my $decodedAttributeName=$::decoded->getValueAt(0)->getSPLExpression();
   		$decodedAttributeName =~ s/"//g;
   		foreach my $attribute (@{$::outputPortZero->getAttributes()}) { 
   		my $name = $attribute->getName();
   		my $inputAttr=$::inputPortZero->getAttributeByName($name);
   		if ($inputAttr ne ''){
   		
   print "\n";
   print '		otuple.set_';
   print $name;
   print '( ';
   print $::inputPortZeroTupleName;
   print '.get_';
   print $name;
   print '());  ', "\n";
   print '		';
   }
   print "\n";
   print '		';
   		if ($name  eq $decodedAttributeName) { 
   print "\n";
   print '			otuple.set_';
   print $name;
   print '( decodedMap);  ', "\n";
   print '		';
   }
   		}
   print ' ', "\n";
   print '      submit(otuple, 0); // submit to output port 0', "\n";
   print '	submit(Punctuation::WindowMarker, 0);', "\n";
   print '}', "\n";
   print "\n";
   print '// Punctuation processing', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Punctuation const & punct, uint32_t port)', "\n";
   print '{', "\n";
   print '    /*', "\n";
   print '      if(punct==Punctuation::WindowMarker) {', "\n";
   print '        // ...;', "\n";
   print '      } else if(punct==Punctuation::FinalMarker) {', "\n";
   print '        // ...;', "\n";
   print '      }', "\n";
   print '    */', "\n";
   print '}', "\n";
   print "\n";
   SPL::CodeGen::implementationEpilogue($model);
   print "\n";
   print "\n";
   CORE::exit $SPL::CodeGen::USER_ERROR if ($SPL::CodeGen::sawError);
}
1;
