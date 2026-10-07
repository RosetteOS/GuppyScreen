# Integration with RosetteOS & NebulaOS Extensions

RosetteOS continues the NebulaOS work, integrates GuppyScreen into the system image, and uses the companion Klipper extensions (`NebulaOS-klipper-extensions`). The [RosetteOS firmware repository](https://github.com/RosetteOS/RosetteOS) pins an exact commit of this repo in `manifests/dependencies.conf` and fetches, cross-compiles, and installs it as part of the full OS image. You do not need to build this repo separately for a complete RosetteOS image.

Every RosetteOS build records this repo's exact commit in `build-manifest.txt`.

Config and theme persist across boots on RosetteOS's read-only-squashfs setup —
see [Config and Theme](Config-and-Theme) for details.

See also: [CI](CI), [Vendored Dependencies](Vendored-Dependencies), [RosetteOS Relationship](RosetteOS-Relationship).
