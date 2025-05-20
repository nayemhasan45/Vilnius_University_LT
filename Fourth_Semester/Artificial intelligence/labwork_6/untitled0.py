import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

# Load tokenizer and model
tokenizer = AutoTokenizer.from_pretrained("gpt2")
gpt2 = AutoModelForCausalLM.from_pretrained("gpt2")

# Input phrase (you can change it if you want)
input_phrase = "al amin hossain nayem"
input_ids = tokenizer(input_phrase, return_tensors="pt").input_ids

# Number of tokens to generate (about ~25 words ≈ 30 tokens)
max_new_tokens = 30

# --- Greedy Decoding ---
output_ids = gpt2.generate(input_ids, max_new_tokens=max_new_tokens)
decoded_text = tokenizer.decode(output_ids[0], skip_special_tokens=True)
print("=== Greedy Decoding ===")
print(decoded_text)
print()

# --- Beam Search ---
beam_output = gpt2.generate(
    input_ids,
    num_beams=5,
    max_new_tokens=max_new_tokens,
)
decoded_text = tokenizer.decode(beam_output[0], skip_special_tokens=True)
print("=== Beam Search ===")
print(decoded_text)
print()

# --- Beam Search + Repetition Penalty ---
beam_output_penalty = gpt2.generate(
    input_ids,
    num_beams=5,
    repetition_penalty=1.2,
    max_new_tokens=max_new_tokens,
)
decoded_text = tokenizer.decode(beam_output_penalty[0], skip_special_tokens=True)
print("=== Beam Search + Repetition Penalty ===")
print(decoded_text)
print()

# --- Temperature Sampling ---
sampling_output_temp = gpt2.generate(
    input_ids,
    do_sample=True,
    temperature=0.7,   # moderate randomness
    max_new_tokens=max_new_tokens,
)
decoded_text = tokenizer.decode(sampling_output_temp[0], skip_special_tokens=True)
print("=== Temperature Sampling ===")
print(decoded_text)
print()

# --- Top-K Sampling ---
sampling_output_topk = gpt2.generate(
    input_ids,
    do_sample=True,
    top_k=50,
    max_new_tokens=max_new_tokens,
)
decoded_text = tokenizer.decode(sampling_output_topk[0], skip_special_tokens=True)
print("=== Top-K Sampling ===")
print(decoded_text)
print()

# --- Top-P (Nucleus) Sampling ---
sampling_output_topp = gpt2.generate(
    input_ids,
    do_sample=True,
    top_p=0.9,
    max_new_tokens=max_new_tokens,
)
decoded_text = tokenizer.decode(sampling_output_topp[0], skip_special_tokens=True)
print("=== Top-P (Nucleus) Sampling ===")
print(decoded_text)
print()
