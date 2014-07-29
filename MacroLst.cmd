/* rexx */

tst.log='MacroLst.log'
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
	return
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

if argNum<1 then do
	rcod=LepDisplayError('The one argument should be specified')
	return 1
end


rng=lepArg.1
cls=LepGetClassName(rng)

call lineout tst.log, 'Range is a 'cls

if cls\='LEPRange' then do
	rcod=LepDisplayError('The range for the macro list should be the 1st argument')
	return 1
end

call lineout tst.log, 'lepArg.1->somGetClass='||cls

rcod=LepSetCellString(rng,1,1,1,'Macro name');
rcod=LepSetCellString(rng,1,2,1,'Command File');
rcod=LepSetCellString(rng,1,3,1,"Arguments' types");


n=LepMacroNum()
call lineout tst.log, 'There are 'n' macros registered'
call lineout tst.log, 'Macro[0].name='LepMacroGetName(0)
do i=1 to n /* macros are enumerated starting from 0 */
	rcod=LepSetCellString(rng, 1,1,i+1, '{'||LepMacroGetName(i-1)||'}')
	rcod=LepSetCellString(rng, 1,2,i+1, '{'||LepMacroGetFile(i-1)||'}')
	types="("
	argNum=LepMacroGetArgs(i-1)
	do j=1 to argNum
		tt=LepMacroGetProt(i-1,j-1)
		select 
		when tt=0 then do 
			types=types||'@TYPESTRING()'
		end
		when tt=1 then do
			types=types||'@TYPENUMBER()'
		end
		when tt=2 then do
			types=types||'@TYPECOND()'
		end
		when tt=3 then do
			types=types||'@TYPEVALUE()'
		end
		when tt=4 then do
			types=types||'@TYPERANGE()'
		end
		otherwise 
			types=types||'Illegal type '||tt
		end
		if j\=argNum then do
			types=types||', '
		end
	end
	types=types||')'
	rcod=LepSetCellString(rng, 1,3,i+1, types)
end
return 


ErrExit:
 msg='Error '||rc||' occured at line '||sigl||': '||errortext(rc)
 call lineout tst.log, msg
 rcod=LepDisplayError(msg)
return
