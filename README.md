# Suezhoo's NixOS configuration

Declarative NixOS and Home Manager configuration for the `sayo` desktop and
the `sayonara` VM. The physical desktop runs the CachyOS kernel and supports
several independently buildable Wayland desktop stacks, including Niri and
KineticWE.

The repository separates three questions:

1. **Which machine is being configured?** — `hosts/`
2. **Which desktop stack should it run?** — `profiles/desktops/`
3. **Which applications and preferences belong to a user?** — `home/users/`

## Desktop configurations

The flake exposes these physical-machine configurations:

| Output | Desktop stack |
| --- | --- |
| `sayo` | Alias for Niri + Noctalia |
| `sayo-noctalia` | Niri + Noctalia |
| `sayo-custom` | Niri + Waybar, Wofi, and Waypaper |
| `sayo-inir` | Niri + iNiR |
| `sayo-kineticwe` | KineticWE with its upstream Noctalia integration |
| `sayo-hyprland` | Hyprland + the custom shell |
| `sayonara` | Virtual-machine configuration |

Build a configuration without activating it:

```bash
sudo nixos-rebuild build --flake .#sayo-kineticwe
```

Build and activate it:

```bash
sudo nixos-rebuild switch --flake .#sayo-kineticwe
```

Validate every flake output without building the complete systems:

```bash
nix flake check --no-build
```

## Folder structure

```text
.
├── flake.nix                 Flake inputs and named NixOS configurations
├── flake.lock                Pinned, reproducible dependency revisions
├── hosts/                    Machine-specific configuration
├── modules/                  Reusable system-level NixOS modules
├── profiles/desktops/        Complete compositor and shell combinations
└── home/                     Home Manager modules
    ├── users/                Per-person applications and preferences
    ├── shared/               Defaults reusable by multiple users
    ├── apps/                 Reusable application modules
    ├── dev/                  Development tool modules
    ├── desktop/              Graphical and hardware session integration
    ├── wm/                   User-level compositor configuration
    └── shell/                Panels, launchers, wallpaper, and desktop shells
```

### `hosts/`

Each folder represents a physical machine or VM. Host modules own facts tied
to that machine, such as its hostname, hardware configuration, bootloader,
display layout, GPU integration, and which user accounts exist.

```text
hosts/
├── sayo/
│   ├── configuration.nix
│   ├── hardware-configuration.nix
│   └── home.nix              Home Manager settings tied to sayo's hardware
└── sayonara/
    ├── configuration.nix
    └── hardware-configuration.nix
```

Generated `hardware-configuration.nix` files should generally remain
machine-generated and should not contain desktop or user preferences.

### `modules/`

These are reusable NixOS modules. Each module handles one system-level
concern, following the NixOS module model of composing logical aspects through
`imports`.

```text
modules/
├── common.nix                Shared operating-system services and packages
├── fonts.nix
├── gpu/nvidia.nix
├── kernel/cachyos.nix
├── sessions/                 System compositor/session registration
│   ├── hyprland.nix
│   ├── kineticwe.nix
│   └── niri.nix
├── users/suezhoo.nix         Declarative system account
└── qylock.nix
```

These modules provide capabilities; they do not decide which desktop profile
is active.

### `profiles/desktops/`

A desktop profile is an explicit, known-working composition of:

- a system session or compositor module;
- its Home Manager compositor configuration;
- a compatible shell;
- system services required by that combination.

For example, `niri-noctalia.nix` combines the Niri system session, the user's
Niri configuration, and Noctalia. KineticWE remains atomic because its
upstream session currently bundles Noctalia.

Profiles are selected in `flake.nix`; hosts do not inspect strings to decide
which compositor or shell to import.

### `home/users/`

This directory answers: **what does this person use?**

`home/users/suezhoo/default.nix` selects Suezhoo's applications, development
tools, Git identity, MIME associations, and shared defaults. Desktop-specific
configuration is deliberately absent and is added by the selected desktop
profile.

A future user can have an independent module:

```text
home/users/
├── suezhoo/default.nix
└── another-user/default.nix
```

Both users may import the same modules from `home/apps/` while choosing
different packages and preferences in their own user modules.

### `home/shared/`

Shared Home Manager defaults that multiple users can opt into live here.
They should not assume that a user has installed a particular personal
application or that every machine has the same GPU.

### `home/apps/`, `home/wm/`, and `home/shell/`

- `home/apps/` contains reusable application installation and configuration.
- `home/wm/` contains user-level compositor configuration.
- `home/shell/` contains desktop-shell components such as Noctalia, iNiR,
  Waybar, Wofi, and wallpaper services.

Niri consumes a small shell interface from
`home/desktop/shell-interface.nix`. This keeps the Niri module independent of
the concrete shell selected by a desktop profile.

## Composition overview

```text
flake output
├── host
│   ├── hardware and boot configuration
│   ├── reusable system modules
│   └── user account declarations
├── desktop profile
│   ├── system compositor/session
│   └── Home Manager compositor + shell
└── Home Manager user
    ├── personal applications
    ├── personal preferences
    └── shared defaults
```

This keeps machine, desktop, and person-specific decisions independent while
still producing a single declarative NixOS system.

## State-version policy

`system.stateVersion` and `home.stateVersion` preserve compatibility with the
release used when each configuration was introduced. They should not be
changed merely because the NixOS input is upgraded; review the corresponding
NixOS or Home Manager release notes first.
