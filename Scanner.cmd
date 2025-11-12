@echo off
setlocal enabledelayedexpansion

rem === Caminho da pasta analisada ===
set "PASTA=%cd%"
set "RELATORIO=%PASTA%\relatorio_%~n0_%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%h%time:~3,2%m.txt"

rem === Contagem por tipo de arquivo com progresso ===
set /a IMAGENS=0
set /a VIDEOS=0
set /a DOCUMENTOS=0
set /a AUDIO=0
set /a COMPACTADOS=0
set /a OUTROS=0
set /a CONTADOR=0

for /r "%PASTA%" %%F in (*) do (
    set /a CONTADOR+=1
    <nul set /p =Processando arquivo !CONTADOR! ...`r
    
    set "ARQ=%%~xF"
    set "ARQ=!ARQ:~1!"
    
    if /i "!ARQ!"=="jpg"  set /a IMAGENS+=1
    if /i "!ARQ!"=="jpeg" set /a IMAGENS+=1
    if /i "!ARQ!"=="png"  set /a IMAGENS+=1
    if /i "!ARQ!"=="gif"  set /a IMAGENS+=1
    if /i "!ARQ!"=="bmp"  set /a IMAGENS+=1

    if /i "!ARQ!"=="mp4"  set /a VIDEOS+=1
    if /i "!ARQ!"=="avi"  set /a VIDEOS+=1
    if /i "!ARQ!"=="mkv"  set /a VIDEOS+=1
    if /i "!ARQ!"=="mov"  set /a VIDEOS+=1

    if /i "!ARQ!"=="txt"  set /a DOCUMENTOS+=1
    if /i "!ARQ!"=="pdf"  set /a DOCUMENTOS+=1
    if /i "!ARQ!"=="docx" set /a DOCUMENTOS+=1
    if /i "!ARQ!"=="xlsx" set /a DOCUMENTOS+=1
    if /i "!ARQ!"=="pptx" set /a DOCUMENTOS+=1

    if /i "!ARQ!"=="mp3"  set /a AUDIO+=1
    if /i "!ARQ!"=="wav"  set /a AUDIO+=1
    if /i "!ARQ!"=="flac" set /a AUDIO+=1
    if /i "!ARQ!"=="m4a"  set /a AUDIO+=1
    if /i "!ARQ!"=="aac"  set /a AUDIO+=1
    if /i "!ARQ!"=="ogg"  set /a AUDIO+=1

    if /i "!ARQ!"=="zip"  set /a COMPACTADOS+=1
    if /i "!ARQ!"=="rar"  set /a COMPACTADOS+=1
    if /i "!ARQ!"=="7z"   set /a COMPACTADOS+=1
    if /i "!ARQ!"=="tar"  set /a COMPACTADOS+=1
    if /i "!ARQ!"=="gz"   set /a COMPACTADOS+=1
)

echo. 
echo Contagem concluida! Processados !CONTADOR! arquivos.

rem Apaga relatórios antigos da mesma pasta
del "%PASTA%\relatorio_*.txt" 2>nul

rem === Tamanho total da pasta (em bytes, MB e GB) ===
set /a TOTAL_SIZE_BYTES=0

for /f "usebackq tokens=*" %%S in (`powershell -NoProfile -Command "(Get-ChildItem -LiteralPath '%PASTA%' -Recurse -File | Measure-Object -Property Length -Sum).Sum"`) do set "TOTAL_SIZE_BYTES=%%S"
set /a TOTAL_SIZE_MB=TOTAL_SIZE_BYTES/1048576
set /a TOTAL_SIZE_GB=TOTAL_SIZE_BYTES/1073741824

echo ===== RELATÓRIO GERAL DA PASTA ===== > "%RELATORIO%"
echo Pasta analisada: %PASTA% >> "%RELATORIO%"
echo Data: %date% %time% >> "%RELATORIO%"

echo Tamanho total da pasta: %TOTAL_SIZE_BYTES% bytes (%TOTAL_SIZE_MB% MB, aproximadamente %TOTAL_SIZE_GB% GB) >> "%RELATORIO%"
echo ==================================== >> "%RELATORIO%"
echo. >> "%RELATORIO%"

rem === Contagem de arquivos e pastas ===
set /a TOTAL_ARQUIVOS=0
set /a TOTAL_PASTAS=0
for /r "%PASTA%" %%A in (*) do set /a TOTAL_ARQUIVOS+=1
for /d /r "%PASTA%" %%B in (*) do set /a TOTAL_PASTAS+=1

echo Total de arquivos: %TOTAL_ARQUIVOS% >> "%RELATORIO%"
echo Total de pastas: %TOTAL_PASTAS% >> "%RELATORIO%"
echo. >> "%RELATORIO%"

rem === Contagem por tipo de arquivo ===
set /a IMAGENS=0
set /a VIDEOS=0
set /a DOCUMENTOS=0
set /a AUDIO=0
set /a COMPACTADOS=0
set /a OUTROS=0

for /r "%PASTA%" %%F in (*) do (
    set "ARQ=%%~xF"
    set "ARQ=!ARQ:~1!"
    
    if /i "!ARQ!"=="jpg"  set /a IMAGENS+=1
    if /i "!ARQ!"=="jpeg" set /a IMAGENS+=1
    if /i "!ARQ!"=="png"  set /a IMAGENS+=1
    if /i "!ARQ!"=="gif"  set /a IMAGENS+=1
    if /i "!ARQ!"=="bmp"  set /a IMAGENS+=1

    if /i "!ARQ!"=="mp4"  set /a VIDEOS+=1
    if /i "!ARQ!"=="avi"  set /a VIDEOS+=1
    if /i "!ARQ!"=="mkv"  set /a VIDEOS+=1
    if /i "!ARQ!"=="mov"  set /a VIDEOS+=1

    if /i "!ARQ!"=="txt"  set /a DOCUMENTOS+=1
    if /i "!ARQ!"=="pdf"  set /a DOCUMENTOS+=1
    if /i "!ARQ!"=="docx" set /a DOCUMENTOS+=1
    if /i "!ARQ!"=="xlsx" set /a DOCUMENTOS+=1
    if /i "!ARQ!"=="pptx" set /a DOCUMENTOS+=1

    if /i "!ARQ!"=="mp3"  set /a AUDIO+=1
    if /i "!ARQ!"=="wav"  set /a AUDIO+=1
    if /i "!ARQ!"=="flac" set /a AUDIO+=1
    if /i "!ARQ!"=="m4a"  set /a AUDIO+=1
    if /i "!ARQ!"=="aac"  set /a AUDIO+=1
    if /i "!ARQ!"=="ogg"  set /a AUDIO+=1

    if /i "!ARQ!"=="zip"  set /a COMPACTADOS+=1
    if /i "!ARQ!"=="rar"  set /a COMPACTADOS+=1
    if /i "!ARQ!"=="7z"   set /a COMPACTADOS+=1
    if /i "!ARQ!"=="tar"  set /a COMPACTADOS+=1
    if /i "!ARQ!"=="gz"   set /a COMPACTADOS+=1
)

set /a OUTROS=%TOTAL_ARQUIVOS%-(%IMAGENS%+%VIDEOS%+%DOCUMENTOS%+%AUDIO%+%COMPACTADOS%)

echo Imagens: %IMAGENS% >> "%RELATORIO%"
echo Videos: %VIDEOS% >> "%RELATORIO%"
echo Documentos: %DOCUMENTOS% >> "%RELATORIO%"
echo Audio: %AUDIO% >> "%RELATORIO%"
echo Compactados: %COMPACTADOS% >> "%RELATORIO%"
echo Outros: %OUTROS% >> "%RELATORIO%"

echo. >> "%RELATORIO%"

rem === Subpastas ===
echo Subpastas encontradas: >> "%RELATORIO%"
for /d /r "%PASTA%" %%S in (*) do echo - %%S >> "%RELATORIO%"
echo. >> "%RELATORIO%"

rem === Arquivos grandes (>100MB) ===
echo === Arquivos grandes (>100MB) === >> "%RELATORIO%"
for /r "%PASTA%" %%G in (*) do (
    set "TAM=%%~zG"
    if !TAM! gtr 104857600 echo %%G (!TAM! bytes^) >> "%RELATORIO%"
)
echo =============================================== >> "%RELATORIO%"

echo.
echo Relatorio gerado com sucesso!
echo Local: "%RELATORIO%"

echo.
:ABRIR_RELATORIO
set /p RESP="Deseja abrir o relatorio agora? (S/N): "
if /i "%RESP%"=="S" (
    start "" "%RELATORIO%"
    goto FIM
)
if /i "%RESP%"=="N" goto FIM
echo Por favor digite S ou N.
goto ABRIR_RELATORIO

:FIM
endlocal
exit /b 0
