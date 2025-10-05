import os

output_dir = "./outputs"

print("=== Monitoring JES Output ===")
for root, dirs, files in os.walk(output_dir):
    for f in files:
        path = os.path.join(root, f)
        with open(path) as file:
            content = file.read()
            if "ERROR" in content or "ABEND" in content:
                print(f"⚠️ Problem detected in {f}")
            else:
                print(f"✅ Job {f} ran successfully.")
