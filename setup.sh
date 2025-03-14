#!/bin/bash

# Colors for output formatting
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to detect OS
detect_os() {
  echo -e "${BLUE}Detecting operating system...${NC}"
  
  case "$(uname -s)" in
    Linux*)     
      OS="Linux"
      if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$NAME
      else
        DISTRO="Unknown Linux"
      fi
      ;;
    Darwin*)    
      OS="macOS"
      DISTRO=$(sw_vers -productVersion)
      ;;
    CYGWIN*|MINGW*|MSYS*)
      OS="Windows"
      DISTRO="Windows"
      ;;
    *)          
      OS="Unknown"
      DISTRO="Unknown"
      ;;
  esac
  
  echo -e "${GREEN}✓ Detected OS: ${OS} (${DISTRO})${NC}"
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install package manager if needed (for Windows)
install_package_manager() {
  if [ "$OS" = "Windows" ]; then
    if ! command_exists choco; then
      echo -e "${YELLOW}Installing Chocolatey package manager for Windows...${NC}"
      powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
      if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Chocolatey installed successfully${NC}"
      else
        echo -e "${RED}✘ Failed to install Chocolatey. Please install it manually: https://chocolatey.org/install${NC}"
        exit 1
      fi
    fi
  fi
}

# Function to install Docker
install_docker() {
  if ! command_exists docker; then
    echo -e "${YELLOW}Docker not found. Installing Docker...${NC}"
    
    case "$OS" in
      Linux)
        case "$DISTRO" in
          Ubuntu*|Debian*)
            echo -e "${CYAN}Installing Docker on Ubuntu/Debian...${NC}"
            sudo apt-get update
            sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io
            sudo usermod -aG docker $USER
            ;;
          CentOS*|Red*)
            echo -e "${CYAN}Installing Docker on CentOS/RHEL...${NC}"
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo usermod -aG docker $USER
            ;;
          *)
            echo -e "${RED}✘ Unsupported Linux distribution. Please install Docker manually: https://docs.docker.com/engine/install/${NC}"
            exit 1
            ;;
        esac
        ;;
      macOS)
        echo -e "${CYAN}Installing Docker Desktop for Mac...${NC}"
        echo -e "${YELLOW}Please download and install Docker Desktop from: https://www.docker.com/products/docker-desktop${NC}"
        echo -e "${YELLOW}After installation, please run this script again.${NC}"
        exit 1
        ;;
      Windows)
        echo -e "${CYAN}Installing Docker Desktop for Windows using Chocolatey...${NC}"
        choco install docker-desktop -y
        echo -e "${YELLOW}Please restart your computer after Docker installation, then run this script again.${NC}"
        exit 1
        ;;
      *)
        echo -e "${RED}✘ Unsupported OS. Please install Docker manually: https://docs.docker.com/engine/install/${NC}"
        exit 1
        ;;
    esac
    
    if command_exists docker; then
      echo -e "${GREEN}✓ Docker installed successfully${NC}"
    else
      echo -e "${RED}✘ Docker installation failed. Please install Docker manually: https://docs.docker.com/engine/install/${NC}"
      exit 1
    fi
  else
    echo -e "${GREEN}✓ Docker is already installed${NC}"
  fi
}

# Function to install Docker Compose
install_docker_compose() {
  if ! command_exists docker-compose; then
    echo -e "${YELLOW}Docker Compose not found. Installing Docker Compose...${NC}"
    
    case "$OS" in
      Linux)
        echo -e "${CYAN}Installing Docker Compose on Linux...${NC}"
        COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
        sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        ;;
      macOS)
        echo -e "${CYAN}Installing Docker Compose on macOS...${NC}"
        if command_exists brew; then
          brew install docker-compose
        else
          echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          brew install docker-compose
        fi
        ;;
      Windows)
        echo -e "${CYAN}Installing Docker Compose on Windows...${NC}"
        choco install docker-compose -y
        ;;
      *)
        echo -e "${RED}✘ Unsupported OS. Please install Docker Compose manually: https://docs.docker.com/compose/install/${NC}"
        exit 1
        ;;
    esac
    
    if command_exists docker-compose; then
      echo -e "${GREEN}✓ Docker Compose installed successfully${NC}"
    else
      echo -e "${RED}✘ Docker Compose installation failed. Please install Docker Compose manually: https://docs.docker.com/compose/install/${NC}"
      exit 1
    fi
  else
    echo -e "${GREEN}✓ Docker Compose is already installed${NC}"
  fi
}

# Function to install Maven
install_maven() {
  if ! command_exists mvn; then
    echo -e "${YELLOW}Maven not found. Installing Maven...${NC}"
    
    case "$OS" in
      Linux)
        case "$DISTRO" in
          Ubuntu*|Debian*)
            echo -e "${CYAN}Installing Maven on Ubuntu/Debian...${NC}"
            sudo apt-get update
            sudo apt-get install -y maven
            ;;
          CentOS*|Red*)
            echo -e "${CYAN}Installing Maven on CentOS/RHEL...${NC}"
            sudo yum install -y maven
            ;;
          *)
            echo -e "${RED}✘ Unsupported Linux distribution. Please install Maven manually: https://maven.apache.org/install.html${NC}"
            exit 1
            ;;
        esac
        ;;
      macOS)
        echo -e "${CYAN}Installing Maven on macOS...${NC}"
        if command_exists brew; then
          brew install maven
        else
          echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          brew install maven
        fi
        ;;
      Windows)
        echo -e "${CYAN}Installing Maven on Windows...${NC}"
        choco install maven -y
        ;;
      *)
        echo -e "${RED}✘ Unsupported OS. Please install Maven manually: https://maven.apache.org/install.html${NC}"
        exit 1
        ;;
    esac
    
    if command_exists mvn; then
      echo -e "${GREEN}✓ Maven installed successfully${NC}"
    else
      echo -e "${RED}✘ Maven installation failed. Please install Maven manually: https://maven.apache.org/install.html${NC}"
      exit 1
    fi
  else
    echo -e "${GREEN}✓ Maven is already installed${NC}"
  fi
}

# Function to install curl
install_curl() {
  if ! command_exists curl; then
    echo -e "${YELLOW}curl not found. Installing curl...${NC}"
    
    case "$OS" in
      Linux)
        case "$DISTRO" in
          Ubuntu*|Debian*)
            echo -e "${CYAN}Installing curl on Ubuntu/Debian...${NC}"
            sudo apt-get update
            sudo apt-get install -y curl
            ;;
          CentOS*|Red*)
            echo -e "${CYAN}Installing curl on CentOS/RHEL...${NC}"
            sudo yum install -y curl
            ;;
          *)
            echo -e "${RED}✘ Unsupported Linux distribution. Please install curl manually${NC}"
            exit 1
            ;;
        esac
        ;;
      macOS)
        echo -e "${CYAN}Installing curl on macOS...${NC}"
        if command_exists brew; then
          brew install curl
        else
          echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          brew install curl
        fi
        ;;
      Windows)
        echo -e "${CYAN}Installing curl on Windows...${NC}"
        choco install curl -y
        ;;
      *)
        echo -e "${RED}✘ Unsupported OS. Please install curl manually${NC}"
        exit 1
        ;;
    esac
    
    if command_exists curl; then
      echo -e "${GREEN}✓ curl installed successfully${NC}"
    else
      echo -e "${RED}✘ curl installation failed. Please install curl manually${NC}"
      exit 1
    fi
  else
    echo -e "${GREEN}✓ curl is already installed${NC}"
  fi
}

# Function to install jq
install_jq() {
  if ! command_exists jq; then
    echo -e "${YELLOW}jq not found. Installing jq...${NC}"
    
    case "$OS" in
      Linux)
        case "$DISTRO" in
          Ubuntu*|Debian*)
            echo -e "${CYAN}Installing jq on Ubuntu/Debian...${NC}"
            sudo apt-get update
            sudo apt-get install -y jq
            ;;
          CentOS*|Red*)
            echo -e "${CYAN}Installing jq on CentOS/RHEL...${NC}"
            sudo yum install -y epel-release
            sudo yum install -y jq
            ;;
          *)
            echo -e "${RED}✘ Unsupported Linux distribution. Please install jq manually: https://stedolan.github.io/jq/download/${NC}"
            exit 1
            ;;
        esac
        ;;
      macOS)
        echo -e "${CYAN}Installing jq on macOS...${NC}"
        if command_exists brew; then
          brew install jq
        else
          echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          brew install jq
        fi
        ;;
      Windows)
        echo -e "${CYAN}Installing jq on Windows...${NC}"
        choco install jq -y
        ;;
      *)
        echo -e "${RED}✘ Unsupported OS. Please install jq manually: https://stedolan.github.io/jq/download/${NC}"
        exit 1
        ;;
    esac
    
    if command_exists jq; then
      echo -e "${GREEN}✓ jq installed successfully${NC}"
    else
      echo -e "${RED}✘ jq installation failed. Please install jq manually: https://stedolan.github.io/jq/download/${NC}"
      exit 1
    fi
  else
    echo -e "${GREEN}✓ jq is already installed${NC}"
  fi
}

# Function to install Java 17
install_java() {
  if ! command_exists java || ! java -version 2>&1 | grep -q "version \"17"; then
    echo -e "${YELLOW}Java 17 not found. Installing Java 17...${NC}"
    
    case "$OS" in
      Linux)
        case "$DISTRO" in
          Ubuntu*|Debian*)
            echo -e "${CYAN}Installing Java 17 on Ubuntu/Debian...${NC}"
            sudo apt-get update
            sudo apt-get install -y openjdk-17-jdk
            ;;
          CentOS*|Red*)
            echo -e "${CYAN}Installing Java 17 on CentOS/RHEL...${NC}"
            sudo yum install -y java-17-openjdk-devel
            ;;
          *)
            echo -e "${RED}✘ Unsupported Linux distribution. Please install Java 17 manually: https://openjdk.java.net/projects/jdk/17/${NC}"
            exit 1
            ;;
        esac
        ;;
      macOS)
        echo -e "${CYAN}Installing Java 17 on macOS...${NC}"
        if command_exists brew; then
          brew install openjdk@17
          sudo ln -sfn $(brew --prefix)/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
        else
          echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          brew install openjdk@17
          sudo ln -sfn $(brew --prefix)/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
        fi
        ;;
      Windows)
        echo -e "${CYAN}Installing Java 17 on Windows...${NC}"
        choco install openjdk17 -y
        ;;
      *)
        echo -e "${RED}✘ Unsupported OS. Please install Java 17 manually: https://openjdk.java.net/projects/jdk/17/${NC}"
        exit 1
        ;;
    esac
    
    if command_exists java && java -version 2>&1 | grep -q "version \"17"; then
      echo -e "${GREEN}✓ Java 17 installed successfully${NC}"
    else
      echo -e "${RED}✘ Java 17 installation failed. Please install Java 17 manually: https://openjdk.java.net/projects/jdk/17/${NC}"
      exit 1
    fi
  else
    echo -e "${GREEN}✓ Java 17 is already installed${NC}"
  fi
}

# Main function
main() {
  echo -e "${BLUE}=========================================================${NC}"
  echo -e "${BLUE}       Ephemeral Database Example - Setup Script         ${NC}"
  echo -e "${BLUE}=========================================================${NC}"
  
  # Detect OS
  detect_os
  
  # Install package manager if needed (Windows)
  if [ "$OS" = "Windows" ]; then
    install_package_manager
  fi
  
  # Install dependencies
  echo -e "\n${BLUE}Installing dependencies...${NC}"
  install_java
  install_maven
  install_docker
  install_docker_compose
  install_curl
  install_jq
  
  echo -e "\n${GREEN}✓ All dependencies installed successfully!${NC}"
  echo -e "${BLUE}You can now run the test script: ./test-endpoints.sh${NC}"
  
  # Start Docker if not running
  if [ "$OS" = "Linux" ]; then
    if ! systemctl is-active --quiet docker; then
      echo -e "${YELLOW}Starting Docker service...${NC}"
      sudo systemctl start docker
    fi
  fi
  
  echo -e "\n${BLUE}Would you like to start the application now? (y/n)${NC} "
  read -p "" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${CYAN}Starting the application...${NC}"
    cd airline-backend-java
    ./test-endpoints.sh
  else
    echo -e "${YELLOW}You can start the application later by running:${NC}"
    echo -e "  cd airline-backend-java"
    echo -e "  ./test-endpoints.sh"
  fi
}

# Run the main function
main
