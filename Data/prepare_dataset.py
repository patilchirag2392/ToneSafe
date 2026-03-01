"""
ToneSafe — Dataset Preparation Script v2
=========================================
Takes the Jigsaw Toxic Comment Classification CSV and maps it
into ToneSafe's 5-class schema for Create ML training.

Now includes expanded manipulation & passive aggression examples
and better bullying curation.

Usage:
    1. Download train.csv from Kaggle (Jigsaw Toxic Comment dataset)
    2. Place all files in the same directory
    3. Run: python prepare_dataset.py
    4. Output: training_data.csv (ready for Create ML)
"""

import pandas as pd
import os
import random

random.seed(42)

# ── Config ──────────────────────────────────────────────────────────
INPUT_FILE = "train.csv"  # Jigsaw dataset
OUTPUT_FILE = "training_data.csv"
SAMPLES_PER_CLASS = 700  # Target count per category (balanced across all 5)

# ── Load Jigsaw data ───────────────────────────────────────────────
print("Loading Jigsaw dataset...")
df = pd.read_csv(INPUT_FILE)
print(f"  Loaded {len(df)} rows")

# ── Map Jigsaw multi-labels → ToneSafe single label ───────────────
# Tighter mapping: only use high-confidence labels for bullying
# to reduce noise in that category.

def map_label(row):
    # Hate speech: identity-based attacks
    if row["identity_hate"] == 1:
        return "hate_speech"
    # Bullying: direct personal attacks (insults + threats)
    if row["threat"] == 1:
        return "bullying"
    if row["insult"] == 1 and row["severe_toxic"] == 1:
        return "bullying"
    if row["insult"] == 1:
        return "bullying"
    # Skip generic toxic/obscene — too noisy, weakens the bullying class
    if row["toxic"] == 1 or row["obscene"] == 1 or row["severe_toxic"] == 1:
        return "__skip__"
    return "healthy"

df["label"] = df.apply(map_label, axis=1)
df = df[df["label"] != "__skip__"].reset_index(drop=True)

# ── Clean text ─────────────────────────────────────────────────────
def clean_text(text):
    if not isinstance(text, str):
        return ""
    text = " ".join(text.split())
    # Tighter length filter — keep messages that feel like real messages
    if len(text) < 15 or len(text) > 400:
        return ""
    return text

df["text"] = df["comment_text"].apply(clean_text)
df = df[df["text"] != ""].reset_index(drop=True)

# ── Balance Jigsaw classes ─────────────────────────────────────────
print("\nJigsaw class distribution before balancing:")
print(df["label"].value_counts())

balanced_dfs = []
for label in ["healthy", "bullying", "hate_speech"]:
    subset = df[df["label"] == label]
    if len(subset) >= SAMPLES_PER_CLASS:
        balanced_dfs.append(subset.sample(n=SAMPLES_PER_CLASS, random_state=42))
    else:
        print(f"  ⚠ '{label}' only has {len(subset)} samples (target: {SAMPLES_PER_CLASS})")
        balanced_dfs.append(subset)

balanced = pd.concat(balanced_dfs, ignore_index=True)

# ── Load manipulation & passive aggression examples ────────────────
manip_files = ["manipulation_examples.csv", "manipulation_examples_v2.csv"]
passive_files = ["passive_aggression_examples.csv", "passive_aggression_examples_v2.csv"]

def load_example_files(file_list, label_name):
    frames = []
    for f in file_list:
        if os.path.exists(f):
            loaded = pd.read_csv(f)
            print(f"  Loaded {len(loaded)} {label_name} examples from {f}")
            frames.append(loaded)
        else:
            print(f"  ⚠ {f} not found — skipping")
    if frames:
        combined = pd.concat(frames, ignore_index=True)
        # Cap at SAMPLES_PER_CLASS
        if len(combined) > SAMPLES_PER_CLASS:
            combined = combined.sample(n=SAMPLES_PER_CLASS, random_state=42)
        return combined
    return pd.DataFrame(columns=["text", "label"])

print("\nLoading additional examples...")
manip_df = load_example_files(manip_files, "manipulation")
passive_df = load_example_files(passive_files, "passive_aggression")

# ── Combine everything ─────────────────────────────────────────────
final = pd.concat([balanced, manip_df, passive_df], ignore_index=True)[["text", "label"]]
final = final.sample(frac=1, random_state=42).reset_index(drop=True)  # Shuffle

# ── Output ─────────────────────────────────────────────────────────
final.to_csv(OUTPUT_FILE, index=False)

print(f"\n✅ Saved {OUTPUT_FILE}")
print(f"\nFinal class distribution:")
print(final["label"].value_counts())
print(f"\nTotal samples: {len(final)}")
print(f"\n🎯 Ready for Create ML!")
