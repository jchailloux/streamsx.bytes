package BytesParserCommon;
use XML::Simple;
use Data::Dumper;
use strict;

$::messageFunctions='';
$::signalFunctions='';
$::processFunctions='';
$::headerFunctions='';

sub Init($) 
{
	my ($model) = @_;
  
	## Get input and output port details  
  
  	# Let us obtain all the good stuff that the operator model object
	# throws at us regarding the generic things for this primitive operator.
		
		
	# Input port related information.
	$::inputPortZero = $model->getInputPortAt(0);
	$::inputPortZeroTupleName = $::inputPortZero->getCppTupleName();
	$::inputPortZeroTupleType = $::inputPortZero->getCppTupleType();
		
	# Output port related information.
	$::outputPortZero = $model->getOutputPortAt(0);
	$::outputPortZeroTupleName = $::outputPortZero->getCppTupleName();
	$::outputPortZeroTupleType = $::outputPortZero->getCppTupleType();

#	$::outputPortOne = $model->getOutputPortAt(1);
#	$::outputPortOneTupleName = $::outputPortOne->getCppTupleName();
#	$::outputPortOneTupleType = $::outputPortOne->getCppTupleType();

	$::tupleType = $::inputPortZero->getSPLTupleType();

	#Check the persist option
	$::file = $model->getParameterByName("file");
	$::file = $::file ? $::file->getValueAt(0)->getSPLExpression():"empty.xml";

    $::id = $model->getParameterByName("id");
    $::data = $model->getParameterByName("data");
    $::decoded = $model->getParameterByName("decoded");

}
1;

sub generateMask {
#	print "Generate Mask -> $_\n";
	#shit works on $_ -> don't need to use any $_[0]
	my $size=shift;
	my $start=shift;
	my $length=shift;
	return oct("0b".("1" x $length).("0" x (($size*8)-$start-$length+7)));
#	return Math::BigInt->from_bin("0b".("1" x $length).("0" x (($size*8)-$start-$length+7)));
}
1;

sub generateFormula {
#	print "Generate Formula -> $_\n";
	#shit works on $_ -> don't need to use any $_[0]
	my $formula=shift;
	my $factor=shift;
	my $offset=shift;
	$formula =~ s/factor/$factor/g;
	$formula =~ s/offset/$offset/g;
	return $formula;
}
1;

sub readXML($){
	my $file=shift;
#	my $file = 'binary.xml';
		
my $data = XMLin($file,KeepRoot => 1, KeyAttr => 1, ForceArray=>1);

my %multiplex=();
my $messageId="";
my $messageSize="";

$::processFunctions.="\tswitch (". $::id->getValueAt(0)->getCppExpression()  ."){\n";



#print Dumper($data);
my $output='';
my $result='';
foreach my $raw (@{$data->{raws}[0]{raw}}) {
	%multiplex=();
	#
	#Iterate over raws
	#
	$::processFunctions.="\t\tcase $raw->{id} : {\n";
	if($raw->{format} eq 'HEX' ){
		$::processFunctions.="\t\t\tstring inputData=HexStringToBinaryString(".$::data->getValueAt(0)->getCppExpression().");\n";
	}
	if($raw->{format} eq 'BIN' ){
		$::processFunctions.="\t\t\tstring inputData=".$::data->getValueAt(0)->getCppExpression().";\n";
	}
	if($raw->{format} eq 'DEC' ){
		$::processFunctions.="\t\t\tstring inputData=integerToBinaryString(".$::data->getValueAt(0)->getCppExpression().");\n";
	}
	if($raw->{format} eq 'STR' ){
		$::processFunctions.="\t\t\tstring inputData=stringToBinaryString(".$::data->getValueAt(0)->getCppExpression().");\n";
	}
	if(exists ($raw->{multiplex})){
		$::processFunctions.="\t\t\tint multiplexer=decode_$raw->{id}_$raw->{multiplex}( SPL::Functions::Utility::strtoll(".$::data->getValueAt(0)->getCppExpression().".string().c_str(),16));\n";
	}
	$::processFunctions.="\t\t\tfloat result;\n";
	#
	#Iterate over packets
	#
	foreach my $packet (@{$raw->{packet}}) {
#		if(lc($packet->{datatype}) eq 'string' ){
#			$::signalFunctions.="char * decode_" . $raw->{id} . "_$packet->{name}(char * data){\n";
#		}
#		$::signalFunctions.="\tlong mask=". generateMask($raw->{length},$packet->{start},$packet->{length}).";\n";
#		$::signalFunctions.="\treturn (data & mask) >> (($raw->{length} * 8) - ($packet->{start}+$packet->{length})+(($raw->{length} % 2 == 0)?0:7));\n";
#		$::signalFunctions.="}\n";
		if(exists ($packet->{function})){
			$result=generateFormula($packet->{function},$packet->{factor},$packet->{offset});
		}else{
			$result="x";
		}
		my $f;
		if(lc($packet->{datatype}) eq 'string' ){
			$f="getStringFromBinaryString(inputData)";
		}
		if(lc($packet->{datatype}) eq 'int' ){
			$f="getIntFromBinaryString(inputData)";
		}
		if(lc($packet->{datatype}) eq 'long' ){
			$f="getLongFromBinaryString(inputData)";
		}
		$result =~ s/x/$f/g;
		if(exists ($packet->{multiplex})){
			if(! exists ($multiplex{$packet->{multiplex}})){
					$multiplex{$packet->{multiplex}}="\t\tcase $packet->{multiplex} : {\n";
			}
#			$multiplex{$packet->{multiplex}}.="\t\t\tdouble result_" . $raw->{id} . "_$packet->{name}=$result;\n";
			$multiplex{$packet->{multiplex}}.="\t\t\t\t\t\tresult=$result;\n";
			foreach my $attribute (@{$::outputPortZero->getAttributes()}) { 
				my $name = $attribute->getName(); 
				if (index($name, 'id') != -1) {
					$multiplex{$packet->{multiplex}}.= "\t\t\t\t\t\t$::outputPortZeroTupleName.set_".$name."( ".$::id->getValueAt(0)->getCppExpression().");\n";  
				}
				if (index($name, 'value') != -1) {
					$multiplex{$packet->{multiplex}}.= "\t\t\t\t\t\t$::outputPortZeroTupleName.set_".$name."( result);\n";  
				}
			} 
			$multiplex{$packet->{multiplex}}.="\t\t\t\t\t\tsubmit($::outputPortZeroTupleName, 0);\n";
		}else{
#			$::messageFunctions.="\tdouble result_" . $raw->{id} . "_$packet->{name}=$result;\n";
			$::processFunctions.="\n\t\t\tresult=$result;\n";
			foreach my $attribute (@{$::outputPortZero->getAttributes()}) { 
				my $name = $attribute->getName(); 
				if (index($name, 'id') != -1) {
					$::processFunctions.= "\t\t\t$::outputPortZeroTupleName.set_".$name."( ".$::id->getValueAt(0)->getCppExpression().");\n";  
				}
				if (index($name, 'value') != -1) {
					$::processFunctions.= "\t\t\t$::outputPortZeroTupleName.set_".$name."( result);\n";  
				}
			} 
			$::processFunctions.="\t\t\tsubmit($::outputPortZeroTupleName, 0);\n";
			$::processFunctions.="\t\t\tbreak;\n";
		}
	}
	if(keys( %multiplex ) >0){
		$::processFunctions.="\t\t\tswitch (multiplexer){\n";
		foreach my $key ( keys %multiplex ){
			$::processFunctions.= "\t\t$multiplex{$key}";
			$::processFunctions.="\t\t\t\t\t\tbreak;\n";
			$::processFunctions.="\t\t\t\t\t}\n";
		}
		$::processFunctions.="\t\t\t}\n";
	}
	$::processFunctions.="\t\t\tsubmit(Punctuation::WindowMarker, 0) ;\n";
	$::processFunctions.="\t\t}\n";
}
$::processFunctions.="\t\tdefault : {\n";
#for my $attribute (@{$::outputPortOne->getAttributes()}) {
#    my $name = $attribute->getName();
#	$::processFunctions.= "\t\t\t" .$::outputPortOneTupleName . ".set_" . $name . "(" . $::inputPortZeroTupleName . ".get_" . $name . "());\n";
#}

$::processFunctions.="\t\t\tsubmit($::outputPortOneTupleName, 1);\n";
$::processFunctions.="\t\t\tsubmit(Punctuation::WindowMarker, 0) ;\n";
$::processFunctions.="\t\t\tbreak;\n";
$::processFunctions.="\t\t}\n";
$::processFunctions.="\t}\n";	
	
}
1;
