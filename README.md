
# Project Setup

This project uses `.xcconfig` files to store local API keys and sensitive information. To get started, follow the steps below to configure your environment.

### 🚀 Setup Instructions

1. **Clone the repository**:

   First, clone the repository to your local machine:
   ```bash
   git clone <your-repository-url>
   ```

2. **Run the setup script**:

   After cloning the repository, navigate to the project directory and run the setup script to create the `Secrets.xcconfig` file:
   ```bash
   ./setup.sh
   ```

   This script will check if the `Secrets.xcconfig` file already exists. If not, it will copy the `Secrets.example.xcconfig` file as a template and prompt you to fill in your real API keys and tokens.

3. **Fill in your API keys**:

   Open the newly created `Config/Secrets.xcconfig` file and replace the placeholder values with your real API keys and tokens:
   ```xcconfig
   API_KEY = your_real_key_here
   API_TOKEN = your_real_token_here
   ```

   **Important**: Make sure not to push `Secrets.xcconfig` to your repository. It contains sensitive information and should be kept private.

4. **Verify the setup**:

   To verify that everything is set up correctly, try building the project in Xcode. The API keys should now be accessible in the code.


