# Lob Take Home Coding Challenge

## Start the app

`docker-compose up`

## Endpoints

**Create an address**

`POST` `http://localhost:4000/addresses`

request body

```
{
  "line1": "185 Berry St",
  "line2": "Suite 6100",
  "city": "San Francisco",
  "state": "CA",
  "zip": "94107"
}
```

response body
```
{
  "city": "San Francisco",
  "id": "5ce3084b-7a04-4f86-b56e-d78b4c38ee59",
  "line1": "185 Berry St",
  "line2": "Suite 6100",
  "state": "CA",
  "zip": "94107"
}
```

***

**List all addresses**

`GET` `http://localhost:4000/addresses`

response body
```
[
  {
    "city": "San Francisco",
    "id": "5ce3084b-7a04-4f86-b56e-d78b4c38ee59",
    "line1": "185 Berry St",
    "line2": "Suite 6100",
    "state": "CA",
    "zip": "94107"
  }
]
```

***

**Search Addresses**

`GET` `http://localhost:4000/addresses?search=Su`

response body
```
[
  {
    "city": "San Francisco",
    "id": "5ce3084b-7a04-4f86-b56e-d78b4c38ee59",
    "line1": "185 Berry St",
    "line2": "Suite 6100",
    "state": "CA",
    "zip": "94107"
  }
]
```

***

**Delete Address**

`DELETE` `http://localhost:4000/addresses/5ce3084b-7a04-4f86-b56e-d78b4c38ee59`

***

**Update Address**

`PUT` `http://localhost:4000/addresses/5ce3084b-7a04-4f86-b56e-d78b4c38ee59`

request body

```
{
  "line1": "1 Grand Avenue",
  "city": "San Luis Obispo",
  "state": "CA",
  "zip": "93407"
}
```

response body
```
{
  "id": "5ce3084b-7a04-4f86-b56e-d78b4c38ee59",
  "line1": "1 Grand Avenue",
  "city": "San Luis Obispo",
  "state": "CA",
  "zip": "93407"
}
```