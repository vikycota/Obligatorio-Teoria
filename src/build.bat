@echo off
set LIB=..\lib
set CUPRT=%LIB%\java-cup-runtime-11b-20160615-3.jar

java -cp %LIB%\jflex-1.9.1.jar;%CUPRT% jflex.Main --encoding UTF-8 scanner.jflex || exit /b 1
java -cp %LIB%\java-cup-11b-20160615-3.jar;%CUPRT% java_cup.Main -parser parser -symbols sym Parser.cup || exit /b 1
javac -encoding UTF-8 -cp %CUPRT% *.java || exit /b 1
java -cp .;%CUPRT% parser %1
