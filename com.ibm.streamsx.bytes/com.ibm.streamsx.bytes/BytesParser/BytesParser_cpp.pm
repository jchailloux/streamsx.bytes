
package BytesParser_cpp;
use strict; use Cwd 'realpath';  use File::Basename;  use lib dirname(__FILE__);  use SPL::Operator::Instance::OperatorInstance; use SPL::Operator::Instance::Annotation; use SPL::Operator::Instance::Context; use SPL::Operator::Instance::Expression; use SPL::Operator::Instance::ExpressionTree; use SPL::Operator::Instance::ExpressionTreeEvaluator; use SPL::Operator::Instance::ExpressionTreeVisitor; use SPL::Operator::Instance::ExpressionTreeCppGenVisitor; use SPL::Operator::Instance::InputAttribute; use SPL::Operator::Instance::InputPort; use SPL::Operator::Instance::OutputAttribute; use SPL::Operator::Instance::OutputPort; use SPL::Operator::Instance::Parameter; use SPL::Operator::Instance::StateVariable; use SPL::Operator::Instance::TupleValue; use SPL::Operator::Instance::Window; 
sub main::generate($$) {
   my ($xml, $signature) = @_;  
   print "// $$signature\n";
   my $model = SPL::Operator::Instance::OperatorInstance->new($$xml);
   unshift @INC, dirname ($model->getContext()->getOperatorDirectory()) . "/../impl/nl/include";
   $SPL::CodeGenHelper::verboseMode = $model->getContext()->isVerboseModeOn();
   print '/* Additional includes go here */', "\n";
   print '#include <jansson.h>', "\n";
   print '#include <boost/algorithm/string.hpp>', "\n";
   print '#include <iomanip>', "\n";
   print '#include <BytesFunctions.h>', "\n";
   print "\n";
   SPL::CodeGen::implementationPrologue($model);
   print "\n";
   use BytesParserCommon;
   BytesParserCommon::Init($model);
   my $isInConsistentRegion = $model->getContext()->getOptionalContext("ConsistentRegion");
   #Need to check if the output schema is ExtractedParameter
   print "\n";
   print "\n";
   print 'void readParameterDef(ParameterDef &p,json_t *element){', "\n";
   print '	SPLAPPTRC(L_TRACE, "->readParameterDef", SPL_OPER_DBG);', "\n";
   print '	json_t *value;', "\n";
   print '    const char *key;', "\n";
   print '	json_object_foreach(element, key, value) {', "\n";
   print '        if(strcmp(key,"byte") ==0){', "\n";
   print '        	p.byteNumber=json_integer_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"name") ==0){', "\n";
   print '        	p.name=json_string_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"description") ==0){', "\n";
   print '        	p.description=json_string_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"unit") ==0){', "\n";
   print '        	p.unit=json_string_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"format") ==0){', "\n";
   print '        	p.format=json_string_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"start") ==0){', "\n";
   print '        	p.start=json_integer_value(value)-1;', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"length") ==0){', "\n";
   print '        	p.length=json_integer_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"factor") ==0){', "\n";
   print '        	p.factor=json_real_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"offset") ==0){', "\n";
   print '        	p.offset=json_real_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"limit") ==0){', "\n";
   print '        	p.limit=json_integer_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"endianness") ==0){', "\n";
   print '            if(strcmp(json_string_value(value),"LittleEndian") ==0){', "\n";
   print '				p.endianness=false;', "\n";
   print '            }else{', "\n";
   print '				p.endianness=true;', "\n";
   print '            }', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"signed") ==0){', "\n";
   print '        	p.isSigned=json_is_true(value);', "\n";
   print '        }', "\n";
   print '	}', "\n";
   print '	SPLAPPTRC(L_TRACE, "<-readParameterDef", SPL_OPER_DBG);', "\n";
   print '}', "\n";
   print 'void readMultiplexDef(MultiplexDef &multiplex,json_t *element){', "\n";
   print '	SPLAPPTRC(L_TRACE, "->readMultiplexDef", SPL_OPER_DBG);', "\n";
   print '	json_t *value;', "\n";
   print '    const char *key;', "\n";
   print '//	json_t *packet=NULL;', "\n";
   print '    json_object_foreach(element, key, value) {', "\n";
   print '        if(strcmp(key,"inlinevalue") ==0){', "\n";
   print '        	multiplex.inlineValue=json_integer_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"parameters") ==0){', "\n";
   print '        	if(!json_is_array(value)){', "\n";
   print '        		return;', "\n";
   print '        	}', "\n";
   print "\n";
   print '        	size_t size = json_array_size(value);', "\n";
   print '	        for (size_t i = 0; i < size; i++) {', "\n";
   print '	        	ParameterDef p;', "\n";
   print '	        	readParameterDef(p,json_array_get(value, i));		//Store the packet part to ensure that we read all elements before starting to parse packets', "\n";
   print '	        	multiplex.parameters.push_back(p);', "\n";
   print '			}', "\n";
   print '        }', "\n";
   print '	}', "\n";
   print '//    readPacketLevel(message,packet);', "\n";
   print '//    o.messages.push_back(message);', "\n";
   print '	SPLAPPTRC(L_TRACE, "<-readMultiplexDef", SPL_OPER_DBG);', "\n";
   print '}', "\n";
   print "\n";
   print 'void readMessageDef(ObjectDef &o,json_t *element){', "\n";
   print '	SPLAPPTRC(L_TRACE, "->readMessageDef", SPL_OPER_DBG);', "\n";
   print '	json_t *value;', "\n";
   print '    const char *key;', "\n";
   print '	MessageDef message;', "\n";
   print '//	json_t *packet=NULL;', "\n";
   print '    json_object_foreach(element, key, value) {', "\n";
   print '        if(strcmp(key,"name") ==0){', "\n";
   print '        	message.name=json_string_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"bytes") ==0){', "\n";
   print '        	message.bytes=json_integer_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"byte container length") ==0){', "\n";
   print '        	message.byteContainerLength=json_integer_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"endianness") ==0){', "\n";
   print '            if(strcmp(json_string_value(value),"LittleEndian") ==0){', "\n";
   print '				message.endianness=false;', "\n";
   print '            }else{', "\n";
   print '				message.endianness=true;', "\n";
   print '            }', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"byte length") ==0){', "\n";
   print '        	message.byteLength=json_integer_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"elapse") ==0){', "\n";
   print '        	message.elapse=json_real_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"have identifier") ==0){', "\n";
   print '        	message.haveIdentifier=json_is_true(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"identifier") ==0){', "\n";
   print '        	message.identifier=json_string_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"inline parameter") ==0){', "\n";
   print '        	ParameterDef p;', "\n";
   print '        	readParameterDef(p,value);		//Store the packet part to ensure that we read all elements before starting to parse packets', "\n";
   print '        	message.inlineParameter=p;', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"multiplex") ==0){', "\n";
   print '        	if(!json_is_array(value)){', "\n";
   print '        		return;', "\n";
   print '        	}', "\n";
   print "\n";
   print '        	size_t size = json_array_size(value);', "\n";
   print '	        for (size_t i = 0; i < size; i++) {', "\n";
   print '	        	MultiplexDef m;', "\n";
   print '	        	readMultiplexDef(m,json_array_get(value, i));', "\n";
   print '	        	message.multiplex.push_back(m);', "\n";
   print '			}', "\n";
   print '        }', "\n";
   print '	}', "\n";
   print '//    readPacketLevel(message,packet);', "\n";
   print '    o.messages.push_back(message);', "\n";
   print '	SPLAPPTRC(L_TRACE, "<-readMessageDef", SPL_OPER_DBG);', "\n";
   print '}', "\n";
   print 'void readDictionnaryDef(ObjectDef &o,json_t *element){', "\n";
   print '	SPLAPPTRC(L_TRACE, "->readDictionnaryDef", SPL_OPER_DBG);', "\n";
   print '	json_t *value;', "\n";
   print '    const char *key;', "\n";
   print '	string k;', "\n";
   print '	string v;', "\n";
   print '    json_object_foreach(element, key, value) {', "\n";
   print '        if(strcmp(key,"ascii") ==0){', "\n";
   print '        	k=json_string_value(value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"binary") ==0){', "\n";
   print '        	v=json_string_value(value);', "\n";
   print '        }', "\n";
   print '        o.dictionnary[k.c_str()[0]]=v;', "\n";
   print '    }', "\n";
   print '	SPLAPPTRC(L_TRACE, "<-readDictionnaryDef", SPL_OPER_DBG);', "\n";
   print '}', "\n";
   print "\n";
   print 'void readObjectDef(ObjectDef &o,json_t *element){', "\n";
   print '	SPLAPPTRC(L_TRACE, "->readObjectDef", SPL_OPER_DBG);', "\n";
   print '	json_t *value;', "\n";
   print '    const char *key;', "\n";
   print '    json_object_foreach(element, key, value) {', "\n";
   print '        if(strcmp(key,"Object") ==0){', "\n";
   print '        	SPLAPPTRC(L_DEBUG, "Object found", SPL_OPER_DBG);', "\n";
   print '        	readObjectDef(o,value);', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"name") ==0){', "\n";
   print '        	o.name = json_string_value(value);', "\n";
   print "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"messages") ==0){', "\n";
   print '        	if(!json_is_array(value)){', "\n";
   print '        		return;', "\n";
   print '        	}', "\n";
   print "\n";
   print '        	size_t size = json_array_size(value);', "\n";
   print '	        for (size_t i = 0; i < size; i++) {', "\n";
   print '	        	readMessageDef(o,json_array_get(value, i));', "\n";
   print '			}', "\n";
   print '        }', "\n";
   print '        if(strcmp(key,"dictionnary") ==0){', "\n";
   print '        	if(!json_is_array(value)){', "\n";
   print '        		return;', "\n";
   print '        	}', "\n";
   print "\n";
   print '        	size_t size = json_array_size(value);', "\n";
   print '	        for (size_t i = 0; i < size; i++) {', "\n";
   print '	        	readDictionnaryDef(o,json_array_get(value, i));', "\n";
   print '			}', "\n";
   print '        }', "\n";
   print '	}', "\n";
   print '	SPLAPPTRC(L_TRACE, "<-readObjectDef", SPL_OPER_DBG);', "\n";
   print '}', "\n";
   print "\n";
   print "\n";
   print 'void printParameterDef(ParameterDef p,string indent){', "\n";
   print '	SPLAPPTRC(L_DEBUG, indent <<"--------Parameter-------- ", SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" name : "<< p.name, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" desc : "<< p.description, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" unit : "<< p.unit, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" signed : "<<p.isSigned , SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" endianness : "<< p.endianness, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" byte : "<< p.byteNumber, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" start : "<< p.start, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" length : "<<p.length, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG, indent <<" format : "<< p.format, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG, indent <<" factor : "<< p.factor, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG, indent <<" offset : "<< p.offset, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" limit : "<< p.limit, SPL_OPER_DBG);', "\n";
   print '}', "\n";
   print 'void printDictionnaryDef(ObjectDef &o){', "\n";
   print '	SPLAPPTRC(L_DEBUG,  "--------Dictionnary-------- ", SPL_OPER_DBG);', "\n";
   print '    for ( std::map< char, string, std::less< int > >::const_iterator iter = o.dictionnary.begin();iter != o.dictionnary.end(); ++iter )', "\n";
   print '    	SPLAPPTRC(L_DEBUG, "\\t"<< iter->first << "\\t-->\\t" << iter->second , SPL_OPER_DBG);', "\n";
   print '}', "\n";
   print 'void printMultiplexDef(MultiplexDef multiplex,string indent){', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" ---------------- ", SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" inline value : "<<multiplex.inlineValue, SPL_OPER_DBG);', "\n";
   print '	for(unsigned int k=0; k < multiplex.parameters.size(); k++){', "\n";
   print '		printParameterDef(multiplex.parameters[k],indent+"\\t");', "\n";
   print '	}', "\n";
   print '}', "\n";
   print 'void printMessageDef(MessageDef message,string indent){', "\n";
   print "\n";
   print '	SPLAPPTRC(L_DEBUG, indent <<" message name : " << message.name, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" message desc : " << message.description, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" message byte : " << message.bytes, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" message length : " << message.byteLength, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" message container : " << message.byteContainerLength, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" message endianness : " << message.endianness, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" message elapse : " << message.elapse, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" message have identifier : " << message.haveIdentifier, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" message identifier : " << message.identifier, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG,  indent <<" message inlineParameter : " , SPL_OPER_DBG);', "\n";
   print '	printParameterDef(message.inlineParameter,indent+"\\t");', "\n";
   print '	for(unsigned int i=0; i < message.multiplex.size(); i++){', "\n";
   print '		printMultiplexDef(message.multiplex[i],indent+"\\t");', "\n";
   print '	}', "\n";
   print "\n";
   print '}', "\n";
   print 'void printObjectDef(ObjectDef &o){', "\n";
   print '	SPLAPPTRC(L_DEBUG,  "Object : " << o.name, SPL_OPER_DBG);', "\n";
   print '	SPLAPPTRC(L_DEBUG, "Number of messages : " << o.messages.size(), SPL_OPER_DBG);', "\n";
   print '	for(unsigned int i=0; i < o.messages.size(); i++){', "\n";
   print '		printMessageDef( o.messages[i],"\\t");', "\n";
   print '	}', "\n";
   print '	printDictionnaryDef(o);', "\n";
   print '}', "\n";
   print 'void loadExtractorSchema(ObjectDef &o,string fileName){', "\n";
   print '	SPLAPPTRC(L_TRACE, "->loadExtractorSchema", SPL_OPER_DBG);', "\n";
   print '    ready=false;', "\n";
   print '	json_t *value;', "\n";
   print '	json_error_t error;', "\n";
   print '	value = json_load_file(fileName.c_str(), 0, &error);', "\n";
   print '	if(!value){', "\n";
   print '		SPLAPPTRC(L_ERROR, "error: on line " << ": " << error.text, SPL_OPER_DBG);', "\n";
   print '		return;', "\n";
   print '	}', "\n";
   print '	SPLAPPTRC(L_DEBUG, "JSON read", SPL_OPER_DBG);', "\n";
   print '	readObjectDef(o,value);', "\n";
   print '	printObjectDef(o);', "\n";
   print '    ready=true;', "\n";
   print '	SPLAPPTRC(L_TRACE, "<-loadExtractorSchema", SPL_OPER_DBG);', "\n";
   print '}', "\n";
   print 'void reverseBinary(boost::dynamic_bitset<> &from,boost::dynamic_bitset<> &to){', "\n";
   print '	unsigned int sz=from.size();', "\n";
   print '	for (unsigned int i = 0; i < sz; i++)', "\n";
   print '		to[(sz-1) - i] = from[i];', "\n";
   print '}', "\n";
   print 'void reverseBinary(boost::dynamic_bitset<> &to){', "\n";
   print '	boost::dynamic_bitset<> from(to);', "\n";
   print '	unsigned int sz=from.size();', "\n";
   print '	for (unsigned int i = 0; i < sz; i++)', "\n";
   print '		to[(sz-1) - i] = from[i];', "\n";
   print '}', "\n";
   print '// Constructor', "\n";
   print 'MY_OPERATOR_SCOPE::MY_OPERATOR::MY_OPERATOR()', "\n";
   print '{', "\n";
   print '    // Initialization code goes here', "\n";
   print '	loadExtractorSchema(object,';
   print $::file->getValueAt(0)->getSPLExpression();
   print ');', "\n";
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
   print "\n";
   print "\n";
   print '	const ';
   print $::inputPortZeroTupleType;
   print '& ';
   print $::inputPortZeroTupleName;
   print ' = static_cast<const ';
   print $::inputPortZeroTupleType;
   print '&>(tuple);', "\n";
   print '	OPort0Type otuple;', "\n";
   print "\n";
   print '	//Assign maching attributes from input tuple to output tuple', "\n";
   print '	otuple.assignFrom(tuple,false);', "\n";
   print '	', "\n";
   print '	/*', "\n";
   print '	 * Wait while loading le definition\'s file', "\n";
   print '	 * If a a new definition\'s file is received on the optional input port 1', "\n";
   print '	 */', "\n";
   print '//	while(!ready){', "\n";
   print '//		cout << "Waiting ...." <<endl;', "\n";
   print '//		::SPL::Functions::Utility::block(1);', "\n";
   print '//	}', "\n";
   print "\n";
   print "\n";
   print '	/*', "\n";
   print '	 * Make the input message a String', "\n";
   print '	 */', "\n";
   print '	string inputMessage ;', "\n";
   print '	 	 ';
   	 	 my $inputList;
   	 	 foreach my $attribute (@{$::inputPortZero->getAttributes()}) {          
   	 		 my $name = $attribute->getName();
   	 		 my ($a) = $::message->getValueAt(0)->getSPLExpression() =~ /((\.[^.\s]+)+)$/;
   	 		 $a =~ s/\.//g;
   	 		 print "//$name\n";
   			 print "//$a\n";
   			 if($name eq $a){
   				my $splType = $attribute->getSPLType();
   				if(SPL::CodeGen::Type::isBlob($splType)){
   		
   print "\n";
   print '	ostringstream oss;', "\n";
   print '	oss << ';
   print $::message->getValueAt(0)->getCppExpression();
   print ';', "\n";
   print '	inputMessage= oss.str();', "\n";
   print '	   	';
   	    	}
   	    	if(SPL::CodeGen::Type::isString($splType)){
   	    
   print "\n";
   print '	inputMessage= ';
   print $::message->getValueAt(0)->getCppExpression();
   print ';', "\n";
   print '	    ';
   	    	}
      		last;
       	}
     	}
   	
   print "\n";
   print "\n";
   print '	SPLAPPTRC(L_DEBUG, "Input received " << ": " << inputMessage, SPL_OPER_DBG);', "\n";
   print "\n";
   print '	', "\n";
   print "\n";
   print '	string extractedIdentifier;', "\n";
   print '	bool isMessageDefFound=false;', "\n";
   print '	bool isMultiplexDefFound=false;', "\n";
   print '	/*', "\n";
   print '	 * Search for the message that could match the identifier', "\n";
   print '	 */', "\n";
   print '	for(int messageCounter=0; messageCounter < object.messages.size(); messageCounter++){', "\n";
   print "\n";
   print '		/*', "\n";
   print '		 * Extract the identifier from message or use the one passed as attribute', "\n";
   print '		 */', "\n";
   print '		if(object.messages[messageCounter].haveIdentifier){', "\n";
   print '			SPLAPPTRC(L_DEBUG, "Having a delimiter. Will extract and remove it from the input  " << ": " << inputMessage, SPL_OPER_DBG);', "\n";
   print '			extractedIdentifier=SPL::Functions::String::subSlice (inputMessage, 0,object.messages[messageCounter].identifier.length());', "\n";
   print '			SPLAPPTRC(L_DEBUG, "Delimiter extracted " << ": " << extractedIdentifier, SPL_OPER_DBG);', "\n";
   print '		}else {', "\n";
   print '			';
   			if ($::identifier  ne 'NONE') {
   			
   print "\n";
   print '				extractedIdentifier=';
   print $::identifier->getValueAt(0)->getCppExpression();
   print ';', "\n";
   print '			';
   			}else {
   			
   print "\n";
   print '				extractedIdentifier=object.messages[messageCounter].identifier;', "\n";
   print '			';
   			}
   			
   print "\n";
   print '		}', "\n";
   print "\n";
   print '		int start;', "\n";
   print '		/*', "\n";
   print '		 * Match the identifier and remove', "\n";
   print '		 */', "\n";
   print '		if(boost::iequals(extractedIdentifier, object.messages[messageCounter].identifier)){', "\n";
   print '			isMessageDefFound=true;', "\n";
   print '			';
   			if ($::identifier  ne 'NONE') {
   			
   print "\n";
   print '				start=0;', "\n";
   print '			';
   			}else {
   			
   print "\n";
   print '				start=object.messages[messageCounter].haveIdentifier ?object.messages[messageCounter].identifier.length():0;;', "\n";
   print '			';
   			}
   			
   print "\n";
   print '			if(object.messages[messageCounter].bytes == 1){', "\n";
   print '				inputMessage=SPL::Functions::String::subSlice (inputMessage, start,inputMessage.length());', "\n";
   print '				SPLAPPTRC(L_DEBUG, "New input " << ": " << inputMessage, SPL_OPER_DBG);', "\n";
   print '			}', "\n";
   print '			/*', "\n";
   print '			 * ', "\n";
   print '			 */', "\n";
   print '		    boost::dynamic_bitset<> binary;', "\n";
   print '			if(object.dictionnary.size() > 0){', "\n";
   print '				binary= boost::dynamic_bitset<>(com::ibm::streamsx::bytes::conversion::convertFromHexToBinaryUsingDictionnary(inputMessage,object.dictionnary));', "\n";
   print '			}else{', "\n";
   print '				binary= boost::dynamic_bitset<>(com::ibm::streamsx::bytes::conversion::convertFromHexToBinary(inputMessage));', "\n";
   print '			}', "\n";
   print '			SPLAPPTRC(L_DEBUG, "Binary : "<<binary, SPL_OPER_DBG);', "\n";
   print '			otuple.set_objectName(object.name);', "\n";
   print '			otuple.set_messageName( object.messages[messageCounter].name);', "\n";
   print '			otuple.set_messageDescription( object.messages[messageCounter].description);', "\n";
   print '			/*', "\n";
   print '			 * Do we have an inline parameter : multiplex ?', "\n";
   print '			 */', "\n";
   print '			int inlineValue=0;', "\n";
   print '			if(!object.messages[messageCounter].inlineParameter.name.empty()){', "\n";
   print '				/*', "\n";
   print '				 * inline parameter', "\n";
   print '				 */', "\n";
   print '				boost::dynamic_bitset<> extracted;', "\n";
   print '			    extracted=(binary>>(binary.size()-(object.messages[messageCounter].inlineParameter.start+object.messages[messageCounter].inlineParameter.length)));', "\n";
   print '				extracted.resize(object.messages[messageCounter].inlineParameter.length);', "\n";
   print '				inlineValue=extracted.to_ulong();', "\n";
   print '			}', "\n";
   print '			SPLAPPTRC(L_DEBUG,"inlineValue to look for : "<<inlineValue, SPL_OPER_DBG);', "\n";
   print '			for(int multiplexCounter=0; multiplexCounter < object.messages[messageCounter].multiplex.size(); multiplexCounter++){', "\n";
   print '				if(object.messages[messageCounter].multiplex[multiplexCounter].inlineValue == inlineValue){', "\n";
   print '					isMultiplexDefFound=true;', "\n";
   print '					/*', "\n";
   print '					 * Multiplex found', "\n";
   print '					 */', "\n";
   print '					SPLAPPTRC(L_DEBUG,"multiplex found : "<< object.messages[messageCounter].multiplex[multiplexCounter].inlineValue, SPL_OPER_DBG);', "\n";
   print '					for(int parameterCounter=0; parameterCounter < object.messages[messageCounter].multiplex[multiplexCounter].parameters.size(); parameterCounter++){', "\n";
   print '						SPLAPPTRC(L_DEBUG,"param to extract : "<< object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].name, SPL_OPER_DBG);', "\n";
   print '						/*', "\n";
   print '						 * Need to extract the byte, rotate, reduce', "\n";
   print '						 */', "\n";
   print '						boost::dynamic_bitset<> byte;', "\n";
   print '					    byte=(binary>>(binary.size()-(object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].byteNumber*object.messages[messageCounter].byteContainerLength)));', "\n";
   print '						byte.resize(object.messages[messageCounter].byteContainerLength);', "\n";
   print '						SPLAPPTRC(L_DEBUG,"byte extracted : "<< byte, SPL_OPER_DBG);', "\n";
   print '						/*', "\n";
   print '						 * Rotate the byte to make it "BigEndian"', "\n";
   print '						 */', "\n";
   print '						if(!object.messages[messageCounter].endianness){', "\n";
   print '							byte=	(byte >> (byte.size()-(object.messages[messageCounter].byteContainerLength/2))) | (byte << (object.messages[messageCounter].byteContainerLength/2));', "\n";
   print '							SPLAPPTRC(L_DEBUG,"byte rotated : "<< byte, SPL_OPER_DBG);', "\n";
   print '						}', "\n";
   print '								', "\n";
   print '						boost::dynamic_bitset<> reduced(byte);', "\n";
   print '//						reduced=	(byte >> (byte.size()-(object.messages[messageCounter].byteLength))) | (byte << (byte.size()-(object.messages[messageCounter].byteLength)));', "\n";
   print '//						reduced=	(byte >> (byte.size()-(object.messages[messageCounter].byteLength))) | (byte << (byte.size()-(object.messages[messageCounter].byteLength)));', "\n";
   print '						SPLAPPTRC(L_DEBUG,"byte moved befor resize : "<< reduced, SPL_OPER_DBG);', "\n";
   print '						reduced.resize(object.messages[messageCounter].byteLength);', "\n";
   print '						SPLAPPTRC(L_DEBUG,"byte resized : "<< reduced, SPL_OPER_DBG);', "\n";
   print '						/*', "\n";
   print '						 * If MSB on the right (LittleEndian) reverse bits to make it BigEndian ', "\n";
   print '						 */', "\n";
   print '						if(!object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].endianness){', "\n";
   print '							reverseBinary(reduced);', "\n";
   print '							SPLAPPTRC(L_DEBUG,"bits extracted reversed : "<< reduced, SPL_OPER_DBG);', "\n";
   print '						}', "\n";
   print '						/*', "\n";
   print '						 * Extract bits from the byte', "\n";
   print '						 */', "\n";
   print '						boost::dynamic_bitset<> extracted(reduced);', "\n";
   print '						/*', "\n";
   print '						 * Compute how many bits we have to move to have the value', "\n";
   print '						 */', "\n";
   print '						int move = object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].start+object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].length;', "\n";
   print '						if(move == extracted.size())', "\n";
   print '							move = object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].length;', "\n";
   print '						/*', "\n";
   print '						 * Move bits and resize', "\n";
   print '						 */', "\n";
   print '					    extracted=(extracted>>(extracted.size()-move));', "\n";
   print '						extracted.resize(object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].length);', "\n";
   print '						SPLAPPTRC(L_DEBUG,"bits extracted : "<< extracted, SPL_OPER_DBG);', "\n";
   print '						otuple.set_parameterName( object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].name);', "\n";
   print '						otuple.set_parameterDescription( object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].description);', "\n";
   print '						otuple.set_parameterFormat( object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].format);', "\n";
   print '						otuple.set_parameterFactor( object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].factor);', "\n";
   print '						otuple.set_parameterOffset( object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].offset);', "\n";
   print '						otuple.set_parameterLimit( object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].limit);', "\n";
   print '						otuple.set_parameterUnit( object.messages[messageCounter].multiplex[multiplexCounter].parameters[parameterCounter].unit);', "\n";
   print '						ostringstream oss;', "\n";
   print '						oss<<extracted;', "\n";
   print '						otuple.set_parameterBinaryString( oss.str());', "\n";
   print '						submit(otuple,0);', "\n";
   print '					}', "\n";
   print '				}else{', "\n";
   print '					SPLAPPTRC(L_DEBUG,"multiplex not found : "<< object.messages[messageCounter].multiplex[multiplexCounter].inlineValue, SPL_OPER_DBG);', "\n";
   print '					continue;', "\n";
   print '				}', "\n";
   print '			}', "\n";
   print '			if(!(isMessageDefFound && isMultiplexDefFound)){', "\n";
   print '				submit(tuple,1);', "\n";
   print '			}', "\n";
   print '			break;', "\n";
   print '		}else{', "\n";
   print '			continue;', "\n";
   print '		}', "\n";
   print '	}', "\n";
   print '	submit(Punctuation::WindowMarker,0);', "\n";
   print '}', "\n";
   print "\n";
   print '// Tuple processing for non-mutating ports', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Tuple const & tuple, uint32_t port)', "\n";
   print '{', "\n";
   print '//	const ';
   print $::inputPortZeroTupleType;
   print '& ';
   print $::inputPortZeroTupleName;
   print ' = static_cast<const ';
   print $::inputPortZeroTupleType;
   print '&>(tuple);', "\n";
   print '//	OPort0Type otuple;', "\n";
   print '//	//Assign maching attributes from input tuple to output tuple', "\n";
   print '//	otuple.assignFrom(tuple,false);', "\n";
   print '//	cout << ';
   print $::message->getValueAt(0)->getCppExpression();
   print ' << endl;', "\n";
   print '}', "\n";
   print "\n";
   print '// Punctuation processing', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Punctuation const & punct, uint32_t port)', "\n";
   print '{', "\n";
   print "\n";
   print '	if(punct==Punctuation::FinalMarker) {', "\n";
   print '		submit(Punctuation::FinalMarker,0);', "\n";
   print '	}', "\n";
   print '	/*', "\n";
   print '      if(punct==Punctuation::WindowMarker) {', "\n";
   print '        // ...;', "\n";
   print '      } else if(punct==Punctuation::FinalMarker) {', "\n";
   print '        // ...;', "\n";
   print '      }', "\n";
   print '    */', "\n";
   print '}', "\n";
   print "\n";
   if ($isInConsistentRegion) {
   print "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::checkpoint(Checkpoint & ckpt)', "\n";
   print '{', "\n";
   print '// TODO: persist state when called.', "\n";
   print 'SPLAPPTRC(L_TRACE, "Checkpoint: " << ckpt.getSequenceId(), "CONSISTENT");', "\n";
   print '}', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::reset(Checkpoint & ckpt)', "\n";
   print '{', "\n";
   print '// TODO: Restore state from checkpoint when called', "\n";
   print 'SPLAPPTRC(L_TRACE, "Reset: " << ckpt.getSequenceId(), "CONSISTENT");', "\n";
   print '}', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::resetToInitialState()', "\n";
   print '{', "\n";
   print '// TODO: Reset to operator initial state when called', "\n";
   print 'SPLAPPTRC(L_TRACE, "Reset to Initial State. ", "CONSISTENT");', "\n";
   print '// may have to undo any state changes during the processing', "\n";
   print '}', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::drain() {', "\n";
   print '// TODO: Drain operator', "\n";
   print 'SPLAPPTRC(L_TRACE, "Drain Operator", "CONSISTENT");', "\n";
   print '}', "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::retireCheckpoint(int64_t id) {', "\n";
   print 'SPLAPPTRC(L_TRACE, "Retire Checkpoint: " << id, "CONSISTENT");', "\n";
   print '}', "\n";
   }
   print "\n";
   SPL::CodeGen::implementationEpilogue($model);
   print "\n";
   CORE::exit $SPL::CodeGen::USER_ERROR if ($SPL::CodeGen::sawError);
}
1;
