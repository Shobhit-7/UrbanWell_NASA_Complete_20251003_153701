#!/bin/bash

echo "🌍 UrbanWell NASA API Setup - Linux/Mac"
echo "====================================="
echo "Team: Decoders (Shobhit Shukla & Charu Awasthi)"
echo "NASA Space Apps Challenge 2025"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "❌ Python is not installed"
    echo "Please install Python 3.8+ first:"
    echo "  Ubuntu/Debian: sudo apt install python3 python3-pip"
    echo "  macOS: brew install python3 or download from python.org"
    exit 1
fi

# Use python3 if available, otherwise python
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
    PIP_CMD="pip3"
else
    PYTHON_CMD="python"
    PIP_CMD="pip"
fi

echo "✅ Python found ($PYTHON_CMD)"
echo ""

# Check for NASA credentials
if [ ! -f .env ]; then
    if [ -f .env.template ]; then
        echo "📝 Setting up NASA credentials..."
        echo ""
        echo "You need a FREE NASA Earthdata account to get real satellite data."
        echo ""
        echo "1. Go to: https://urs.earthdata.nasa.gov/"
        echo "2. Register with your email (takes 2 minutes)"
        echo "3. Verify your email"
        echo "4. Come back here and enter your credentials"
        echo ""

        read -p "Press Enter after creating your NASA account..."

        echo ""
        echo "🔑 Enter your NASA Earthdata credentials:"
        echo ""

        read -p "NASA Username: " nasa_user
        read -s -p "NASA Password: " nasa_pass
        echo ""

        # Create .env file
        cat > .env << EOF
# UrbanWell NASA API Configuration
NASA_EARTHDATA_USERNAME=$nasa_user
NASA_EARTHDATA_PASSWORD=$nasa_pass

# Optional settings
FLASK_ENV=development
FLASK_DEBUG=True
EOF

        echo "✅ NASA credentials configured"
    else
        echo "⚠️  .env.template not found - manual configuration needed"
    fi
else
    echo "✅ NASA credentials already configured"
fi

echo ""

# Install system dependencies on Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "🔧 Checking system dependencies (Linux)..."

    if ! command -v gdal-config &> /dev/null; then
        echo "📦 Installing GDAL (required for geospatial processing)..."

        if command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install -y gdal-bin libgdal-dev python3-dev build-essential
        elif command -v yum &> /dev/null; then
            sudo yum install -y gdal-devel python3-devel gcc
        else
            echo "⚠️  Please install GDAL manually for your Linux distribution"
        fi
    fi
fi

echo "📦 Installing NASA libraries..."
echo "This may take a few minutes..."

$PIP_CMD install -r requirements.txt

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Installation failed. Trying alternative method..."
    echo ""
    $PIP_CMD install Flask flask-cors earthaccess requests python-dotenv numpy pandas

    if [ $? -ne 0 ]; then
        echo "❌ Alternative installation also failed"
        echo ""
        echo "Try these solutions:"
        echo "1. $PIP_CMD install --upgrade pip"
        echo "2. $PIP_CMD install --user -r requirements.txt"
        echo "3. Use conda: conda install -c conda-forge earthaccess flask flask-cors"
        echo ""
        exit 1
    fi
fi

echo "✅ NASA libraries installed successfully!"
echo ""

# Test NASA connection
echo "🧪 Testing NASA API connection..."
$PYTHON_CMD check-nasa-installation.py

echo ""
echo "🚀 Starting UrbanWell with NASA satellite data..."
echo ""
echo "📊 Dashboard will open at: http://localhost:5000/dashboard.html"
echo "⚙️  Admin panel available at: http://localhost:5000/admin"
echo ""
echo "Look for '✅ NASA authentication successful' in the output below"
echo "to confirm you're getting real satellite data!"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

$PYTHON_CMD urbanwell_nasa_backend.py
