#!/bin/bash

# Install required tools if not present
if ! command -v git-lfs &> /dev/null; then
    echo "Installing git-lfs..."
    sudo apt-get install git-lfs
    git lfs install
fi

if ! command -v python3 &> /dev/null; then
    echo "Installing Python3..."
    sudo apt-get install python3 python3-pip
fi

# Clone the model repository
echo "Downloading ChatTS-14B model..."
git lfs install
git clone https://huggingface.co/bytedance-research/ChatTS-14B
cd ChatTS-14B || exit

# Install required Python packages
echo "Installing conversion dependencies..."
pip install torch transformers sentencepiece llama-cpp-python

# Convert to GGUF format with 8-bit quantization
echo "Converting model to GGUF format with 8-bit quantization..."
python3 -m llama_cpp.convert --model-path . --outfile chatts-14b-f16.gguf --outtype f16
python3 -m llama_cpp.quantize chatts-14b-f16.gguf chatts-14b-q8_0.gguf q8_0

echo "Conversion complete! Model saved as chatts-14b-q8_0.gguf"
