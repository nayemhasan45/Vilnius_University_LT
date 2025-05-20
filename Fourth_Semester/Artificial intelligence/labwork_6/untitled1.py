import torch
import transformers
from transformers import AutoTokenizer
from transformers import AutoModelForCausalLM

# Load the GPT-2 tokenizer
tokenizer = AutoTokenizer.from_pretrained("gpt2")

#  Load GPT-2 model
gpt2 = AutoModelForCausalLM.from_pretrained("gpt2")


input_ids = tokenizer("toyota supra is my dream car", return_tensors="pt").input_ids
# Feeding Input to the Model
outputs = gpt2(input_ids)
#Finding the Most Likely Next Token
final_logits = gpt2(input_ids).logits[0, -1]  # The last set of logits
most_likely_token_id = final_logits.argmax()
most_likely_token = tokenizer.decode(most_likely_token_id)

#Generating text using Greedy Decoding
output_ids = gpt2.generate(
    input_ids,
    max_new_tokens=40,
    attention_mask=torch.ones_like(input_ids),
    pad_token_id=tokenizer.eos_token_id
    )
decoded_text = tokenizer.decode(output_ids[0])
print(f"Generated text: {decoded_text}")

