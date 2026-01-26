# Ollama Docker Container

This project contains a Docker Compose configuration to run Ollama locally.

## Quick Start

1. **Configure the model to auto-pull (optional):**
   - Create a `.env` file in the project root (or copy from `.env.example`)
   - Set `OLLAMA_MODEL` to the model you want (default: `llama2`)
   ```bash
   echo "OLLAMA_MODEL=llama2" > .env
   ```

2. **Start the containers:**
   ```bash
   docker-compose up -d
   ```
   - The `init-ollama` service will automatically pull the specified model on first startup
   - This may take several minutes depending on the model size

3. **Access the Web UI:**
   - Open your browser and navigate to: `http://localhost:3000`
   - Create an account on first launch (or use the default admin account)
   - The Web UI will automatically connect to the Ollama service
   - Your pre-pulled model will be available immediately

4. **Pull additional models (via CLI or Web UI):**
   
   **Via CLI:**
   ```bash
   docker exec -it ollama ollama pull mistral
   ```
   
   **Via Web UI:**
   1. Open the Web UI at `http://localhost:3000`
   2. Click on the **Settings** icon (gear icon) in the sidebar or top navigation
   3. Navigate to the **Models** section
   4. Click **"Pull Model"** or **"Download Model"** button
   5. Enter the model name (e.g., `mistral`, `codellama`, `phi`)
   6. Click **"Pull"** to start downloading
   7. Wait for the download to complete (progress will be shown)
   8. The model will be available in the model selector for chatting
   
   **Alternative: Quick Model Pull**
   - Some versions of Open WebUI allow pulling models directly from the chat interface
   - Look for a model selector dropdown and a "+" or "Add Model" option

4. **Use the Web UI:**
   - Start chatting with models directly in the browser
   - Switch between different models easily
   - View chat history and manage conversations

5. **Or use the API directly:**
   ```bash
   curl http://localhost:11434/api/generate -d '{
     "model": "llama2",
     "prompt": "Why is the sky blue?"
   }'
   ```

## Configuration

### Environment Variables
Create a `.env` file to customize the setup:
```bash
# Model to automatically pull on startup (default: llama2)
OLLAMA_MODEL=llama2
```

### Ollama Service
- **Port:** 11434 (default Ollama port)
- **Data Volume:** `ollama-data` - stores downloaded models
- **Host:** Accessible on `0.0.0.0:11434` (all interfaces)
- **Health Check:** Monitors service availability

### Init Service
- **Purpose:** Automatically pulls the specified model when containers start
- **Runs:** Once on startup, after Ollama is healthy
- **Model:** Configurable via `OLLAMA_MODEL` environment variable
- **Behavior:** Skips pull if model already exists

### Web UI Service
- **Port:** 3000 (mapped to container port 8080)
- **Data Volume:** `webui-data` - stores Web UI settings and chat history
- **Access:** `http://localhost:3000` in your browser
- **Connects to:** Ollama service at `http://ollama:11434`

## Useful Commands

- **View logs:**
  ```bash
  # View all logs
  docker-compose logs -f
  # View Ollama logs only
  docker-compose logs -f ollama
  # View initialization logs (model pull)
  docker-compose logs -f init-ollama
  # View Web UI logs only
  docker-compose logs -f webui
  ```

- **Stop the container:**
  ```bash
  docker-compose down
  ```

- **Stop and remove volumes (deletes models):**
  ```bash
  docker-compose down -v
  ```

## Available Models

Popular models you can pull via the Web UI or CLI:

### General Purpose Models
- `llama2` - Meta's Llama 2 (7B, 13B, 70B variants available)
- `mistral` - Mistral 7B (fast and efficient)
- `neural-chat` - Intel Neural Chat (optimized for conversations)
- `phi` - Microsoft Phi-2 (small but capable)

### Code Models
- `codellama` - Code Llama (specialized for code generation)
- `deepseek-coder` - DeepSeek Coder (excellent for coding tasks)

### Large Models
- `llama2:70b` - Llama 2 70B (requires significant RAM)
- `mistral-nemo` - Mistral Nemo (larger variant)

### Specialized Models
- `llava` - Multimodal model (text + images)
- `nous-hermes` - Fine-tuned for instruction following

**Note:** When pulling models via the Web UI, you can specify the full model name including tags (e.g., `llama2:13b` for the 13B variant).

Visit [ollama.ai/library](https://ollama.ai/library) for the complete list of available models and their sizes.
