# 🌍 UrbanWell NASA API Setup Guide

**Complete guide to set up UrbanWell with real NASA satellite data integration**

## 🚀 Quick Start (5 Steps)

### Step 1: Install Python 3.8+
- **Windows**: Download from https://python.org
- **macOS**: `brew install python3` or download from python.org  
- **Linux**: `sudo apt install python3 python3-pip python3-dev`

### Step 2: Get NASA Credentials (FREE)
1. **Register at NASA Earthdata**: https://urs.earthdata.nasa.gov/
2. **Create free account** (takes 2 minutes)
3. **Verify your email** 
4. **Note your username and password**

### Step 3: Configure Environment
```bash
# Copy environment template
cp .env.template .env

# Edit .env file and add your NASA credentials:
NASA_EARTHDATA_USERNAME=your_actual_username
NASA_EARTHDATA_PASSWORD=your_actual_password
```

### Step 4: Install Dependencies
```bash
# Install NASA API libraries
pip install -r requirements.txt
```

### Step 5: Run Application
```bash
# Start server
python urbanwell_nasa_backend.py

# Open dashboard
http://localhost:5000/dashboard.html
```

## 📋 Detailed Setup Instructions

### Prerequisites Check
Run this to verify your system:
```bash
python check-installation.py
```

### NASA Earthdata Account Setup
1. **Go to**: https://urs.earthdata.nasa.gov/
2. **Click**: "Register for a profile"
3. **Fill in** your information (use real email)
4. **Check email** and click verification link
5. **Login** to confirm account is active

### Environment Configuration

Edit the `.env` file with your actual credentials:

```env
# REQUIRED: Your NASA Earthdata credentials
NASA_EARTHDATA_USERNAME=john_doe_123
NASA_EARTHDATA_PASSWORD=MySecretPassword123

# OPTIONAL: NASA API key (for some advanced APIs)
NASA_API_KEY=your_api_key_from_nasa_api_gov

# APPLICATION SETTINGS
FLASK_ENV=development
FLASK_DEBUG=True
```

**⚠️ Security Note:** Never commit the .env file to version control!

### Dependency Installation

#### Option A: Full Installation (Recommended)
```bash
pip install -r requirements.txt
```

#### Option B: Minimal Installation (if you have issues)
```bash
pip install Flask flask-cors earthaccess requests python-dotenv numpy pandas
```

#### Option C: Conda Installation (Windows recommended)
```bash
conda create -n urbanwell python=3.9
conda activate urbanwell
conda install -c conda-forge earthaccess rasterio geopandas flask flask-cors
pip install python-dotenv
```

### System Dependencies (Linux/Mac)

#### Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install gdal-bin libgdal-dev python3-dev build-essential
```

#### macOS (Homebrew):
```bash
brew install gdal
```

#### Windows:
- Install Microsoft Visual C++ Build Tools
- Or use conda (recommended for Windows)

## 🌍 NASA API Integration Details

### What APIs Are Used

The system integrates with these NASA datasets:

1. **TEMPO** - Tropospheric Emissions: Monitoring of Pollution
   - **Data**: Real-time air quality (NO₂, O₃, formaldehyde)
   - **Update**: Hourly
   - **Resolution**: 2.1 km × 4.4 km

2. **OMI/Aura** - Ozone Monitoring Instrument  
   - **Data**: Atmospheric trace gases
   - **Update**: Daily
   - **Resolution**: 13 km × 24 km

3. **GRACE/GRACE-FO** - Gravity Recovery and Climate Experiment
   - **Data**: Groundwater storage changes
   - **Update**: Monthly
   - **Resolution**: ~300 km

4. **MODIS** - Moderate Resolution Imaging Spectroradiometer
   - **Data**: Vegetation indices (NDVI, EVI)
   - **Update**: 16-day composite
   - **Resolution**: 250m - 1km

5. **Landsat-8/9** - Land imaging satellites
   - **Data**: High-resolution land surface data
   - **Update**: 16-day revisit
   - **Resolution**: 30m

### Where API Keys Are Used in Code

The NASA credentials are used in these locations:

#### 1. Environment Loading (Line 15-25)
```python
from dotenv import load_dotenv
load_dotenv()

NASA_CONFIG = {
    'earthdata_username': os.getenv('NASA_EARTHDATA_USERNAME', ''),
    'earthdata_password': os.getenv('NASA_EARTHDATA_PASSWORD', ''),
    'api_key': os.getenv('NASA_API_KEY', ''),
}
```

#### 2. Authentication Setup (Line 35-55)
```python
class NASAAPIClient:
    def __init__(self):
        self.username = NASA_CONFIG['earthdata_username']  # YOUR USERNAME HERE
        self.password = NASA_CONFIG['earthdata_password']  # YOUR PASSWORD HERE
        self.setup_authentication()
```

#### 3. Earthaccess Authentication (Line 60-75)
```python
def setup_authentication(self):
    import earthaccess
    earthaccess.login(
        username=self.username,    # FROM .env FILE
        password=self.password,    # FROM .env FILE
        persist=True
    )
```

#### 4. API Data Fetching (Line 85-150)
```python
def get_air_quality_data(self, latitude, longitude, date=None):
    # Uses authenticated session to fetch TEMPO/OMI data
    results = earthaccess.search_data(
        short_name='OMNO2d',  # NASA dataset identifier
        bounding_box=(longitude-0.1, latitude-0.1, longitude+0.1, latitude+0.1),
        temporal=(date, date)
    )
```

#### 5. Alternative API Calls (Line 200-250)
```python
if self.api_key:  # FROM NASA_API_KEY in .env
    air_quality_url = f"{NASA_CONFIG['base_url']}/planetary/earth/assets"
    params = {
        'api_key': self.api_key,  # YOUR API KEY HERE
        'lat': latitude,
        'lon': longitude
    }
```

### Data Flow Architecture

```
1. User Request → Flask App
2. Flask App → NASA API Client  
3. NASA Client → Earthdata Login (using your credentials)
4. Earthdata → NASA Data Centers (TEMPO, OMI, GRACE, MODIS, Landsat)
5. NASA Data → Processing & Storage (SQLite database)
6. Processed Data → Dashboard Display
```

## 🔧 Configuration Options

### Performance Tuning

Add these to your .env file for better performance:

```env
# API rate limiting (requests per hour)
NASA_API_RATE_LIMIT=100

# Cache responses for 1 hour
CACHE_TIMEOUT=3600

# Logging level
LOG_LEVEL=INFO
```

### Advanced Configuration

```env
# Custom NASA endpoints (if needed)
NASA_EARTHDATA_URL=https://urs.earthdata.nasa.gov
NASA_API_BASE_URL=https://api.nasa.gov

# Database (for production)
DATABASE_URL=postgresql://user:pass@localhost:5432/urbanwell

# CORS settings
CORS_ORIGINS=http://localhost:3000,http://localhost:8080
```

## 🧪 Testing NASA Integration

### 1. Check Authentication
```bash
python -c "
from urbanwell_nasa_backend import nasa_client
print('NASA Auth:', nasa_client.authenticated)
"
```

### 2. Test API Endpoints
Visit these URLs after starting the server:
- http://localhost:5000/api/status
- http://localhost:5000/admin

### 3. Monitor API Calls
Check the console output for NASA API status:
```
✅ NASA Earthdata authentication successful
✅ Retrieved NASA air quality data for 28.6139, 77.2090
✅ Found OMI NO2 data for 28.6139, 77.2090
```

### 4. Verify Real Data
In the dashboard, look for data source indicators:
- Real NASA data shows "NASA_TEMPO_OMI" 
- Simulated data shows "SIMULATION"

## 🐛 Troubleshooting

### Common Issues

#### "NASA authentication failed"
**Problem**: Invalid credentials or network issues
**Solutions**:
1. Verify credentials at https://urs.earthdata.nasa.gov/
2. Check .env file format (no quotes around values)
3. Ensure internet connection
4. Try regenerating Earthdata password

#### "earthaccess module not found"  
**Problem**: Missing NASA libraries
**Solution**:
```bash
pip install earthaccess
# Or for conda:
conda install -c conda-forge earthaccess
```

#### "GDAL not found" errors
**Problem**: Missing geospatial libraries
**Solutions**:
- **Ubuntu**: `sudo apt install gdal-bin libgdal-dev`
- **macOS**: `brew install gdal`
- **Windows**: Use conda instead of pip

#### "No NASA data available"
**Problem**: NASA servers temporarily down or dataset not available
**Result**: System automatically falls back to simulation
**Action**: Check NASA server status at https://earthdata.nasa.gov/

#### Port 5000 already in use
**Solution**: Edit line 571 in urbanwell_nasa_backend.py:
```python
app.run(debug=True, host='0.0.0.0', port=8080)  # Change port
```

#### Data appears simulated despite NASA credentials
**Causes**:
1. NASA servers temporarily unavailable
2. Dataset not available for requested location/date
3. API rate limits exceeded

**Check**: Visit /admin panel to see NASA API status

## 📊 Data Sources & Updates

### Real-time Updates
- **TEMPO**: Every hour (for supported regions)
- **OMI**: Daily global coverage
- **MODIS**: 16-day vegetation composites
- **GRACE**: Monthly groundwater updates

### Geographic Coverage
- **Global**: OMI, GRACE, MODIS, Landsat
- **North America**: TEMPO (Mexico to Canada)
- **Urban Areas**: All datasets available

### Data Accuracy
- All data comes directly from NASA's operational satellites
- Quality flags and uncertainty estimates included
- Peer-reviewed algorithms used for processing

## 🚀 Deployment

### Local Development
```bash
python urbanwell_nasa_backend.py
```

### Production Deployment

#### 1. Environment Setup
```bash
export FLASK_ENV=production
export NASA_EARTHDATA_USERNAME=your_username
export NASA_EARTHDATA_PASSWORD=your_password
```

#### 2. Run with Gunicorn
```bash
gunicorn -w 4 -b 0.0.0.0:5000 urbanwell_nasa_backend:app
```

#### 3. Docker Deployment (Optional)
```dockerfile
FROM python:3.9-slim
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["gunicorn", "-b", "0.0.0.0:5000", "urbanwell_nasa_backend:app"]
```

## 📞 Support

### NASA Earthdata Support
- **Help**: https://earthdata.nasa.gov/support
- **Documentation**: https://earthaccess.readthedocs.io/
- **Forums**: https://forum.earthdata.nasa.gov/

### Project Support
- Check console output for detailed error messages
- Verify credentials at NASA Earthdata Login
- Test internet connection to NASA servers
- Review .env file configuration

## 🏆 Success Metrics

After successful setup, you should see:
- ✅ NASA authentication successful in console
- ✅ Real data source indicators in dashboard
- ✅ API status showing "Connected" in admin panel
- ✅ Location-specific satellite data in visualizations

---

**🌍 You're now connected to NASA's Earth observation network!**

Your UrbanWell system can monitor urban health using the same satellite data that NASA scientists use for climate and environmental research.

**Made for NASA Space Apps Challenge 2025**  
**Team: Decoders - Shobhit Shukla & Charu Awasthi**
