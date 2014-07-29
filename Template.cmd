/* rexx */

/* Correct the following assignment: 
	tst.log should be assigned the name of the log file
*/
tst.log='Template.log'
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
	LepDisplayError(msg);
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

/* .... */

return

ErrExit:
 msg='Error '||rc||' occured at line '||sigl||': '||errortext(rc)
 call lineout tst.log, msg
 rcod=LepDisplayError(msg)
return

