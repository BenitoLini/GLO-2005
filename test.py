from hashlib import sha256

def hachage(string):
    nouvelle_string = ""
    for element in string:
        if element != '"':
            element = chr(ord(element)+10)
        nouvelle_string += element
    return nouvelle_string

password = "password13"
print(sha256(password.encode()).hexdigest())

