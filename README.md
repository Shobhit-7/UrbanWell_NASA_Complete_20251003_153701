# 🌍 UrbanWell - NASA API Integrated Version

**Real NASA Satellite Data for Urban Wellbeing Monitoring**  
**NASA Space Apps Challenge 2025 - Team Decoders**

## 🎯 What This Is

This is the **production NASA API version** of UrbanWell that fetches **real satellite data** from NASA's Earth observation systems for comprehensive urban health monitoring.

## ⚡ Quick Start

### Prerequisites
- Python 3.8+
- NASA Earthdata account (free): https://urs.earthdata.nasa.gov/

### Setup (4 steps)
```bash
# 1. Configure NASA credentials
cp .env.template .env
# Edit .env with your NASA username/password

# 2. Install dependencies  
pip install -r requirements.txt

# 3. Run application
python urbanwell_nasa_backend.py

# 4. Open dashboard
http://localhost:5000/dashboard.html
```

## 🌍 NASA Datasets Integrated

### Real-Time Air Quality
- **TEMPO**: Tropospheric pollution monitoring (North America, hourly)
- **OMI/Aura**: Global atmospheric composition (daily)
- **Parameters**: NO₂, O₃, PM2.5, SO₂, AQI

### Water Security  
- **GRACE/GRACE-FO**: Groundwater storage changes (global, monthly)
- **GPM**: Precipitation measurement (global, 3-hourly)
- **Parameters**: Groundwater levels, precipitation, flood risk

### Vegetation Health
- **MODIS**: Vegetation indices (global, 16-day composites)
- **Landsat-8/9**: High-resolution land data (16-day revisit)
- **Parameters**: NDVI, EVI, green coverage, surface temperature

## 🔑 NASA Credentials Setup

### 1. Get NASA Earthdata Account
1. Visit: https://urs.earthdata.nasa.gov/
2. Register with email verification
3. Note your username and password

### 2. Configure Environment
```bash
# Copy template
cp .env.template .env

# Edit .env file:
NASA_EARTHDATA_USERNAME=your_actual_username
NASA_EARTHDATA_PASSWORD=your_actual_password
NASA_API_KEY=optional_api_key_from_api_nasa_gov
```

### 3. Where Credentials Are Used in Code

**Environment Loading** (urbanwell_nasa_backend.py:15-25):
```python
from dotenv import load_dotenv
load_dotenv()

NASA_CONFIG = {
    'earthdata_username': os.getenv('NASA_EARTHDATA_USERNAME', ''),
    'earthdata_password': os.getenv('NASA_EARTHDATA_PASSWORD', ''),
}
```

**Authentication** (urbanwell_nasa_backend.py:60-75):
```python
def setup_authentication(self):
    import earthaccess
    earthaccess.login(
        username=self.username,    # FROM YOUR .env FILE
        password=self.password,    # FROM YOUR .env FILE
        persist=True
    )
```

**API Calls** (urbanwell_nasa_backend.py:85-200):
```python
# Real NASA data fetching
results = earthaccess.search_data(
    short_name='OMNO2d',  # NASA dataset
    bounding_box=(longitude-0.1, latitude-0.1, longitude+0.1, latitude+0.1),
    temporal=(date, date)
)
```

## 📊 Features

### ✅ Working Features
- **Real NASA satellite data** for any city worldwide
- **Interactive dashboard** with maps and trend charts
- **Admin panel** to add cities and monitor API status
- **Alert system** for environmental hazards
- **Historical data** storage and analysis
- **Automatic fallback** to simulation if NASA APIs unavailable

### 🌍 Global Coverage
- **Any city worldwide** can be monitored
- **Real-time updates** from NASA's operational satellites
- **Multi-parameter monitoring** (air + water + vegetation)
- **Professional grade data** used by NASA scientists

## 🛠️ Installation Options

### Option 1: Full Installation (Recommended)
```bash
pip install -r requirements.txt
```

### Option 2: Minimal Installation
```bash
pip install Flask flask-cors earthaccess requests python-dotenv numpy pandas
```

### Option 3: Conda (Windows)
```bash
conda create -n urbanwell python=3.9
conda activate urbanwell
conda install -c conda-forge earthaccess flask flask-cors
pip install python-dotenv
```

## 🧪 Verification

### Check Installation
```bash
python check-nasa-installation.py
```

### Verify NASA Connection
1. Start server: `python urbanwell_nasa_backend.py`
2. Check console for: "✅ NASA Earthdata authentication successful"
3. Visit admin panel: http://localhost:5000/admin
4. Look for "✅ Connected" status

### Confirm Real Data
- Dashboard shows "NASA_TEMPO_OMI" (not "SIMULATION")
- Console logs show successful NASA API calls
- Data updates reflect actual satellite measurements

## 🔧 Configuration

### Required Environment Variables
```env
NASA_EARTHDATA_USERNAME=your_username    # REQUIRED
NASA_EARTHDATA_PASSWORD=your_password    # REQUIRED
NASA_API_KEY=your_api_key                # OPTIONAL
```

### Optional Settings
```env
FLASK_ENV=development
LOG_LEVEL=INFO
CACHE_TIMEOUT=3600
NASA_API_RATE_LIMIT=100
```

## 🌐 API Endpoints

- `GET /` - API status and NASA connection info
- `GET /api/status` - Detailed NASA API status
- `GET /dashboard.html` - Interactive dashboard
- `GET /admin` - Admin panel with NASA status
- `GET /api/locations` - List monitored cities
- `POST /api/locations` - Add new city (triggers NASA data fetch)
- `GET /api/dashboard/{id}` - Get NASA data for city
- `GET /api/historical/{id}` - Get trend data
- `GET /api/alerts/{id}` - Get environmental alerts

## 🐛 Troubleshooting

### Common Issues

**"NASA authentication failed"**
→ Verify credentials at https://urs.earthdata.nasa.gov/
→ Check .env file format (no quotes around values)

**"earthaccess module not found"**
→ Run: `pip install earthaccess`

**Data shows "SIMULATION"**  
→ NASA servers temporarily unavailable (normal fallback)
→ Check internet connection to NASA

**GDAL errors (Linux)**
→ Install: `sudo apt-get install gdal-bin libgdal-dev`

**Port 5000 in use**
→ Edit urbanwell_nasa_backend.py line 571, change port

### NASA Server Status
NASA satellites and data centers occasionally undergo maintenance. The system automatically falls back to simulation during outages while preserving the same data structure.

## 📈 Performance

### NASA API Limits
- Earthdata: Generally no strict limits for registered users
- Reasonable use policy applies
- Built-in rate limiting and caching

### Data Update Frequency
- **TEMPO**: Hourly (North America only)
- **OMI**: Daily global coverage
- **GRACE**: Monthly updates
- **MODIS**: 16-day composites
- **Landsat**: 16-day revisit cycle

## 🚀 Deployment

### Development
```bash
python urbanwell_nasa_backend.py
```

### Production
```bash
export NASA_EARTHDATA_USERNAME=your_username
export NASA_EARTHDATA_PASSWORD=your_password
gunicorn -w 4 -b 0.0.0.0:5000 urbanwell_nasa_backend:app
```

### Docker
```dockerfile
FROM python:3.9-slim
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["gunicorn", "-b", "0.0.0.0:5000", "urbanwell_nasa_backend:app"]
```

## 📋 File Structure

```
urbanwell-nasa/
├── urbanwell_nasa_backend.py    # Main app with NASA integration
├── .env.template               # Credentials template
├── requirements.txt            # NASA libraries included
├── dashboard.html             # Interactive frontend
├── NASA-SETUP-GUIDE.md       # Complete setup guide
├── check-nasa-installation.py # Installation checker
└── README.md                 # This file
```

## 🏆 NASA Space Apps Challenge 2025

### Competition Advantages
- ✅ **Real NASA Data**: Actual satellite measurements, not simulation
- ✅ **Global Scale**: Works for any city worldwide
- ✅ **Real-Time**: Fresh data from operational satellites
- ✅ **Professional Grade**: Same data NASA scientists use
- ✅ **Comprehensive**: Air + water + vegetation combined
- ✅ **Scalable**: Production-ready architecture

### Demo Script
1. **Show NASA authentication** in console output
2. **Display real data sources** in dashboard
3. **Add new global city** to demonstrate worldwide coverage
4. **Explain satellite integration** for each parameter
5. **Highlight urban planning applications**

## 📞 Support

### NASA Resources
- **Earthdata Help**: https://earthdata.nasa.gov/support
- **Documentation**: https://earthaccess.readthedocs.io/
- **Data Portal**: https://search.earthdata.nasa.gov/

### Project Resources  
- **Setup Guide**: NASA-SETUP-GUIDE.md
- **Installation Check**: `python check-nasa-installation.py`
- **Admin Panel**: http://localhost:5000/admin

---

**🌍 You're now connected to NASA's Earth observation satellites!**

Monitor urban health using the same data that NASA uses for climate science and environmental research.

**Team**: Decoders - Shobhit Shukla & Charu Awasthi  
**Challenge**: Data Pathways to Healthy Cities and Human Settlements  
**NASA Space Apps Challenge 2025**
