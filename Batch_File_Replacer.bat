@echo off
setlocal enabledelayedexpansion

echo.
echo  Batch File Replacer by iFlex
echo.

:: Batch File Replacer by iFlex

if "%~1"=="" (
    echo.
    echo  ERROR: No files were provided.
    echo.
    echo  Usage: Drag and drop one or more text files onto this script.
    echo.
    pause
    exit /b 1
)

echo.
set /p "newText=Enter the new text: "
echo.

for %%I in (%*) do (
    set "file=%%~I"
    if exist "!file!" (
        echo [>] Processing: "!file!"
        set "tempFile=!TEMP!\batch_replace_%random%.tmp"
        set "changesMade="

        (
            for /f "usebackq delims=" %%a in ("!file!") do (
                set "line=%%a"
                rem We use echo( to safely print lines that might be empty
                echo(!line! | findstr /i /c:"m_Source" /c:"path" >nul
                if !errorlevel! equ 0 (
                    rem This section uses your original, working logic for replacement
                    set "newLine=!line!"
                    for /f "tokens=1,* delims==" %%b in ("!line!") do (
                        if "%%c" NEQ "" (
                            set "textToInsert=!newText!"
                            set "newLine=%%b= "!textToInsert!""
                            set "changesMade=1"
                        )
                    )
                    echo(!newLine!
                ) else (
                    echo(!line!
                )
            )
        ) > "!tempFile!"

        if defined changesMade (
            move /y "!tempFile!" "!file!" >nul
            echo [✓] Success: File has been updated.
        ) else (
            del "!tempFile!"
            echo [-] Info: No target keywords found. No changes made.
        )
        echo.
    ) else (
        echo [!] Skipping: File not found - "!file!"
        echo.
    )
)

echo All files have been processed.
pause
