streamsx.bytes
==============

Being able to extract data from a raw string.

Assuming you receive a message like that : 
 0A34AB.........86911H or 00110011100000.....01010101
 
 You should have to describe how to extract data.
 
 ```
 <raws>
  <raw id="10" name="NAME_OF_THE_MESSAGE" length="4497" format="HEX" multiplex="PACKET_NAME_THAT_CONTAINS_MULTIPLEX_VALUE">
    	<packet id="1" name="VALUE_1" start="0" length="24" datatype="string"></packet>
    	<packet id="2" name="PACKET_NAME_THAT_CONTAINS_MULTIPLEX_VALUE" start="24" length="8" datatype="int"></packet>
    	<packet id="3" name="VERSION" start="32" length="80" datatype="hexword"></packet>
    	......
    	<packet id="200" name="V1" start="1034" length="32" datatype="int" multiplexValue="7"></packet>
    	<packet id="201" name="V2" start="1034" length="32" datatype="int" multiplexValue="8"></packet>
  </raw>
  ......
 </raws>
 ```
