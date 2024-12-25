# Small Business Cybersecurity Toolkit

## Overview
The **Small Business Cybersecurity Toolkit** is a comprehensive solution designed to help small businesses improve their cybersecurity posture. It includes the following tools:
- **Vulnerability Scanner**: Scans for open ports and potential vulnerabilities.
- **Firewall Simulation**: Allows businesses to simulate blocking and allowing IP addresses.
- **Incident Response Plan Generator**: A web-based tool to create and download incident response plans.

## Features
- **Vulnerability Scanner**:
  - Scans IP addresses and hostnames for open ports.
  - Saves results to a log file for analysis.
- **Firewall Simulation**:
  - Block or allow specific IP addresses.
  - Automatically handles conflicting rules.
- **Incident Response Plan Generator**:
  - Interactive web interface to generate incident response plans.
  - Downloadable `.txt` reports for documentation.

## Installation
### Prerequisites
- Python 3.8 or higher
- Node.js (optional for additional web functionality)

### Python Setup
1. Clone this repository:
   ```bash
   git clone git@github.com:gregreborn/portfolio.git
   cd portfolio/Small\ Business\ Cybersecurity\ Toolkit
   ```

2. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Verify that `nmap` is installed and accessible:
   ```bash
   nmap --version
   ```

## Usage
### Command-Line Tools
1. Run the toolkit:
   ```bash
   python main.py
   ```

2. Follow the on-screen menu to:
   - Scan for vulnerabilities.
   - Simulate blocking or allowing IP addresses.

### Web-Based Interface
1. Navigate to the `web_interface/` folder.
2. Open `index.html` in a browser.
3. Fill in the required fields and generate an incident response plan.
4. Download the generated plan as a `.txt` file.

## File Structure
```
Small Business Cybersecurity Toolkit/
├── vulnerability_scanner/         # Python tools for scanning and firewall simulation
│   ├── __init__.py
│   ├── scanner.py
│   ├── validators.py
│   ├── helpers.py
│   ├── firewall.py
├── web_interface/                 # Web-based tool for incident response plans
│   ├── index.html
│   ├── style.css
│   ├── script.js
├── logs/                          # Logs folder for vulnerability scanner
│   ├── scan_results.txt
├── tests/                         # Test scripts
│   ├── test_validators.py
├── README.md                      # Project documentation
├── requirements.txt               # Python dependencies
├── main.py                        # Entry point for CLI tools
```

## Testing
Run unit tests:
```bash
python -m unittest discover tests
```

## Future Enhancements
- Add automated detection of vulnerabilities based on scan results.
- Expand firewall simulation to include advanced protocol-specific rules.
- Host the web interface online for easier access.

