Here is the "Hellas Guardian", an AI-powered chatbot developed for Hellas Direct, a leading Greek insurance company. This repository contains the full technical implementation of the project, including all core components.

Key Components: Mobile app built with Flutter (Android & iOS), LLM integration via AWS Bedrock (prompt orchestration), Knowledge base in JSON format for RAG-style retrieval, Voice support with Speech-to-Text (STT) and Text-to-Speech (TTS), Microservices for gateway routing and dialogue handling

Chatbot Functions:
Upon launching the app, users are presented with two main options:
Roadside Assistance (Team A) 
Accident Reporting (Team B) 

The chatbot is capable of:
Guiding users step-by-step through the incident reporting process
Automatically identifying whether the case concerns Team A or Team B
Extracting and structuring key information (e.g., location, license plate, issue type)
Supporting both text-based and voice-based interactions

Technical Highlights:
-LLM integration using AWS Bedrock
-RAG-style retrieval with embedding-based knowledge lookup
-Gateway APIs for scalable orchestration of services
-Modular design for future B2B licensing, multilingual support, and analytics
