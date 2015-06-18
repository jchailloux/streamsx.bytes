package BytesParserCommon;
use strict;

sub Init($) 
{
	my ($model) = @_;
  
	## Get input and output port details  
  
  	# Let us obtain all the good stuff that the operator model object
	# throws at us regarding the generic things for this primitive operator.
		
		
	# Input port related information.
	#Data to decode
	$::inputPortZero = $model->getInputPortAt(0);
	$::inputPortZeroTupleName = $::inputPortZero->getCppTupleName();
	$::inputPortZeroTupleType = $::inputPortZero->getCppTupleType();

	#New definition filename
    if ($model->getNumberOfInputPorts() == 2) {
		$::inputPortOne = $model->getInputPortAt(1);
		$::inputPortOneTupleName = $::inputPortOne->getCppTupleName();
		$::inputPortOneTupleType = $::inputPortOne->getCppTupleType();
	}		
	# Output port related information.
	$::outputPortZero = $model->getOutputPortAt(0);
	$::outputPortZeroTupleName = $::outputPortZero->getCppTupleName();
	$::outputPortZeroTupleType = $::outputPortZero->getCppTupleType();
	$::outputPortZeroTupleAttributes = $::outputPortZero->getAttributes();
	$::assignments = SPL::CodeGen::getOutputTupleCppInitializer($model->getOutputPortAt(0));

#	$::tupleType = $::inputPortZero->getSPLTupleType();

	#Operator Parameters
	#Default Filename for the definition 
	$::file = $model->getParameterByName("file");
#	$::file = $::file ? $::file->getValueAt(0)->getSPLExpression():"ffd.csv";

	#The attribute name that contains the message
    $::message = $model->getParameterByName("message");

	#The attribute name that contains the identifier
    $::identifier = $::identifier ? $model->getParameterByName("identifier") : "NONE";

}
1;