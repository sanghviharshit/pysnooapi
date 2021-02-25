# Introduction

This is a Python 3.8+ module aiming to interact with the Snoo Smart Sleeper from happiestbaby.com API.

# [Homeassistant](https://home-assistant.io)
[Homeassistant](https://home-assistant.io) has a [custom Snoo component](https://github.com/sanghviharshit/ha-snoo) leveraging this package.
This can be added into HACS as a custom repository.

# Getting Started

## Installation

```python
pip install pysnoo
```

## Usage

`pysnoo` starts within an [aiohttp](https://aiohttp.readthedocs.io/en/stable/)
`ClientSession`:

```python
import asyncio

from aiohttp import ClientSession


async def main() -> None:
    """Create the aiohttp session and run."""
    async with ClientSession() as websession:
      # YOUR CODE HERE


asyncio.get_event_loop().run_until_complete(main())
```

To get all Snoo devices associated with an account:

```python
import asyncio

from aiohttp import ClientSession

import pysnooapi

async def main() -> None:
    """Create the aiohttp session and run."""
    async with ClientSession() as websession:
      snoo = await pysnoo.login('<EMAIL>', '<PASSWORD>', websession)

      # Returns snoo devices
      devices = snoo.devices
      # >>> {"serial_number123": <Device>, "serial_number456": <Device>}


asyncio.get_event_loop().run_until_complete(main())
```

## API Methods

These are coroutines and need to be `await`ed – see `example.py` for examples.

* `login`: Login method that authenticates user and also updates device information
* `authenticate`: Authenticate (or re-authenticate) to Snoo. Call this to
  re-authenticate immediately after changing username and/or password otherwise
  new username/password will only be used when token has to be refreshed.
* `get_account`: Retrieve account details
* `update_device_info`: Retrieve info and status for devices including account, baby, config and session
* `get_session_for_account`: Retrieve session details for the account. Oddly, this is not linked to a device.
* `get_configs_for_device`: Retrieve config details for the devices
* `get_baby_for_account`: Retrieve baby details associated with the account
* `get_session_stats_avg_for_account`: Retrieve aggregated session stats for the week
* `get_session_stats_daily_for_account`: Retrieve aggregated session stats for the given date

## Device Methods

All of the routines on the `SnooDevice` class are coroutines and need to be
`await`ed – see `example.py` for examples.

* `update`: get the latest device info (state, etc.). Note that
  this runs api.update_device_info and thus all accounts/devices will be updated

## API Properties

* `account`: dictionary with the account
* `devices`: dictionary with all devices
* `last_state_update`: datetime (in UTC) last state update was retrieved
* `password`: password used for authentication. Can only be set, not retrieved
* `username`: username for authentication.

## Account Properties

* `userId`: User ID for the account
* `email`: Email for the account
* `givenName`: Name for the account
* `surname`: Last name for the account
* `region`: Region for the account

### Example
```
{
    "email": "abc@xyz.com",
    "givenName": "ABC",
    "surname": "XYZ",
    "userId": "afdgjfhdsgsg",
    "region": "US"
}
```

## Session Properties

* `startTime`: datetime when the current or last session started
* `endTime`: datetime when the last session ended or None if current session is active
* `levels`: sequence of levels in current session sorted by time. (Last level is the latest)

### Example
```
{
    "startTime": "2021-02-01T01:02:34.456Z",
    "endTime": "2021-02-01T04:02:34.456Z",
    "levels": [
        {
            "level": "BASELINE"
        },
        {
            "level": "LEVEL1"
        },
        {
            "level": "BASELINE"
        },
        {
            "level": "ONLINE"
        }
    ]
}
```
## Config Properties
### Example
```
{
    "config": "lvl0",
    "premieLock": false,
    "weaning": false,
    "whiteNoiseLevel": "lvl-1",
    "motionLimiter": false,
    "minimalLevel": "baseline",
    "networkStatus": {
        "lastPresence": "2021-01-01T11:02:35.160Z",
        "lastProvisionSuccess": "2021-01-01T23:45:49.752Z",
        "lastSSID": {
            "name": "ABC",
            "updatedAt": "2021-01-01T06:56:18.364Z"
        },
        "isOnline": true
    }
}
```

## Baby Properties

### Example
```
{
    "settings": {
        "responsivenessLevel": "lvl0",
        "minimalLevelVolume": "lvl-1",
        "soothingLevelVolume": "lvl0",
        "minimalLevel": "baseline",
        "motionLimiter": false,
        "weaning": false,
        "carRideMode": true,
        "offlineLock": false,
        "daytimeStart": 8
    },
    "disabledLimiter": false,
    "_id": "asfkhdsgfjsdkhkjdsg",
    "pictures": [
        {
            "id": "sdfsdgkjhihr3r324_dsfh34tjh5kth5k",
            "mime": "image/png",
            "encoded": false,
            "updatedAt": "2020-02-13T01:36:14.717Z"
        }
    ],
    "createdAt": "2020-02-12T01:12:12.123Z",
    "updatedAt": "2020-02-12T01:12:12.123Z",
    "babyName": "Baby",
    "birthDate": "2020-02-12T01:12:12.123Z",
    "sex": "Female",
    "updatedByUserAt": "2020-02-12T01:12:12.123Z"
}
```
## Device Properties

* `account`: Return account associated with device
* `device_id`: Return the device ID (serial number)
* `device`: Return the device details
* `firmware_version`: Return the family in which this device lives
* `name`: Return the device name
* `is_online`: Return whether the device is online
* `is_on`: Return whether the device is on (in motion)
* `state`: Return the current state of the device (ONLINE, WEANING_BASELINE, BASELINE, LEVEL1, LEVEL2, LEVEL3 and LEVEL4)
* `baby`: Return the baby details
* `session`: Return the session details
* `config`: Return the config details
* `last_update`: Returns datetime when the device was last updated

### Device Details

The device details from device properties

#### Example
```
{
    "serialNumber": "243545643656",
    "createdAt": "2020-01-02T18:01:42.124Z",
    "updatedAt": "2021-02-01T11:00:12.123Z",
    "baby": "krgh2354543jhg6jh5gj",
    "lastProvisionSuccess": "2020-12-01T01:45:49.752Z",
    "firmwareUpdateDate": "2021-01-01T20:53:49.782Z",
    "firmwareVersion": "v1.14.12",
    "lastSSID": {
        "name": "ABC",
        "updatedAt": "2020-01-03T06:56:18.364Z"
    },
    "timezone": "America/Los_Angeles"
}
```

## Session Stats Properties
### Daily Session Aggregates
#### Example
```
{
    "levels": [
        {
            "sessionId": "1654751546",
            "type": "asleep",
            "startTime": "2021-01-31 08:00:00.000",
            "stateDuration": 1279,
            "isActive": false
        },
        {
            "sessionId": "1681977280",
            "type": "asleep",
            "startTime": "2021-01-31 08:33:43.084",
            "stateDuration": 63,
            "isActive": false
        },
        ...
    ],
    "detailedLevels": [
        {
            "sessionId": "1654751546",
            "level": "BASELINE",
            "hold": false,
            "settings": {
                "responsivenessLevel": "lvl0",
                "minimalLevelVolume": "lvl-1",
                "soothingLevelVolume": "lvl0",
                "minimalLevel": "baseline",
                "motionLimiter": false,
                "weaning": false,
                "carRideMode": false
            },
            "isActive": false,
            "levelDetails": {
                "start": "2021-01-31 06:57:20.894",
                "duration": 5038
            },
            "sessionDetails": {
                "start": "2021-01-31 06:57:20.894",
                "duration": 5038
            },
            "type": "asleep",
            "startTime": "2021-01-31 08:00:00.000",
            "stateDuration": 1279
        },
        ...
    ],
    "naps": 2,
    "longestSleep": 10032,
    "totalSleep": 18096,
    "daySleep": 3434,
    "nightSleep": 14662,
    "nightWakings": 4,
    "timezone": null
}
```

### Weekly Session Aggregate
#### Example
```
{
    "totalSleepAVG": 18670,
    "daySleepAVG": 3268,
    "nightSleepAVG": 16802,
    "longestSleepAVG": 9497,
    "nightWakingsAVG": 6.286,
    "days": {
        "totalSleep": [
            18096,
            19966,
            29070,
            15408,
            18880,
            17171,
            12096
        ],
        "daySleep": [
            3434,
            2012,
            5463,
            2161,
            0,
            0,
            0
        ],
        "nightSleep": [
            14662,
            17954,
            23607,
            13247,
            18880,
            17171,
            12096
        ],
        "longestSleep": [
            10032,
            10932,
            11028,
            9954,
            8717,
            8979,
            6837
        ],
        "nightWakings": [
            4,
            7,
            4,
            7,
            6,
            7,
            9
        ]
    }
}
```

# Acknowledgement

The structure of this project is inspired by [pymyq](https://github.com/arraylabs/pymyq)

# Disclaimer

The code here is based off of an unsupported API from
[happiestbaby.com](https://www.happiestbaby.com/) and is subject to change without
notice. The authors claim no responsibility for damages to your garage door or
property by use of the code within.
