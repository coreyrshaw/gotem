## Table of Contents
- [1. API Documentation](#3-api-documentation)
  - [1.1. Users](#31-salesforce)
    - [User Login](#community-user-login)
  + [1.2. AWS](#32-aws)
    - [Upload to S3](#upload-to-s3)
- [2. Contributors](#4-contributors)

# 1. API Documentation
This is the API documentation for the back end of App.

## 1.1. Users

### User Login

*This route is present for the login of users*

**Path:**

Request Type | URL
--- | ---
 POST |  https://amoss.emory.edu/loginParticipant

**Params:**

Name | Type | Description
--- | --- | ---
participantID | string | **Required.** User's registered ID.
password | string | **Required.** Password provided must be at least 6 characters long.

**Status Codes:**

Code | Type | Description
---|---|---
200 | Success | Server has processed the request and has successfully updated the user.
401 | Error | Unauthorized. Incorrect username and/or password combination.

**Example Body:**

```
{
  "participantID": 9977,
  "password": "tester"
}
```

**Example Response:**

```
{
    "token":"eyJhbGciOiJIUzI1NiIsIc23kpXVCJ9.eyJwYXJ0aWNpcGFudF9pZCI6OTk4ODAwMDAwMCwiY2FwYWNpdHkiOiJjb29yZGluYXRvciIsInN0dWR5IjoidGVzdCIsImV4cCI6MTU2NTg5MTgyMiwiaXNzIjoibG9jYWxob3N0OjgwODAifQ.pMJppHKjUPOp0qF4ErldbHkzjOI8gaG9MEZ-oj_UHyU", 
    "capacity":"coordinator"
}
```

**Example Failure Response:**

```
{
    "error": "json parsing error",
    "error description": "key or value of json is formatted incorrectly"
}
```

## 1.2. AWS

### Upload to S3

*This route is present for the Amazon S3 file uploads*

**Path:**

Request Type | URL
--- | ---
POST | https://amoss.emory.edu/upload

**Headers:**

Name | Type | Description
--- | --- | ---
Authorization | string | **Required.** Mars token.
weekMillis | long | **Required.** Timestamp

**Params:**

Name | Type | Description
--- | --- | ---
upload | string | **Required.** Files to be uploaded.

**Status Codes:**

Code | Type | Description
---|---|---
200 | Success | Server has processed the request and has successfully updated the user.
422 | Error | Unprocessable Entry. Specified parameters are invalid.

**Example Header:**

```
Authorization: Mars fdsfsdafeyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZAI6OX0.1YMgT2O8ccKdqvrJph1AcSPeLJpRlVvEgITTXxKWrZY,
"weekMillis": 534118400000
```

**Example Body:** (form)

```
{
  "folder: "moyoiostestdata"  // AWS bucket
  "upload": "534118400000.mz"
}
```

**Example Response:**

```
{
  "success": "you have completed upload to amoss_mhealth"
}
```
