# Project Evolution & Lineage

This repository provides the touchscreen UI for **RosetteOS** ([`RosetteOS`](https://github.com/RosetteOS/RosetteOS)).

### Project Evolution:
1. **Upstream Roots**: Forked from [`ballaswag/guppyscreen`](https://github.com/ballaswag/guppyscreen) with improvements from the broader K1 and KE community.
2. **NebulaOS Origin**: Brought into the NebulaOS project to serve as the direct touchscreen UI for custom modern Linux on the Creality Nebula Pad hardware (with the Ender-3 V3 KE as the initial bring-up target).
3. **RosetteOS & Multi-Printer Scope**: RosetteOS continues the NebulaOS work and uses its companion Klipper extensions while providing native dual-slot SWUpdate upgrades, refined UI workflows, and a multi-printer architecture designed for printers compatible with Creality's Nebula Smart Kit.

Why this matters for the wiki: sections inherited from earlier development phases describe standalone or installer-based flows, whereas RosetteOS integrates GuppyScreen natively into the A/B-upgradable OS image.

See also: [Integration with RosetteOS](Integration-with-RosetteOS) and [Vendored Dependencies](Vendored-Dependencies).
