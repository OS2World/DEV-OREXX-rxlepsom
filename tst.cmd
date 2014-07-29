/* rexx */
/* This test macro receives the following arguments:
	{tst "string";inrange;outrange;number}
	This macro loops thru the inrange cells and performs
	an addition of the given number with the value in the 
	cell from the inrange and puts the concatenation of the result
	and the given string to the corresponding cell from the outrange.
	
*/


tst.log='tst.log'
signal on syntax name ErrExit

call RxFuncAdd 'LepSomLoadFuncs', 'rxlepsom', 'LepSomLoadFuncs'
call LepSomLoadFuncs

parse arg args
n=words(args)
call lineout tst.log,'Arguments are ='args
do i=1 to n 
	argv.i=word(args,i)
end 

lepAA=LepAAnew(argv.1)
if LepGetClassName(lepAA)\='LEPArgumentsArray' then do
	cr=x2c('0D');
	msg='Internal error in 123REXX.DLL RexxAddMacro function.'
	msg=msg||cr||'Please contact us to inform about the conditions of this error.'
	rcod=LepDisplayError(msg);
end

argNum=LepAAGetByNo(lepAA)
lepArg.0=argNum
do i=1 to argNum
	lepArg.i=LepAAGetByNo(lepAA, i-1) /* Lep arguments are 
					enumerated starting from 0 */
	call lineout tst.log, 'lepArg.'i' is a 'LepGetClassName(lepArg.i)
end

/******************************************************************************/
/*                Insert your code here                                       */
/******************************************************************************/
if argNum<4 then do
	LepDisplayError("This macro should receive 4 arguments")
	return 1
end

in.sheet=LepGetRangeSheets(lepArg.2)
in.col=LepGetRangeCols(lepArg.2)
in.row=LepGetRangeRows(lepArg.2)
number=LepGetObjValue(lepArg.4)
instr=LepGetObjValue(lepArg.1)

call lineout tst.log, "Number="number

if datatype(number, 'N')\=1 then do
	rcod=LepDisplayError("The last argument should be number");
	return 1
end

do s=1 to in.sheet
 do c=1 to in.col
  do r=1 to in.row
	val=LepGetCell(lepArg.2, s,c,r)
	if datatype(val,'N')\=1 then val=0
	val=val+number
	rcod=LepSetCellString(lepArg.3, s,c,r, val || instr)
  end
 end
end

/* .... */

return

ErrExit:
 msg='Error '||rc||' occured at line '||sigl||': '||errortext(rc)
 call lineout tst.log, msg
 rcod=LepDisplayError(msg)
return

