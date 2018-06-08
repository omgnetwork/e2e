import base64

def base_64_encode(input):
    return base64.b64encode(input.encode())

def build_admin_user_authentication(schema, user_id, authentication_token):
    return schema.encode() + " ".encode() + base_64_encode(user_id + ":" + authentication_token)
