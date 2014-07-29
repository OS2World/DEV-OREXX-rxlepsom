/* rexx */

call RxFuncAdd 'LepSomLoadFuncs', 'rxlepsom', 'LepSomLoadFuncs'
call LepSomLoadFuncs

tst.log='tst.log'

parse arg args
n=words(args)
call lineout tst.log,'Arguments are ='args
do i=1 to n 
	argv.i=word(args,i)
end 
call lineout tst.log,'Argv[1]="'||argv.1||'"'

lepAA=LepAAnew(argv.1)
call lineout tst.log,"P1"
rng=LepAAGetByNo(lepAA, 0)
if rng\="" then do 
  msg='argv[0].ClassName='||LepGetClassName(rng)
  call lineout tst.log,msg

  shs=LepGetRangeSheets(rng)
  cols=LepGetRangeCols(rng)
  rows=LepGetRangeRows(rng)

  msg='Range dimension('shs','cols','rows');'
  call lineout tst.log, msg

  rcod=LepSetCellString(rng, 1,1,1, "message from REXX!!!");
  rcod=LepSetCellNumber(rng, 1,1,2, 123.321);
end 
else do
  call lineout tst.log, "Could not get first argument"
end
call lineout tst.log,"END"

