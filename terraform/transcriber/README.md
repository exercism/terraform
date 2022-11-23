# Transcriber

This machine's purpose is to transcribe and diarize audio files that were recorded for the podcast.

## Instance

- Platform: Ubuntu
- AMI ID: mi-0377c4ce4622ce5b0
- AMI name: Deep Learning AMI GPU TensorFlow 2.10.0 (Ubuntu 20.04) 20221104

Use `50GB` of storage.

## Transcribing + diarization

To run the transcribing + diarization script, you do:

```shell
HUGGING_FACE_AUTH_TOKEN=<token> python3 transcripe.py <audio_file>
```

The `HUGGING_FACE_AUTH_TOKEN` is required for the diarization library we used.
You can find/create a token at https://huggingface.co/settings/tokens.

The `<audio_file>` argument is the `.wav` file that you want to transcribe.
