@echo off
REM Build DollarConverter as a standalone Windows executable
REM Ensure PyInstaller is installed
py -m pip install --upgrade pyinstaller
py -m PyInstaller --name DollarConverter --onefile standalone.py

