#!/usr/bin/env python3
"""
UrbanWell NASA API Installation Checker
Verifies system readiness for NASA satellite data integration
"""

import sys
import subprocess
import platform
import os

def check_python():
    """Check Python version"""
    version = sys.version_info
    if version.major >= 3 and version.minor >= 8:
        print(f"✅ Python {version.major}.{version.minor}.{version.micro} - OK")
        return True
    else:
        print(f"❌ Python {version.major}.{version.minor}.{version.micro} - Need Python 3.8+")
        return False

def check_nasa_credentials():
    """Check if NASA credentials are configured"""
    env_files = ['.env', '.env.local']
    found_config = False

    for env_file in env_files:
        if os.path.exists(env_file):
            with open(env_file, 'r') as f:
                content = f.read()
                if 'NASA_EARTHDATA_USERNAME' in content and 'NASA_EARTHDATA_PASSWORD' in content:
                    if 'your_earthdata_username_here' not in content:
                        print(f"✅ NASA credentials - Found in {env_file}")
                        found_config = True
                        break

    if not found_config:
        print("⚠️  NASA credentials - Not configured")
        print("   Create .env file with your NASA Earthdata credentials")
        print("   Get free account at: https://urs.earthdata.nasa.gov/")
        return False

    return True

def check_nasa_libraries():
    """Check if NASA libraries are available"""
    required_packages = [
        ('earthaccess', 'NASA data access library'),
        ('requests', 'HTTP client'),
        ('numpy', 'Numerical computing'),
        ('pandas', 'Data analysis')
    ]

    all_available = True

    for package, description in required_packages:
        try:
            __import__(package)
            print(f"✅ {package} - Available ({description})")
        except ImportError:
            print(f"❌ {package} - Missing ({description})")
            all_available = False

    return all_available

def check_internet_connection():
    """Check internet connection to NASA servers"""
    import urllib.request

    test_urls = [
        ('https://urs.earthdata.nasa.gov/', 'NASA Earthdata Login'),
        ('https://api.nasa.gov/', 'NASA API Gateway')
    ]

    for url, name in test_urls:
        try:
            response = urllib.request.urlopen(url, timeout=10)
            if response.getcode() == 200:
                print(f"✅ {name} - Accessible")
            else:
                print(f"⚠️  {name} - Unexpected response ({response.getcode()})")
        except Exception as e:
            print(f"❌ {name} - Connection failed ({str(e)[:50]})")
            return False

    return True

def check_system_dependencies():
    """Check system-level dependencies"""
    system = platform.system().lower()

    if system == 'linux':
        # Check for GDAL on Linux
        try:
            result = subprocess.run(['gdal-config', '--version'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                print(f"✅ GDAL - Version {result.stdout.strip()}")
                return True
            else:
                print("❌ GDAL - Not found")
                print("   Install: sudo apt-get install gdal-bin libgdal-dev")
                return False
        except:
            print("❌ GDAL - Not found or not in PATH")
            return False

    elif system == 'darwin':  # macOS
        print("⚠️  macOS - GDAL recommended via Homebrew: brew install gdal")
        return True

    else:  # Windows
        print("⚠️  Windows - Consider using conda for easier installation")
        return True

def test_nasa_api_connection():
    """Test actual NASA API connection"""
    try:
        import earthaccess
        print("🧪 Testing NASA API connection...")

        # This will use credentials from .env if available
        try:
            earthaccess.login(persist=True)
            print("✅ NASA API - Authentication successful")

            # Test data search
            results = earthaccess.search_data(short_name='OMNO2d', count=1)
            if results:
                print("✅ NASA Data - Search successful")
                return True
            else:
                print("⚠️  NASA Data - No results (may be normal)")
                return True

        except Exception as e:
            print(f"❌ NASA API - Authentication failed ({str(e)[:50]})")
            return False

    except ImportError:
        print("⚠️  earthaccess not available - install with requirements.txt")
        return False
    except Exception as e:
        print(f"❌ NASA API test failed: {str(e)[:100]}")
        return False

def main():
    print("🌍 UrbanWell NASA API Installation Checker")
    print("=" * 50)
    print(f"System: {platform.system()} {platform.release()}")
    print(f"Architecture: {platform.machine()}")
    print()

    checks = [
        ("Python Version", check_python()),
        ("NASA Credentials", check_nasa_credentials()),
        ("NASA Libraries", check_nasa_libraries()),
        ("Internet Connection", check_internet_connection()),
        ("System Dependencies", check_system_dependencies()),
    ]

    # Run NASA API test only if other checks pass
    if all(result for _, result in checks):
        checks.append(("NASA API Connection", test_nasa_api_connection()))

    print()
    print("📋 Summary:")
    print("-" * 30)

    passed = 0
    for name, result in checks:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{status} {name}")
        if result:
            passed += 1

    print()
    if passed == len(checks):
        print("🎉 System is ready for NASA satellite data integration!")
        print()
        print("Next steps:")
        print("1. Run: python urbanwell_nasa_backend.py")
        print("2. Open: http://localhost:5000/dashboard.html")
        print("3. Check admin panel for NASA API status")
        print()
        print("🌍 You'll now see REAL NASA satellite data!")

    else:
        print(f"⚠️  {len(checks) - passed} issues found. Please fix them:")
        print()

        if not checks[0][1]:  # Python version
            print("📥 Install Python 3.8+: https://python.org/downloads/")

        if not checks[1][1]:  # NASA credentials
            print("🔑 Get NASA account: https://urs.earthdata.nasa.gov/")
            print("📝 Copy .env.template to .env and add your credentials")

        if not checks[2][1]:  # NASA libraries
            print("📦 Install libraries: pip install -r requirements.txt")

        if len(checks) > 3 and not checks[3][1]:  # Internet
            print("🌐 Check internet connection and firewall settings")

        if len(checks) > 4 and not checks[4][1]:  # System deps
            if platform.system().lower() == 'linux':
                print("🔧 Install GDAL: sudo apt-get install gdal-bin libgdal-dev")
            elif platform.system().lower() == 'darwin':
                print("🔧 Install GDAL: brew install gdal")

    print()
    print("📚 For detailed setup instructions, see: NASA-SETUP-GUIDE.md")
    print("🏥 Need help? Check the troubleshooting section in the guide")

if __name__ == "__main__":
    main()
