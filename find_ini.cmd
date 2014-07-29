/* rexx */

call RxFuncAdd 'SysLoadFuncs', 'rexxutil', 'SysLoadFuncs'
call SysLoadFuncs

rc=SysFileTree('leprxmm.ini', 'fl', 'S','***+*')
say 'fl.0='fl.0
do i= 1 to fl.0
 say fl.i
end
