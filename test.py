from hashlib import sha256

password = "password123"

print(sha256(password.encode()).hexdigest())
