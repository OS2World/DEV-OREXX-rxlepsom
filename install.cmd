/* REXX */

  call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
  call SysLoadFuncs

say 'Enter the directory in your LIBPATH '
say 'where you'd like to copy RXLEPSOM DLLs:'
parse pull dllpath
'copy 123rexx.dll 'dllpath
'copy lepsom.dll 'dllpath
'copy rxlepsom.dll 'dllpath

drop yn
do while \(yn='Y' | yn='y' | yn='N' | yn='n')
	say 'Do you plan to use ObjectREXX with RXLEPSOM package?(Y/N)'
	parse pull yn
end
yn=TRANSLATE(yn)
if yn='Y' then do
	/* Touch SOMIR environment variable in config.sys */
	sysdrv=''
	do while sysdrv=''
		say 'Enter the drive letter where your config.sys resides'
		parse pull sysdrv
		sysdrv=translate(substr(sysdrv,1,1))
		if verify(sysdrv, 'CDEFGHIJ')\=0 then sysdrv=''
	end
	config.sys=sysdrv||':\config.sys'
	config.bak=sysdrv||':\config.bak'
	config.new=sysdrv||':\config.new'
	say 'Creating 'config.new ' containing corrected SOMIR declaration...'
	'del 'config.new
	do while lines(config.sys)
		lin=linein(config.sys)
		drop somir
		parse var lin 'SET SOMIR='somir
		if somir\="" then do
			lepsom.ir=directory()||'\LEPSOM.IR;'
			call lineout config.new,'SET SOMIR='||lepsom.ir||somir
		end
		else do
			call lineout config.new, lin
		end
	end
	call lineout config.sys
	call lineout config.new
	call lineout config.bak
	drop yn
	do while \(yn='Y' | yn='y' | yn='N' | yn='n')
		say 'Would you like to replace your 'config.sys' with 'config.new'?(Y/N)'
		parse pull yn
	end
	yn=TRANSLATE(yn)
	if yn='Y' then do
		'copy '||config.sys||' '||config.bak
		'copy '||config.new||' '||config.sys
	end
end


exit(0);
