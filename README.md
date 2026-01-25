This is a podman container made for cs 1.6 servers using:
1. [ReHLDS](https://rehlds.dev/)
2. [Metamod-P](https://metamod-p.sourceforge.net/), although this might change to [Metamod-R](https://github.com/rehlds/Metamod-R)
3. [AMX Mod X](https://www.amxmodx.org/)

# Usage

## Building

Everything is automated, simply run:
```sh
podman-compose build
```
This might take a few minutes depending on your disk and network speeds.

## Running

Configure `compose.yml` and run:
```sh
podman-compose up -d
```

## Configuring

While some configuration is available in `compose.yml`, most config files and directories are found in the `cstrike` dir.
To locate it, look at your `compose.yml`.
By default, it should be in the same directory as the compose file:
```yml
volumes:
    - ./cstrike:/opt/hlds/cstrike:U
```
Keep in mind that all edits will require sudo, or simply switching to the podman user:
```sh
podman unshare
```

## Stopping

```sh
podman-compose down
```
