params = {
    "hostname": "",
    "username": "",
    "password": "",
    "fullName": "",
}

input_file = "empty_cfg.ks"
output_file = "cfg.ks"

with open(input_file, "r", encoding="utf-8") as f:
    text = f.read()

for key, value in params.items():
    text = text.replace(f"<{key.upper()}>", value)

with open(output_file, "w", encoding="utf-8") as f:
    f.write(text)

print(f"Replacements done. Saved to {output_file}")
