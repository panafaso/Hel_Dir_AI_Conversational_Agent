from elevenlabs.client import ElevenLabs

# Δημιουργία πελάτη με API key απευθείας
elevenlabs = ElevenLabs(
    api_key="sk_b24dc6e4277244ca51949f37205576af0567b48a9b35e2f8"
)

# Μετατροπή κειμένου σε ήχο
audio = elevenlabs.text_to_speech.convert(
    text="Ειμαι ο Γιάννης και είμαι 20 χρονών. Είμαι φοιτητής στο τμήμα Πληροφορικής του Πανεπιστημίου Αθηνών.",
    voice_id="JBFqnCBsd6RMkjVDRZzb",
    model_id="eleven_multilingual_v2",
    output_format="mp3_44100_128",
)

# Αποθήκευση σε αρχείο
with open("output.mp3", "wb") as f:
    for chunk in audio:
        f.write(chunk)

print("Το αρχείο αποθηκεύτηκε ως output.mp3")