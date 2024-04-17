#!/bin/bash
echo "VLLM_ARGS originally: $VLLM_ARGS"

if [ -z "$VLLM_ARGS" ]
then
    if [ ! -z "$MODEL_CMD" ]
    then
        VLLM_ARGS="$MODEL_CMD"  
    else
        VLLM_ARGS="--model-id TheBloke/Llama-2-7B-chat-GPTQ --quantize gptq"
    fi
fi

echo "using args: $VLLM_ARGS" | tee -a /root/debug.log

MODEL_LAUNCH_CMD="vllm.entrypoints.openai.api_server"
MODEL_PID=$(ps aux | grep "$MODEL_LAUNCH_CMD" | grep -v grep | awk '{print $2}')

if [ -z "$MODEL_PID" ]
then
    echo "starting model download" 
    echo $VLLM_ARGS
    python3 -m vllm.entrypoints.openai.api_server $VLLM_ARGS
    echo "launched model" | tee -a /root/debug.log
else
    echo "model already running" | tee -a /root/debug.log
fi