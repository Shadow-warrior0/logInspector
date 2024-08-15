# loginspector

## Overview
**loginspector** is a high-performance bash tool designed to scan `Kubernetes` logs for sensitive information. Leveraging multithreading, loginspector quickly processes logs from running pods in a specified namespace, searching for keywords that represent confidential data such as passwords, tokens, and API keys. It integrates seamlessly with kubectl, allowing users to efficiently monitor their Kubernetes clusters for security risks.

## Features
- **Multithreaded Log Scanning:** Processes multiple logs simultaneously to maximize speed and efficiency.
- **Automated Log Retrieval:** Fetches logs from all running pods in a Kubernetes namespace.
- **Custom Wordlist Support:** Allows you to define a list of sensitive keywords to scan for in the logs.
- **Interactive Namespace and Pod Selection:** Guides you through selecting the namespace and pods to scan.
- **Organized Output:** Saves identified sensitive information in a structured format for easy review.
- **Efficiency:** Multithreading ensures rapid scanning, even in large Kubernetes clusters.

## Installation
To install and set up loginspector:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Shadow-warrior0/logInspector.git
   cd loginspector
2. **Ensure kubectl is installed:**
Make sure kubectl is installed and configured to access your Kubernetes cluster.

3. **Make the script executable:**

    ```bash
    chmod +x loginspector.sh

## Usage
loginspector requires a wordlist file containing the keywords you want to search for in the logs.

**Basic Usage**

    
    ./loginspector.sh <wordlist_file>

**Example**
    
    chmod +x loginspector.sh
   
Copy code
./loginspector.sh sensitive_keywords.txt
This command will prompt you to select a namespace and list all running pods in that namespace. You can specify which pods to scan or leave the input empty to scan all running pods.
    
    ./loginspector.sh sensitive_keywords.txt


**Output**
The script creates a folder named suspected_logs where it stores the logs and identified keyword matches. The original logs are deleted after processing to maintain a clean working environment.

## Configuration
loginspector uses a custom wordlist file that you provide. This wordlist should contain one keyword per line, representing the sensitive data you want to search for.

**Example Wordlist**
    
    password
    secret
    token
    api_key
    password
    secret
    token
    api_key


**Banner Message**

At the end of the script execution, loginspector displays a custom banner message in the terminal:
    🐞🐞 Keep inspecting, keep logging, and have an epic coding adventure! 🐞🐞🚀👨‍💻

## Contributing
If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request on GitHub.


## Disclaimer
loginspector is intended for security purposes to help identify sensitive information in Kubernetes logs. Use it responsibly and ensure you have proper authorization before scanning any logs.
