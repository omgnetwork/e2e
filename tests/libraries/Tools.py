import base64

def base_64_encode(input):
    return base64.b64encode(input.encode())

def build_authentication(schema, id, secret):
    return schema.encode() + " ".encode() + base_64_encode(id + ":" + secret)
