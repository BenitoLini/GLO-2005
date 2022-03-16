def hachage(string):
    nouvelle_string = ""
    for element in string:
        if element != '"':
            element = chr(ord(element)+10)
        nouvelle_string += element
    return nouvelle_string


