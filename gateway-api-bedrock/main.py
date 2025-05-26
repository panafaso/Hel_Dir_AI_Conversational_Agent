import boto3
from botocore.exceptions import ClientError
import json
import uuid
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

class MessageInput(BaseModel):
    message: str
    session_id: str | None = None

def send_message_to_agent(client, agent_id, agent_alias_id, session_id, message):
    try:
        response = client.invoke_agent(
            agentId=agent_id,
            agentAliasId=agent_alias_id,
            sessionId=session_id,
            inputText=message
        )
        response_text = ""
        for event in response.get("completion", []):
            if "chunk" in event and "bytes" in event["chunk"]:
                try:
                    chunk_data = event["chunk"]["bytes"].decode('utf-8')
                    if chunk_data:
                        chunk = json.loads(chunk_data) if chunk_data.startswith('{') else {"text": chunk_data}
                        if "text" in chunk:
                            response_text += chunk["text"]
                except json.JSONDecodeError:
                    response_text += chunk_data
        return response_text
    except ClientError as e:
        raise HTTPException(status_code=500, detail=f"Error calling Bedrock agent: {e.response['Error']['Message']}")

@app.post("/send-message")
async def invoke_bedrock_agent(input: MessageInput):
    aws_access_key_id = "ASIAWJQQQEAC7AVPGS4K"
    aws_secret_access_key = "w623/x+iD1h+HIMuTPsLtnCpN89XsI2A9+lYCedm"
    aws_session_token = ("IQoJb3JpZ2luX2VjEFIaCXVzLWVhc3QtMSJHMEUCIG4iSw6aIp1/D9IBmO9IOhnis1Ot9XYzjR8imduUlL/"
                         "dAiEAtA6riMJZ4BlNcw2brkPzy6jZ/Qx6UivHbEGT1Mv77JMqmQIIGxABGgw0MzI3NTI1NjYyNzciDOrYClTXxy4S"
                         "dD5pIyr2AZ1aWWhpvnuUt3DexeJCMcFQ8bytJsrbLqzmYZ6nrKoBQIZ8Cjl3DM2TDPXLNpwK/J3aCZbz1zNa2efqd1"
                         "3aikDdXnwAsIpsWTmm38bksDXmzHrpG+kzAh8VhlGkzJfQXUbF8Xs2Vgt4982NwJfWZllUIJqujrzYTSvJFjyf/4ud"
                         "jxUJ+fTgDSuRi4kMISAVD/8Eto6okEvpKiYXuId42qeNvHm8CWIcQ0uulg1YamBwjN1EJQ4J8qTllHNAoDYZXoxj7P"
                         "307JVOh6A6+YfpTIjB0s5LJhChowbh7+xrOUcEIo3SaGFIKzg4xpc7+rmvHE42s/aGRTD8hsjBBjqdAelhT6F9oMgA"
                         "8lftD7FgdSVqlnQbsGW83LWqnunm85F+3LgspclvHl0aVAYEz14GvloNGUFTE4uiFD9L2BTMvOJE3yn9OFbnoxl9bm"
                         "sn17JR32xNnB0Bcpg1/paPawcz3tQIkMXVMfXSMDsSd/jrZprVMGJRKTw8dYOyk1b/wowtCXwXZLT4NGAC8Rad2Nmd"
                         "KTVGf467i5X3Tjrj+G8=")
    region_name = "us-west-2"

    client = boto3.client(
        "bedrock-agent-runtime",
        region_name=region_name,
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        aws_session_token=aws_session_token,
    )

    agent_id = "GH4F5YSXXY"
    agent_alias_id = "ENSS1E5E4L"
    session_id = input.session_id if input.session_id else str(uuid.uuid4())

    response = send_message_to_agent(client, agent_id, agent_alias_id, session_id, input.message)
    if not response:
        raise HTTPException(status_code=500, detail="No response from agent")
    return {"response": response, "session_id": session_id}