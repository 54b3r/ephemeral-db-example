#!/bin/bash

# Colors for output formatting
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default values
SKIP_INFRA=false
SKIP_BUILD=false
SKIP_TESTS=false
WAIT_TIME=30

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --skip-infra)
      SKIP_INFRA=true
      shift
      ;;
    --skip-build)
      SKIP_BUILD=true
      shift
      ;;
    --skip-tests)
      SKIP_TESTS=true
      shift
      ;;
    --wait)
      WAIT_TIME="$2"
      shift 2
      ;;
    --help)
      echo "Usage: $0 [options]"
      echo "Options:"
      echo "  --skip-infra    Skip infrastructure setup (assumes it's already running)"
      echo "  --skip-build    Skip building the application"
      echo "  --skip-tests    Skip running the tests (useful for just setting up infrastructure)"
      echo "  --wait TIME     Wait TIME seconds for services to start (default: 30)"
      echo "  --help          Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check dependencies
check_dependencies() {
  local missing_deps=false
  
  echo -e "${BLUE}Checking dependencies...${NC}"
  
  # Check for Docker
  if ! command_exists docker; then
    echo -e "${RED}✘ Docker is not installed. Please install Docker first.${NC}"
    missing_deps=true
  else
    echo -e "${GREEN}✓ Docker is installed${NC}"
  fi
  
  # Check for Docker Compose
  if ! command_exists docker-compose; then
    echo -e "${RED}✘ Docker Compose is not installed. Please install Docker Compose first.${NC}"
    missing_deps=true
  else
    echo -e "${GREEN}✓ Docker Compose is installed${NC}"
  fi
  
  # Check for Maven (only if we're not skipping build)
  if ! $SKIP_BUILD; then
    if ! command_exists mvn; then
      echo -e "${RED}✘ Maven is not installed. Please install Maven first.${NC}"
      missing_deps=true
    else
      echo -e "${GREEN}✓ Maven is installed${NC}"
    fi
  else
    echo -e "${YELLOW}Skipping Maven check as build is disabled${NC}"
  fi
  
  # Check for curl
  if ! command_exists curl; then
    echo -e "${RED}✘ curl is not installed. Please install curl first.${NC}"
    missing_deps=true
  else
    echo -e "${GREEN}✓ curl is installed${NC}"
  fi
  
  # Check for jq
  if ! command_exists jq; then
    echo -e "${RED}✘ jq is not installed. Please install jq first.${NC}"
    missing_deps=true
  else
    echo -e "${GREEN}✓ jq is installed${NC}"
  fi
  
  if $missing_deps; then
    echo -e "${RED}Please install missing dependencies and try again.${NC}"
    exit 1
  fi
}

# Function to set up infrastructure
setup_infrastructure() {
  if $SKIP_INFRA; then
    echo -e "${YELLOW}Skipping infrastructure setup as requested.${NC}"
    return 0
  fi
  
  echo -e "\n${BLUE}Setting up infrastructure...${NC}"
  
  # Check if containers are already running
  if docker ps | grep -q "pgair-db"; then
    echo -e "${YELLOW}Infrastructure appears to be already running.${NC}"
    echo -e "${YELLOW}Use --skip-infra to skip this check or run 'docker-compose down' first.${NC}"
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo -e "${RED}Aborted.${NC}"
      exit 1
    fi
  fi
  
  echo -e "${CYAN}Starting Docker containers...${NC}"
  docker-compose down -v > /dev/null 2>&1  # Clean start
  docker-compose up -d
  
  if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to start Docker containers. Check docker-compose.yml and try again.${NC}"
    exit 1
  fi
  
  echo -e "${GREEN}✓ Infrastructure started successfully${NC}"
  echo -e "${YELLOW}Waiting ${WAIT_TIME} seconds for services to initialize...${NC}"
  sleep $WAIT_TIME
}

# Function to build the application
build_application() {
  if $SKIP_BUILD; then
    echo -e "${YELLOW}Skipping application build as requested.${NC}"
    return 0
  fi
  
  echo -e "\n${BLUE}Building application...${NC}"
  mvn clean package -DskipTests
  
  if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to build the application. Check the Maven output above.${NC}"
    exit 1
  fi
  
  echo -e "${GREEN}✓ Application built successfully${NC}"
}

# Function to test an endpoint and report results
test_endpoint() {
  local endpoint=$1
  local description=$2
  local db_type=$3
  
  echo -e "\n${BLUE}Testing ${db_type} endpoint:${NC} ${endpoint}"
  echo -e "${BLUE}Description:${NC} ${description}"
  
  # Make the request and capture the response
  response=$(curl -s "http://localhost:8080${endpoint}")
  
  # Check if the response is valid JSON
  if echo "$response" | jq . > /dev/null 2>&1; then
    # Check if the response contains an error message
    if echo "$response" | jq -e '.message' > /dev/null 2>&1; then
      error_message=$(echo "$response" | jq -r '.message')
      echo -e "${RED}✘ Failed:${NC} Error - $error_message"
      return 1
    else
      echo -e "${GREEN}✓ Success:${NC} Endpoint returned valid data"
      # Show a preview of the response (first item or limited output)
      echo -e "${YELLOW}Response preview:${NC}"
      echo "$response" | jq -C '. | if type=="array" then .[0] else . end' | head -n 10
      return 0
    fi
  else
    echo -e "${RED}✘ Failed:${NC} Invalid JSON response"
    echo "$response" | head -n 3
    return 1
  fi
}

# Main function to run tests
run_tests() {
  if $SKIP_TESTS; then
    echo -e "${YELLOW}Skipping tests as requested.${NC}"
    return 0
  fi
  
  # Print header
  echo -e "${BLUE}=========================================================${NC}"
  echo -e "${BLUE}       Airline Backend Java - Endpoint Testing           ${NC}"
  echo -e "${BLUE}=========================================================${NC}"
  echo -e "${YELLOW}Testing both PostgreSQL and DynamoDB integrations${NC}"
  echo -e "${YELLOW}All databases are ephemeral - data will reset on restart${NC}"
  
  # Initialize counters
  total=0
  passed=0
  
  # Test PostgreSQL endpoints
  echo -e "\n${BLUE}=== PostgreSQL Integration Tests ===${NC}"
  
  # Test Aircraft endpoint
  ((total++))
  if test_endpoint "/api/v1/aircraft" "List all aircraft" "PostgreSQL"; then
    ((passed++))
  fi
  
  # Test specific aircraft endpoint
  ((total++))
  if test_endpoint "/api/v1/aircraft/773" "Get aircraft by code" "PostgreSQL"; then
    ((passed++))
  fi
  
  # Test Flights endpoint
  ((total++))
  if test_endpoint "/api/v1/flights" "List all flights" "PostgreSQL"; then
    ((passed++))
  fi
  
  # Test specific flight endpoint
  ((total++))
  if test_endpoint "/api/v1/flights/1" "Get flight by ID" "PostgreSQL"; then
    ((passed++))
  fi
  
  # Test flights by departure airport
  ((total++))
  if test_endpoint "/api/v1/flights/departure/JFK" "Get flights by departure airport" "PostgreSQL"; then
    ((passed++))
  fi
  
  # Test DynamoDB endpoints
  echo -e "\n${BLUE}=== DynamoDB Integration Tests ===${NC}"
  
  # Test Weather endpoint for JFK
  ((total++))
  if test_endpoint "/api/v1/weather/JFK/current" "Get current weather for JFK" "DynamoDB"; then
    ((passed++))
  fi
  
  # Test Weather endpoint for LAX
  ((total++))
  if test_endpoint "/api/v1/weather/LAX/current" "Get current weather for LAX" "DynamoDB"; then
    ((passed++))
  fi
  
  # Test Weather endpoint for SFO
  ((total++))
  if test_endpoint "/api/v1/weather/SFO/current" "Get current weather for SFO" "DynamoDB"; then
    ((passed++))
  fi
  
  # Print summary
  echo -e "\n${BLUE}=========================================================${NC}"
  echo -e "${BLUE}                     Test Summary                       ${NC}"
  echo -e "${BLUE}=========================================================${NC}"
  echo -e "Total tests: ${total}"
  echo -e "Passed: ${GREEN}${passed}${NC}"
  echo -e "Failed: ${RED}$((total - passed))${NC}"
  
  if [ $passed -eq $total ]; then
    echo -e "\n${GREEN}All tests passed! The POC is working correctly.${NC}"
    echo -e "${YELLOW}Note: Both PostgreSQL and DynamoDB are ephemeral.${NC}"
    echo -e "${YELLOW}Data will be reset when containers are restarted.${NC}"
  else
    echo -e "\n${RED}Some tests failed. Please check the application logs:${NC}"
    echo -e "  docker-compose logs -f app"
  fi
  
  echo -e "\n${BLUE}To restart with clean databases:${NC}"
  echo -e "  docker-compose down -v && docker-compose up -d"
}

# Function to clean up resources
cleanup() {
  echo -e "\n${BLUE}Do you want to clean up the infrastructure? (y/n)${NC} "
  read -p "" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${CYAN}Stopping and removing containers...${NC}"
    docker-compose down -v
    echo -e "${GREEN}✓ Cleanup completed${NC}"
  else
    echo -e "${YELLOW}Leaving infrastructure running.${NC}"
    echo -e "${YELLOW}You can stop it later with 'docker-compose down -v'${NC}"
  fi
}

# Main execution

# Display script banner
echo -e "${BLUE}=========================================================${NC}"
echo -e "${BLUE}       Airline Backend Java - POC Validation Tool        ${NC}"
echo -e "${BLUE}=========================================================${NC}"

# Check dependencies
check_dependencies

# Setup infrastructure
setup_infrastructure

# Build application
build_application

# Run the tests
run_tests

# Offer cleanup
cleanup
