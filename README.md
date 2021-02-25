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

import pysnoo

async def main() -> None:
    """Create the aiohttp session and run."""
    async with ClientSession() as websession:
      snoo = await pysnoo.login('<EMAIL>', '<PASSWORD>', websession)

      # Returns snoo devices
      devices = snoo.devices
      # >>> {"serial_number123": <Device>, "serial_number456": <Device>}


asyncio.get_event_loop().run_until_complete(main())
```
## API Properties

* `account`: dictionary with the account
* `devices`: dictionary with all devices
* `last_state_update`: datetime (in UTC) last state update was retrieved
* `password`: password used for authentication. Can only be set, not retrieved
* `username`: username for authentication.

## Account Properties

* `id`: ID for the account
* `name`: Name of the account

## Device Properties

* `account`: Return account associated with device
* `device_id`: Return the device ID (serial number).
* `firmware_version`: Return the family in which this device lives.
* `name`: Return the device name.
* `is_online`: Return whether the device is online.
* `state`: Return the current state of the device.
* `state_update`: Returns datetime when device was last updated

## API Methods

These are coroutines and need to be `await`ed – see `example.py` for examples.

* `authenticate`: Authenticate (or re-authenticate) to Snoo. Call this to
  re-authenticate immediately after changing username and/or password otherwise
  new username/password will only be used when token has to be refreshed.
* `update_device_info`: Retrieve info and status for accounts and devices

## Device Methods

All of the routines on the `SnooDevice` class are coroutines and need to be
`await`ed – see `example.py` for examples.

* `update`: get the latest device info (state, etc.). Note that
  this runs api.update_device_info and thus all accounts/devices will be updated

# Acknowledgement

The structure of this project is inspired by [pymyq](https://github.com/arraylabs/pymyq)

# Disclaimer

The code here is based off of an unsupported API from
[happiesbaby.com](https://www.happiestbaby.com/) and is subject to change without
notice. The authors claim no responsibility for damages to your garage door or
property by use of the code within.
