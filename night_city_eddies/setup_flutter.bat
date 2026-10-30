@echo off
setlocal
set "ROOT=%~dp0"
set "TARGET=%ROOT%night_city_eddies_app"

where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter nao foi encontrado no PATH.
  echo Adicione a pasta bin do Flutter ao PATH e tente novamente.
  pause
  exit /b 1
)

if exist "%TARGET%" (
  echo A pasta night_city_eddies_app ja existe.
  echo Apague ou renomeie essa pasta antes de executar novamente.
  pause
  exit /b 1
)

flutter create --project-name night_city_eddies --platforms=android "%TARGET%"
if errorlevel 1 (
  echo Falha ao criar a estrutura Flutter.
  pause
  exit /b 1
)

xcopy "%ROOT%mobile\lib" "%TARGET%\lib" /E /I /Y >nul
copy /Y "%ROOT%mobile\pubspec.yaml" "%TARGET%\pubspec.yaml" >nul

powershell -NoProfile -ExecutionPolicy Bypass -File "%ROOT%configure_android.ps1" -ManifestPath "%TARGET%\android\app\src\main\AndroidManifest.xml"

cd /d "%TARGET%"
flutter pub get
if errorlevel 1 (
  echo O projeto foi criado, mas flutter pub get falhou. Execute novamente dentro da pasta night_city_eddies_app.
  pause
  exit /b 1
)

echo.
echo Projeto Flutter criado em: %TARGET%
echo Confira o AndroidManifest.xml conforme o README e inicie a API antes de executar o app.
echo.
pause
