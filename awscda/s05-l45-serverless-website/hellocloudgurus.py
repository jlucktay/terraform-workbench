def lambda_handler(event, context):
    print("In Lambda handler")

    resp = {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*"
        },
        "body": "James Lucktaylor"
    }

    return resp
