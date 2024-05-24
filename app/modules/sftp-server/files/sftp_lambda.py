import os
import json
import hvac
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    resp_data = {}
    if 'username' not in event or 'serverId' not in event:
        print("Incoming username or serverId missing  - Unexpected")
        return resp_data
    input_username = event['username']
    print("Username: {}, ServerId: {}".format(input_username, event['serverId']))
    if 'password' in event:
        input_password = event['password']
    else:
        print("No password, checking for SSH public key")
        input_password = ''
    # Lookup user's secret which can contain the password or SSH public keys
    resp = get_secret("users/" + input_username)
    if resp is not None:
        resp_dict = json.loads(resp)
    else:
        print("Vault exception thrown")
        return {}
    if input_password != '':
        if 'Password' in resp_dict:
            resp_password = resp_dict['Password']
        else:
            print("Unable to authenticate user - No field match in Secret for password")
            return {}
        if resp_password != input_password:
            print("Unable to authenticate user - Incoming password does not match stored")
            return {}
    else:
        if 'PublicKey' in resp_dict:
            resp_data['PublicKeys'] = [resp_dict['PublicKey']]
        else:
            print("Unable to authenticate user - No public keys found")
            return {}
    if 'Role' in resp_dict:
        resp_data['Role'] = resp_dict['Role']
    else:
        print("No field match for role - Set empty string in response")
        resp_data['Role'] = ''
    if 'Policy' in resp_dict:
        resp_data['Policy'] = resp_dict['Policy']
    if 'HomeDirectoryDetails' in resp_dict:
        print("HomeDirectoryDetails found - Applying setting for virtual folders")
        resp_data['HomeDirectoryDetails'] = resp_dict['HomeDirectoryDetails']
        resp_data['HomeDirectoryType'] = "LOGICAL"
    elif 'HomeDirectory' in resp_dict:
        print("HomeDirectory found - Cannot be used with HomeDirectoryDetails")
        resp_data['HomeDirectory'] = resp_dict['HomeDirectory']
    else:
        print("HomeDirectory not found - Defaulting to /")
    print("Completed Response Data: "+json.dumps(resp_data))
    return resp_data

def get_secret(id):
    
    vault_addr = os.getenv('VAULT_ADDR')
    vault_token = os.getenv('VAULT_TOKEN')
    
    print("Vault Address: " + vault_addr)
    
    client = hvac.Client(url=vault_addr, token=vault_token)
    try:
       secret_version_response = client.secrets.kv.v2.read_secret_version(
          path=id,
          mount_point='SFTP'
       )
       if 'data' in secret_version_response and 'data' in secret_version_response['data']:
            return json.dumps(secret_version_response['data']['data'])
       else:
            print("Secret not found or incorrect format")
            return None
    
    except hvac.exceptions.VaultError as err:
        print('Error talking to Vault: ' + str(err))
        return None

