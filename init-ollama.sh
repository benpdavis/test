#!/bin/bash

# Set OLLAMA_HOST for the ollama CLI (format: host:port, not http://)
export OLLAMA_HOST=${OLLAMA_HOST:-"ollama:11434"}

# Remove http:// prefix if present
OLLAMA_HOST=${OLLAMA_HOST#http://}
OLLAMA_HOST=${OLLAMA_HOST#https://}

# Default model if not specified
MODEL=${OLLAMA_MODEL:-"llama2"}

echo "Waiting for Ollama to be ready at ${OLLAMA_HOST}..."

# Wait for Ollama to be ready using ollama list command
RETRY_COUNT=0
MAX_RETRIES=30
until ollama list > /dev/null 2>&1; do
  RETRY_COUNT=$((RETRY_COUNT + 1))
  if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    echo "Error: Ollama did not become ready after $MAX_RETRIES attempts"
    exit 1
  fi
  echo "Ollama is not ready yet, waiting... (attempt $RETRY_COUNT/$MAX_RETRIES)"
  sleep 2
done

echo "Ollama is ready!"

# Check if model already exists
echo "Checking if model ${MODEL} already exists..."
MODEL_LIST=$(ollama list 2>/dev/null | grep -E "^${MODEL}\s" || echo "")

if [ -n "$MODEL_LIST" ]; then
  echo "Model ${MODEL} already exists, skipping pull."
else
  echo "Pulling model: ${MODEL}"
  ollama pull ${MODEL}
  
  if [ $? -eq 0 ]; then
    echo "Successfully pulled model: ${MODEL}"
  else
    echo "Failed to pull model: ${MODEL}"
    exit 1
  fi
fi

echo "Initialization complete!"
