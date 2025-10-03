@echo off
echo.
echo 🌍 UrbanWell NASA API Setup - Windows
echo =====================================
echo Team: Decoders (Shobhit Shukla ^& Charu Awasthi)
echo NASA Space Apps Challenge 2025
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python is not installed
    echo Please install Python 3.8+ from https://python.org
    echo.
    pause
    exit /b 1
)

echo ✅ Python found
echo.

REM Check for NASA credentials
if not exist .env (
    if exist .env.template (
        echo 📝 Setting up NASA credentials...
        echo.
        echo You need a FREE NASA Earthdata account to get real satellite data.
        echo.
        echo 1. Go to: https://urs.earthdata.nasa.gov/
        echo 2. Register with your email (takes 2 minutes)
        echo 3. Verify your email
        echo 4. Come back here and enter your credentials
        echo.

        set /p continue="Press Enter after creating your NASA account..."

        echo.
        echo 🔑 Enter your NASA Earthdata credentials:
        echo.

        set /p nasa_user="NASA Username: "
        set /p nasa_pass="NASA Password: "

        REM Create .env file
        (
            echo # UrbanWell NASA API Configuration
            echo NASA_EARTHDATA_USERNAME=%nasa_user%
            echo NASA_EARTHDATA_PASSWORD=%nasa_pass%
            echo.
            echo # Optional settings
            echo FLASK_ENV=development
            echo FLASK_DEBUG=True
        ) > .env

        echo ✅ NASA credentials configured
    ) else (
        echo ⚠️  .env.template not found - manual configuration needed
    )
) else (
    echo ✅ NASA credentials already configured
)

echo.
echo 📦 Installing NASA libraries...
echo This may take a few minutes...

pip install -r requirements.txt

if errorlevel 1 (
    echo.
    echo ❌ Installation failed. Trying alternative method...
    echo.
    pip install Flask flask-cors earthaccess requests python-dotenv numpy pandas

    if errorlevel 1 (
        echo ❌ Alternative installation also failed
        echo.
        echo Try these solutions:
        echo 1. pip install --upgrade pip
        echo 2. pip install --user -r requirements.txt
        echo 3. Use conda instead: conda install -c conda-forge earthaccess flask flask-cors
        echo.
        pause
        exit /b 1
    )
)

echo ✅ NASA libraries installed successfully!
echo.

REM Test NASA connection
echo 🧪 Testing NASA API connection...
python check-nasa-installation.py

echo.
echo 🚀 Starting UrbanWell with NASA satellite data...
echo.
echo 📊 Dashboard will open at: http://localhost:5000/dashboard.html
echo ⚙️  Admin panel available at: http://localhost:5000/admin
echo.
echo Look for "✅ NASA authentication successful" in the output below
echo to confirm you're getting real satellite data!
echo.
echo Press Ctrl+C to stop the server
echo.

python urbanwell_nasa_backend.py

pause
