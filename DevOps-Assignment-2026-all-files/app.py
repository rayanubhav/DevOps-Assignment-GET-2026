import os
from flask import Flask, jsonify
from flask_cors import CORS

# --- Initialize App ---
app = Flask(__name__)
CORS(app) # Enable CORS for everything

# --- Routes ---

@app.route("/")
def home():
    """Health check route for the assignment evaluation"""
    return jsonify({
        "status": "Running",
        "project": "EmoCare+ Backend (DevOps Assignment Build)",
        "cloud": "AWS Free Tier"
    })

@app.route("/api/predict-stress", methods=["POST"])
def predict_stress():
    """Mocks the TensorFlow stress model"""
    # We return a static "safe" response without loading 500MB models
    return jsonify({
        "stress_level": 3, 
        "suggestions": ["Take a deep breath", "Drink water"],
        "note": "AI Model mocked for lightweight DevOps deployment"
    })

@app.route("/api/analyze-emotion", methods=["POST"])
def analyze_emotion():
    """Mocks the DeepFace analysis"""
    return jsonify({
        "emotion": "Happy",
        "confidence": 98.5,
        "note": "DeepFace mocked for lightweight DevOps deployment"
    })

@app.route("/api/chat", methods=["POST"])
def chat():
    """Mocks the Gemini/BERT Chatbot"""
    return jsonify({
        "response": "I am the DevOps-optimized version of MindWell. I am running on a lightweight container!",
        "detected_emotion": "Neutral"
    })

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)