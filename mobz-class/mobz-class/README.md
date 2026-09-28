# MOBZ Job Selector

A lightweight, configurable FiveM NPC job/class selection system for **QBCore** and **ESX Extended**.

Create job-selection NPCs around your server with custom models, animations, floating job banners, coloured floor markers, coloured lighting, and interaction through **qb-target** or **ox_target**.

Designed to be simple, lightweight, and highly configurable.

---

## ✨ Features

* 🧑‍💼 Multiple configurable job NPCs
* 🎭 Individual animation for every NPC
* 🖼️ Floating YTD/YPT job banners above NPCs
* 🎨 Individual coloured floor markers
* 💡 Individual coloured NPC lighting
* 🎯 qb-target support
* 🎯 ox_target support
* 🔄 Automatic target-system detection
* 🟦 QBCore support
* 🟧 ESX Extended support
* ⏱️ Configurable job-change cooldown
* 🔔 Framework-specific notifications
* 🛡️ Server-side job changing
* 🧹 Automatic cooldown cleanup when players leave
* 📍 Fully configurable NPC locations
* 👤 Custom NPC models
* ⚙️ Configuration-driven setup
* 🚫 No core files need to be edited
* 🪶 Lightweight client-side rendering
* 🔧 Easy to expand with additional jobs/NPCs

---

# 📦 Requirements

### Required

One of:

* QBCore
* ESX Extended

And one of:

* qb-target
* ox_target


# 📥 Installation

### 1. Download the resource

Place the resource inside your server's resources folder:

```text
resources/
└── [scripts]/
    └── mobz-classes/
```

### 2. Add the resource to `server.cfg`

```cfg
ensure mobz-classes
```

### 3. Configure your NPCs

Open:

```text
config.lua
```

and configure your NPCs, jobs, animations, markers, lights, and banners.

### 4. Restart the resource

```text
restart mobz-classes
```

---

# ⚙️ Configuration

## Target System

The resource supports both `qb-target` and `ox_target`.

Automatic detection:

```lua
Config.Target = 'auto'
```

Force qb-target:

```lua
Config.Target = 'qb-target'
```

Force ox_target:

```lua
Config.Target = 'ox_target'
```

When using `auto`, the resource detects the running target system automatically.

If both are installed, `ox_target` is preferred when using automatic detection.

---

# ⏱️ Job Change Cooldown

Configure how often players can change jobs:

```lua
Config.JobCooldown = 60
```

The value is in seconds.

For example:

```lua
Config.JobCooldown = 30
```

allows players to change their job every 30 seconds.

The cooldown is handled server-side.

Players attempting to change jobs during the cooldown receive a notification showing how many seconds remain.

---

# 🧑‍💼 NPC Configuration

Each NPC can have its own:

* Model
* Location
* Heading
* Job
* Banner texture
* Animation
* Floor marker
* Marker colour
* Marker size
* Spotlight
* Spotlight colour

Example:

```lua
Config.NPCs = {

    {
        model = 's_m_m_paramedic_01',

        coords = vector4(
            -422.88,
            1182.98,
            324.64,
            75.47
        ),

        job = 'ambulance',

        texture = 'medic',

        animation = {
            dict = 'amb@world_human_clipboard@male@base',
            anim = 'base'
        },

        marker = {
            enabled = true,

            color = {
                r = 50,
                g = 150,
                b = 255,
                a = 180
            },

            size = 1.5
        },

        spotlight = {
            enabled = true,

            color = {
                r = 50,
                g = 150,
                b = 255
            },

            range = 8.0,
            intensity = 10.0,
            height = 2.0,
            shadow = true
        }
    }
}
```

---

# 🎭 NPC Animations

Every NPC can have its own animation.

Example:

```lua
animation = {
    dict = 'amb@world_human_smoking@male@male_a@base',
    anim = 'base'
}
```

Another NPC can use:

```lua
animation = {
    dict = 'amb@world_human_clipboard@male@base',
    anim = 'base'
}
```

Animations are loaded automatically before being played.

The NPC is also configured to remain stationary and protected from unwanted ambient behaviour.

---

# 🖼️ Floating Job Banners

NPCs can have a custom texture displayed above their head.

Example:

```lua
texture = 'medic'
```

The resource uses the configured texture dictionary and displays the selected texture above the NPC.

Example:

```lua
Config.ImageHeight = 0.5

Config.ImageSize = {
    x = 0.1,
    y = 0.1
}
```

The banner height and size can be adjusted globally.

Each NPC can use a different texture:

```lua
texture = 'medic'
```

```lua
texture = 'mechanic'
```

```lua
texture = 'scavenger'
```

---

# 🎨 Floor Markers

Each NPC can have its own coloured floor marker.

Enable the marker:

```lua
marker = {
    enabled = true,
```

Set its colour:

```lua
color = {
    r = 50,
    g = 150,
    b = 255,
    a = 180
},
```

Set its size:

```lua
size = 1.5
```

Example:

```lua
marker = {
    enabled = true,

    color = {
        r = 255,
        g = 170,
        b = 40,
        a = 180
    },

    size = 1.5
}
```

Different NPCs can therefore have completely different marker colours.

---

# 💡 NPC Lighting

NPCs can have their own coloured light.

Example:

```lua
spotlight = {
    enabled = true,

    color = {
        r = 50,
        g = 150,
        b = 255
    },

    range = 8.0,
    intensity = 10.0,
    height = 2.0,
    shadow = true
}
```

### Lighting options

| Option      | Description                |
| ----------- | -------------------------- |
| `enabled`   | Enables/disables the light |
| `color.r`   | Red value                  |
| `color.g`   | Green value                |
| `color.b`   | Blue value                 |
| `range`     | Light range                |
| `intensity` | Light strength             |
| `height`    | Height above the NPC       |
| `shadow`    | Enables shadows            |

Example mechanic lighting:

```lua
spotlight = {
    enabled = true,

    color = {
        r = 255,
        g = 170,
        b = 40
    },

    range = 8.0,
    intensity = 10.0,
    height = 2.0,
    shadow = true
}
```

---

# 🎯 Target Interaction

Players interact with the NPC using the configured target system.

The default interaction is:

```text
Apply for [JOB]
```

For example:

```text
Apply for ambulance
```

or:

```text
Apply for mechanic
```

---

## qb-target

When configured:

```lua
Config.Target = 'qb-target'
```

the resource uses:

```lua
exports['qb-target']:AddTargetEntity()
```

---

## ox_target

When configured:

```lua
Config.Target = 'ox_target'
```

the resource uses:

```lua
exports.ox_target:addLocalEntity()
```

The player-facing interaction remains the same.

---

# 🟦 QBCore

The resource supports QBCore job changes through:

```lua
Player.Functions.SetJob(job, 0)
```

Notifications use the standard QBCore notification system.

Example:

```text
Your job has been changed to mechanic.
```

---

# 🟧 ESX Extended

ESX Extended job changes use:

```lua
xPlayer.setJob(job, 0)
```

Notifications use:

```lua
esx:showNotification
```

The same NPC configuration can therefore be used with ESX.

---

# 🔄 Framework Detection

The resource detects the installed framework automatically.

Supported:

```text
qb-core
es_extended
```

The framework is detected server-side.

No framework core files need to be edited.

---

# 🛡️ Server-Side Job Changes

Job changes are handled server-side.

The client requests:

```lua
mobz-jobselector:setJob
```

The server then:

1. Identifies the player.
2. Checks the cooldown.
3. Gets the framework player object.
4. Sets the requested job.
5. Starts the cooldown.
6. Sends a success notification.

This prevents the cooldown from being controlled purely by the client.

---

# ⏱️ Cooldown Behaviour

Example:

```lua
Config.JobCooldown = 60
```

Player selects:

```text
Mechanic
```

The server changes the job and starts the cooldown.

If the player immediately attempts:

```text
Ambulance
```

they receive:

```text
You must wait 59 seconds before changing your job again.
```

Once the cooldown expires, they can select another job.

Cooldown data is also removed when the player disconnects.

---

# 📍 Multiple NPCs

You can create as many NPCs as required.

Example:

```lua
Config.NPCs = {

    {
        model = 's_m_m_paramedic_01',
        coords = vector4(-422.88, 1182.98, 324.64, 75.47),
        job = 'ambulance',
        texture = 'medic'
    },

    {
        model = 's_m_y_xmech_02',
        coords = vector4(310.0, -600.0, 43.0, 90.0),
        job = 'mechanic',
        texture = 'mechanic'
    },

    {
        model = 's_m_y_garbage',
        coords = vector4(305.0, -600.0, 43.0, 90.0),
        job = 'scavenger',
        texture = 'scavenger'
    }
}
```

Each NPC can have completely different settings.

---

# 🎨 Example Job Setup

## Ambulance

```lua
job = 'ambulance'

marker = {
    enabled = true,
    color = {
        r = 50,
        g = 150,
        b = 255,
        a = 180
    },
    size = 1.5
}
```

## Mechanic

```lua
job = 'mechanic'

marker = {
    enabled = true,
    color = {
        r = 255,
        g = 170,
        b = 40,
        a = 180
    },
    size = 1.5
}
```

## Scavenger

```lua
job = 'scavenger'

marker = {
    enabled = true,
    color = {
        r = 120,
        g = 120,
        b = 120,
        a = 180
    },
    size = 1.5
}
```

---

# 🚀 Performance

The resource is designed to avoid unnecessary rendering at long distances.

Floor markers and NPC lighting are only rendered when the player is within the configured rendering distance.

This allows multiple job NPCs to be placed around the map without continuously rendering every marker and light from across the map.

---

# 📁 Resource Structure

Recommended structure:

```text
mobz-classes/
│
├── fxmanifest.lua
├── config.lua
├── client.lua
├── server.lua
└── stream/

```

---

# 🔧 Adding Another Job

Adding another job is as simple as adding another NPC entry.

Example:

```lua
{
    model = 's_m_y_construct_01',
    coords = vector4(320.0, -610.0, 43.0, 180.0),

    job = 'construction',

    texture = 'construction',

    animation = {
        dict = 'amb@world_human_clipboard@male@base',
        anim = 'base'
    },

    marker = {
        enabled = true,

        color = {
            r = 255,
            g = 200,
            b = 50,
            a = 180
        },

        size = 1.5
    },

    spotlight = {
        enabled = true,

        color = {
            r = 255,
            g = 200,
            b = 50
        },

        range = 8.0,
        intensity = 10.0,
        height = 2.0,
        shadow = true
    }
}
```

The job must already exist in your framework.

---

# 🧩 Supported Systems

| System                 | Support |
| ---------------------- | ------- |
| QBCore                 | ✅       |
| ESX Extended           | ✅       |
| qb-target              | ✅       |
| ox_target              | ✅       |
| Custom NPC models      | ✅       |
| Custom animations      | ✅       |
| Custom banner textures | ✅       |
| Coloured floor markers | ✅       |
| Coloured NPC lighting  | ✅       |
| Server-side cooldown   | ✅       |

---

# 🛠️ Troubleshooting

### NPC does not appear

Check that the model name is valid:

```lua
model = 's_m_m_paramedic_01'
```

Make sure the model exists and can be loaded by FiveM.

---

### Target interaction does not appear

Check:

```lua
Config.Target = 'auto'
```

or explicitly configure:

```lua
Config.Target = 'qb-target'
```

or:

```lua
Config.Target = 'ox_target'
```

Also make sure the selected target resource is started before this resource.

---

### Job does not change

Make sure the job exists in your framework.

For example:

```lua
job = 'mechanic'
```

must be registered as a valid job.

---

### Animation does not play

Check that both the animation dictionary and animation name are correct:

```lua
animation = {
    dict = 'amb@world_human_clipboard@male@base',
    anim = 'base'
}
```

---

### Banner does not appear

Check that the texture dictionary is correctly installed and that the configured texture name matches the texture contained inside it:

```lua
texture = 'medic'
```

---

# 📜 License

© MOBZ

This resource is developed and maintained by **MOBZ**.

Do not redistribute, resell, leak, or re-upload this resource without permission.

---

# ❤️ Credits

**MOBZ**

Built for FiveM roleplay servers with a focus on simple configuration, performance, and clean integration with popular FiveM frameworks.

---

## ⭐ MOBZ Job Selector

**Turn any NPC into a professional job-selection point.**

**QBCore • ESX • qb-target • ox_target • Custom NPCs • Animations • Banners • Markers • Lighting**
