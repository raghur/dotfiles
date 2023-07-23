@echo off
setlocal
pushd %~dp1
if "%2" NEQ "" (set FMT="%2") ELSE (set FMT=docx)
for /f %%i in ("%1") do @set basename=%%~ni
if %FMT% EQU "pdf" (
        echo "calling pdf"
        call asciidoctor-pdf -r asciidoctor-diagram -a allow-uri-read %1
    ) ELSE (
        call asciidoctor -r asciidoctor-diagram -b docbook -a allow-uri-read -o "%basename%.xml" %1
        call pandoc  -i "%basename%.xml" -f docbook -t %FMT% -o "%basename%.%FMT%"
    )
popd


