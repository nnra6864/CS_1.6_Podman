This is a podman container made for cs 1.6 servers using:

1. [pasta](https://passt.top/passt/about/)
2. [ReHLDS](https://rehlds.dev/)
3. [ReGameDLL](https://rehlds.dev/docs/regamedll-cs/)
4. [Metamod-R](https://github.com/rehlds/Metamod-R)
5. [AMX Mod X](https://www.amxmodx.org/)
6. [ReAPI](https://github.com/rehlds/reapi)

# Usage

## Dependencies

Arch
```sh
sudo pacman -S podman passt
```

## Building

Everything is automated, simply run:

```sh
podman compose build
```

This might take a few minutes depending on your disk and network speeds.

## Running

Configure `compose.yaml` and run:

```sh
podman compose up -d
```

## Configuring

While some configuration is available in `compose.yaml`, most config files and directories are found in the `cstrike` dir.
To locate it, look at your `compose.yml`.
By default, it should be in the same directory as the compose file:

```yml
volumes:
    - ./cstrike:/opt/hlds/cstrike:U,Z
```

## Stopping

```sh
podman compose down
```

## Console

You can easily access the server console by running:
```sh
podman attach counter-strike
```

> [!NOTE]
> Replace `counter-strike` with your container name.

> [!NOTE]
> To detach from the console without killing the server, press `CTRL + P` followed by `CTRL + Q`.

# ☦

```
   Ὤ
 Ὁ   Ν
Ι̅Ϲ̅ │ Χ̅Ϲ̅
───┼───
ΝΙ │ ΚΑ
   ☦
```

Εἰς δόξαν τοῦ Θεοῦ<br>
*To the glory of God*

Τῇ Ὑπεραγίᾳ Θεοτόκῳ δόξα<br>
*Glory to the Most Holy Theotokos*

Δόξα τῷ Θεῷ πάντων ἕνεκεν<br>
*Glory to God for all things*

ΑΜΗΝ

☦
