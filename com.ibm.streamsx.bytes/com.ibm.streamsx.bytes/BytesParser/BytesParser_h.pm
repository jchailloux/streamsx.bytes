
package BytesParser_h;
use strict; use Cwd 'realpath';  use File::Basename;  use lib dirname(__FILE__);  use SPL::Operator::Instance::OperatorInstance; use SPL::Operator::Instance::Annotation; use SPL::Operator::Instance::Context; use SPL::Operator::Instance::Expression; use SPL::Operator::Instance::ExpressionTree; use SPL::Operator::Instance::ExpressionTreeEvaluator; use SPL::Operator::Instance::ExpressionTreeVisitor; use SPL::Operator::Instance::ExpressionTreeCppGenVisitor; use SPL::Operator::Instance::InputAttribute; use SPL::Operator::Instance::InputPort; use SPL::Operator::Instance::OutputAttribute; use SPL::Operator::Instance::OutputPort; use SPL::Operator::Instance::Parameter; use SPL::Operator::Instance::StateVariable; use SPL::Operator::Instance::TupleValue; use SPL::Operator::Instance::Window; 
sub main::generate($$) {
   my ($xml, $signature) = @_;  
   print "// $$signature\n";
   my $model = SPL::Operator::Instance::OperatorInstance->new($$xml);
   unshift @INC, dirname ($model->getContext()->getOperatorDirectory()) . "/../impl/nl/include";
   $SPL::CodeGenHelper::verboseMode = $model->getContext()->isVerboseModeOn();
   print '/* Additional includes go here */', "\n";
   print '//#include <iostream>', "\n";
   print '#include <jansson.h>', "\n";
   print '//#include <fstream>', "\n";
   print '//#include <sstream>', "\n";
   print '#include <string.h>', "\n";
   print '#include <vector>', "\n";
   print '#define NUMBER_OF_BIT_PER_CHAR 4', "\n";
   SPL::CodeGen::headerPrologue($model);
   print "\n";
   print 'using namespace std;', "\n";
   print "\n";
   print "\n";
   print "\n";
   print 'class ParameterDef{', "\n";
   print '	public:', "\n";
   print '		string name;							// Name of the parameter', "\n";
   print '		string description;						// Description of the parameter', "\n";
   print '		string unit;							// Unit of the parameter', "\n";
   print '		bool isSigned;							// Is the value signed ?', "\n";
   print '		bool endianness;						// BigEndian (MSB on left), LittleEndian (MSB on right)', "\n";
   print '		int byteNumber;							// in which byte in the message the parameter is', "\n";
   print '		int start;								// Bit start in the word', "\n";
   print '		int length;								// Number of bits to extract', "\n";
   print '		string format;							// Format of the value', "\n";
   print '		float factor;							// Factor to apply to the extracted value', "\n";
   print '		float offset;							// Offset to apply to the extracted value', "\n";
   print '		float limit;							// arbitrary value used to simulate negative value related to the offset', "\n";
   print '//		string binaryString;					// String that', "\n";
   print "\n";
   print '	protected:', "\n";
   print '};', "\n";
   print 'class MultiplexDef{', "\n";
   print '	public:', "\n";
   print '		int inlineValue;						// Value of the inlineParameter', "\n";
   print '		vector<ParameterDef> parameters;		//Packets to decode', "\n";
   print "\n";
   print '	protected:', "\n";
   print '};', "\n";
   print 'class MessageDef{', "\n";
   print '	public:', "\n";
   print '		string name;							// Name of the message', "\n";
   print '		string description;						// Description of the message', "\n";
   print '		int bytes;								// Number of bytes in the message', "\n";
   print '		int byteLength;							// Length of the byte in bit', "\n";
   print '		int byteContainerLength;				// Length of the container that store the byte', "\n";
   print '		bool endianness;						// BigEndian (MSB on left), LittleEndian (MSB on right)', "\n";
   print '		float elapse;							// elapse time represented by the message', "\n";
   print '		bool haveIdentifier;					// Is the message starts with a specific word (message id)', "\n";
   print '		string identifier;						// The word used as identifier', "\n";
   print '		ParameterDef inlineParameter;			// Do we have an inline parameter (multiplex)', "\n";
   print '		vector<MultiplexDef> multiplex;			// Multiplex messages', "\n";
   print "\n";
   print '	protected:', "\n";
   print '};', "\n";
   print 'class ObjectDef{', "\n";
   print '	public:', "\n";
   print '		string name;							// Name of the Object : car model, airplane, AIS, .......', "\n";
   print '		vector<MessageDef> messages;			// Messages', "\n";
   print '		std::map<char, string> dictionnary;', "\n";
   print '};', "\n";
   print 'class MY_OPERATOR : public MY_BASE_OPERATOR ', "\n";
   print '{', "\n";
   print 'public:', "\n";
   print '  // Constructor', "\n";
   print '  MY_OPERATOR();', "\n";
   print "\n";
   print '  // Destructor', "\n";
   print '  virtual ~MY_OPERATOR(); ', "\n";
   print "\n";
   print '  // Notify port readiness', "\n";
   print '  void allPortsReady(); ', "\n";
   print "\n";
   print '  // Notify pending shutdown', "\n";
   print '  void prepareToShutdown(); ', "\n";
   print "\n";
   print '  // Processing for source and threaded operators   ', "\n";
   print '  void process(uint32_t idx);', "\n";
   print '    ', "\n";
   print '  // Tuple processing for mutating ports ', "\n";
   print '  void process(Tuple & tuple, uint32_t port);', "\n";
   print '    ', "\n";
   print '  // Tuple processing for non-mutating ports', "\n";
   print '  void process(Tuple const & tuple, uint32_t port);', "\n";
   print "\n";
   print '  // Punctuation processing', "\n";
   print '  void process(Punctuation const & punct, uint32_t port);', "\n";
   print 'private:', "\n";
   print '  // Members', "\n";
   print '  ', "\n";
   print '}; ', "\n";
   print "\n";
   print 'ObjectDef object;', "\n";
   print 'bool ready;', "\n";
   SPL::CodeGen::headerEpilogue($model);
   print "\n";
   CORE::exit $SPL::CodeGen::USER_ERROR if ($SPL::CodeGen::sawError);
}
1;