# Automated Vulnerability Scanner Setup

## Description
This repository contains a Bash script (`setup.sh`) to install all necessary tools for an automated vulnerability scanning workflow. These tools facilitate tasks such as finding subdomains, extracting URLs, scanning for XSS, SQL injection, and more.

## Prerequisites
Ensure the following are installed on your system:

- **Linux OS** (Ubuntu/Debian recommended)
- **Go** (Golang)
- **Python 3** and **pip3**

The script installs additional dependencies automatically.

## Tools Installed
- [Subfinder](https://github.com/projectdiscovery/subfinder): Subdomain discovery.
- [Httpx](https://github.com/projectdiscovery/httpx): HTTP probing and analysis.
- [Haktrails](https://github.com/hakluke/haktrails): Passive reconnaissance.
- [GetJS](https://github.com/003random/getJS): Extract JavaScript files from URLs.
- [Waybackurls](https://github.com/tomnomnom/waybackurls): Fetch URLs from Wayback Machine.
- [Dalfox](https://github.com/hahwul/dalfox): XSS vulnerability scanning.
- [gf](https://github.com/tomnomnom/gf): Filtering and pattern matching for vulnerabilities.
- [sqlmap](https://sqlmap.org): Automated SQL injection detection.
- [urlfinder](https://github.com/projectdiscovery/urlfinder): URL extraction tool.

## Installation

Run the `setup.sh` script to install all tools:

```bash
chmod +x setup.sh
./setup.sh
```

This script will:
1. Update your system.
2. Install necessary packages and dependencies.
3. Download and compile all required tools.

Ensure your `$GOPATH/bin` is added to your system's `$PATH`:

```bash
export PATH=$PATH:$GOPATH/bin
```

To make this permanent, add the above line to your `~/.bashrc` or `~/.zshrc` file and reload it:

```bash
source ~/.bashrc
```

## Usage
1. Clone the repository:

   ```bash
   git clone <repository_url>
   cd <repository_folder>
   ```

2. Run the `setup.sh` script to install tools.

3. Use the main scanning script (`autobugfinder.sh`) to perform automated vulnerability scans.

## Output
The scanning script generates the following outputs:
- Live assets: `live_assets.txt`
- JavaScript files: `js_files.txt`
- Extracted URLs: `extracted_urls.txt`
- XSS vulnerabilities: `dalfox` results
- SQL injection vulnerabilities: `sqli_vulnerabilities.txt`

Outputs are saved in timestamped directories for organization.

## Contributing
Pull requests are welcome. For major changes, please open an issue to discuss what you would like to change.

## License
This project is licensed under the MIT License.
