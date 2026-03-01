# ToneSafe

**A communication coach that detects harmful language patterns and builds empathy – built for Apple's Swift Student Challenge 2026.**

ToneSafe goes beyond simple toxicity detection. It uses on-device machine learning to analyze text messages for bullying, manipulation, passive aggression, and hate speech – then helps you *feel* the impact and *learn* to communicate better.

Everything runs entirely on-device. No servers. No data leaves your phone.

---

## Features

### Analyze
Type or paste any message and ToneSafe classifies it into one of five categories – bullying, hate speech, manipulation, passive aggression, or healthy – with a confidence score, sentiment analysis, and highlighted trigger words.

### Empathy Mode
The standout feature. After analysis, tap "Feel the Impact" to experience a cinematic visualization of how harmful words feel to the recipient. The screen darkens, particles float, the text grows heavier — and then the words shatter apart. Designed to make you pause before hitting send.

### Rewrite Engine
Every harmful message gets a healthier rewrite that preserves the original intent. Side-by-side before/after comparison with an explanation of what changed and why it works.

### Learn Mode
Interactive lessons on recognizing toxic communication patterns, with real examples and quizzes. Covers bullying, manipulation, passive aggression, and hate speech.

---

## Tech Stack

| Framework | Usage |
|-----------|-------|
| **SwiftUI** | All UI, animations, navigation, and the multi-phase Empathy Mode experience |
| **Core ML** | Custom text classification model trained with Create ML (5-class classifier) |
| **NaturalLanguage** | Sentiment analysis via `NLTagger`, word tokenization via `NLTokenizer` |
| **Canvas API** | Real-time particle system rendering in Empathy Mode |
| **UIKit** | Haptic feedback (`UIImpactFeedbackGenerator`, `UINotificationFeedbackGenerator`) |

---

## Architecture

```
ToneSafe/
├── ToneSafeApp.swift                  # App entry point with onboarding flow
├── DesignSystem.swift                 # Custom color palette, typography, and reusable modifiers
│
├── Models/
│   └── AnalysisResult.swift           # ToneCategory enum + AnalysisResult data model
│
├── Services/
│   ├── ClassifierService.swift        # Core ML model loading, inference, and NLP analysis
│   └── RewriteService.swift           # Loads RewriteBank.json, matches patterns to suggestions
│
├── Views/
│   ├── OnboardingView.swift           # 4-screen intro flow
│   ├── ContentView.swift              # Tab navigation (Home, Analyze, Learn)
│   ├── HomeView.swift                 # Mission statement, cyberbullying statistics
│   ├── AnalyzeView.swift              # Text input, example messages, analysis trigger
│   ├── ResultView.swift               # Classification result with severity ring
│   ├── EmpathyView.swift              # Multi-phase cinematic empathy experience
│   ├── RewriteView.swift              # Before/after rewrite comparison
│   └── LearnView.swift                # Lessons, examples, and quizzes
│
├── Components/
│   ├── SeverityRing.swift             # Animated circular severity gauge
│   └── HighlightedTextView.swift      # Text view with flagged words highlighted
│
└── Resources/
    ├── ToneClassifier.mlmodelc        # Trained Core ML text classifier
    ├── RewriteBank.json               # Healthier rewrite suggestions by category
    └── ImpactStats.json               # Cyberbullying statistics
```

---

## Core ML Model

The text classifier was trained using **Create ML** with the following setup:

- **Type:** Text Classifier (5-class)
- **Categories:** `bullying`, `hate_speech`, `manipulation`, `passive_aggression`, `healthy`
- **Training data:** ~3,500 labeled examples
  - Bullying & hate speech sourced from the [Jigsaw Toxic Comment Classification](https://www.kaggle.com/datasets/julian3833/jigsaw-toxic-comment-classification-challenge) public dataset
  - Manipulation & passive aggression examples were hand-written across diverse contexts (relationships, workplace, school, online)
  - Healthy examples sampled from non-toxic comments in the same dataset
- **Validation F1 scores:** 0.62–0.85 across categories
- **Model size:** < 1 MB

The classifier is supplemented by `NLTagger` sentiment analysis and keyword pattern matching for richer analysis.

---

## Design Philosophy

ToneSafe uses a custom design system ("Empathetic Minimalism") built to feel warm and human:

- **Warm cream background** (`#FAF7F2`) instead of pure white — feels approachable, not clinical
- **Single bold accent** (deep electric blue) for all interactive elements
- **Serif typography** in emotional moments (Empathy Mode), rounded sans-serif elsewhere
- **Muted semantic colors** — sage green (healthy), amber (caution), burnt orange (warning), deep red (danger), plum (severe)
- **Forced light mode** — the app's visual identity is built around the warm palette
- **Haptic feedback** at every meaningful interaction

---

## Getting Started

1. Clone this repository
2. Open the `.swiftpm` package in Xcode 16+
3. Build and run on an iOS 18+ simulator or device

> **Note:** The Core ML model file (`ToneClassifier.mlmodelc`) must be included in the project bundle. If you want to retrain the model, see the `data/` directory for the training pipeline.

---

## Training Your Own Model

The `data/` directory contains the Python scripts used to prepare training data:

```bash
# Install dependencies
pip3 install pandas

# Download train.csv from the Jigsaw Kaggle dataset and place it in data/

# Run the preparation script
cd data/
python3 prepare_dataset.py

# Output: training_data.csv – ready for Create ML
```

Then open Create ML in Xcode, create a Text Classifier, and drag in `training_data.csv`.

---

## Inspiration

ToneSafe grew from [Sentiment Aura](https://github.com/patilchirag2392/sentiment-aura), a web app I built in November 2025 that analyzed emotional tone from spoken words. ToneSafe takes that same core idea of making the invisible visible in our communication and pushes it further: from speech to text, from detection to empathy, and from web to native iOS with on-device ML.

---

## Acknowledgments

- [Jigsaw/Google](https://www.kaggle.com/datasets/julian3833/jigsaw-toxic-comment-classification-challenge) for the Toxic Comment Classification dataset
- Apple's Core ML, NaturalLanguage, and Create ML frameworks
- Cyberbullying statistics sourced from the Cyberbullying Research Center, Pew Research Center, and the National Center for Education Statistics
