
@echo off
setlocal enableDelayedExpansion

set argCount=0
for %%x in (%*) do set /A argCount+=1

set /a counter=0
for /l %%x in (1, 1, %argCount%) do (
  set /a counter=!counter!+1
  call echo Running %%!counter!
  call %%!counter! /VERYSILENT
)

endlocal
