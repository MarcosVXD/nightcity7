@echo off
setlocal
cd /d "%~dp0backend"

where node >nul 2>nul
if errorlevel 1 (
  echo Node.js nao foi encontrado. Instale o Node.js 20 ou superior.
  pause
  exit /b 1
)

if not exist "node_modules" (
  echo Instalando dependencias da API...
  npm install
  if errorlevel 1 (
    echo Falha ao instalar dependencias.
    pause
    exit /b 1
  )
)

npm start
pause
