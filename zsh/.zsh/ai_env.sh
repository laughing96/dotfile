
ai_path=/opt
export HF_HOME=$ai_path/AI/hf
export TRANSFORMERS_CACHE=$ai_path/AI/hf
export HF_HUB_CACHE=$ai_path/AI/hf
# download
export HF_HUB_ENABLE_HF_TRANSFER=1
# mirror
export HF_ENDPOINT=https://hf-mirror.com
alias hfd="/Users/dl/Code/hfd.sh"

#
export WHISPER_CACHE_DIR=$ai_path/AI/whisper

# ollama 通过launchctl 的brew 
#
# pytorch
export TORCH_HOME=$ai_path/AI/torch
