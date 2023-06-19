![logo](logo.png)

# Nodot FPS Example

**A first person shooter made using [Nodot](https://github.com/NodotProject/nodot), a node composition library for Godot 4**

[![](https://dcbadge.vercel.app/api/server/Rx9CZX4sjG)](https://discord.gg/Rx9CZX4sjG)
[![](https://img.shields.io/mastodon/follow/110106863700290562?domain=https%3A%2F%2Fmastodon.gamedev.place&label=MASTODON&style=for-the-badge)](https://mastodon.gamedev.place/@krazyjakee)
[![](https://img.shields.io/youtube/channel/subscribers/UColWkNMgHseKyU7D1QGeoyQ?label=YOUTUBE&style=for-the-badge)](https://www.youtube.com/@GodotNodot)

The Nodot First Person Shooter example is a simple technical demo of how to use Nodot to create a game.

Download the latest playable release [here](https://github.com/NodotProject/nodot-fps/releases).

Features include:
- First person character
- Locomotion (walking, running, jumping and swimming)
- A range of weapons (melee, pistol, automatic rifle, sniper and rocket launcher)
- A firing range and targets with health and a health bar
- Collectable items, an inventory and a storage chest
- Various demonstrations of Nodot features including audio, spawning, interaction and signal handling.

## Contributing

### Required Software

- [Godot 4.1 Beta 2](https://godotengine.org)
- [Git-LFS](https://git-lfs.github.com/) - Required to download the large binary files in this repo

### Required Godot Addons (included in this repo)

- [Nodot](https://github.com/NodotProject/nodot)
- [TBLoader (the krazyjakee fork)](https://github.com/krazyjakee/godot-tbloader)
- [GUT](https://github.com/bitwes/Gut)

### Contribution Workflow

1. Fork the repository
2. Clone your fork to your local machine
3. Create a new branch for your feature
4. Make your changes
5. Commit and push your changes to your fork
6. Create a pull request from your fork to the [main repository](https://github.com/NodotProject/nodot-fps)
7. Wait for your pull request to be reviewed and merged

### Map Editing

The map is created using both Godot and [TrenchBroom](https://kristianduske.com/trenchbroom/), a cross-platform level editor for Quake-engine based games. This is due to the speed and ease of use of TrenchBroom for creating the map geometry and the flexibility of Godot for adding entities and scripting.

#### Setting up TrenchBroom

- Download and install TrenchBroom from [here](https://kristianduske.com/trenchbroom/)
- Place the `tb-gameconfig` folder in `%AppData%\Roaming\TrenchBroom\games`
- Open (or restart) TrenchBroom and click `View > Preferences`
- Click the `nodot-fps` game configuration
- Set the Game Path to the root of the `nodot-fps` repository (where to cloned this repo)
- Click `OK`

#### Mapping workflow

- Maps live in the `maps` folder of this repo
- Make your modifications of the `.map` file in TrenchBroom and save.
- In Godot, open the associated map scene for that file.
- Select the TBLoader node and view it in 3D mode
- Click the "Build Meshes" button in the toolbar to regenerate the map.

#### Adding/Modifying entities

- If you want to add entities to trenchbroom, simply add new scenes and associated scripts in the `entities` folder.
- Select the TBLoader node and view it in 3D mode
- Click `Build FGD` in the toolbar to regenerate the FGD file.
- In TrenchBroom, click `File > Reload Entity Definitions` to load the new FGD file.

#### Textures

- Godot textures are stored in the `textures` folder.
- Trenchbroom textures are stored in the `tb-textures` folder with associated subtextures (normal maps etc) in subfolders.
- A `.tres` file is used to map the Trenchbroom texture back to Godot.

## Asset Credits

Example model asset credits:
- https://quaternius.com ([CC0](https://creativecommons.org/share-your-work/public-domain/cc0/))
- https://www.kenney.nl ([CC0](https://creativecommons.org/share-your-work/public-domain/cc0/))
- https://loafbrr.itch.io ([CC0](https://creativecommons.org/share-your-work/public-domain/cc0/))
- https://pixabay.com ([CC0](https://creativecommons.org/share-your-work/public-domain/cc0/))
- https://www.sharetextures.com/ ([CC0](https://creativecommons.org/share-your-work/public-domain/cc0/))
- [MakeHuman](http://www.makehumancommunity.org/) ([CC0](https://creativecommons.org/share-your-work/public-domain/cc0/))
- ["M Suit 01" by "Mindfront"](http://www.makehumancommunity.org/clothes/m_suit_01.html) ([CC-BY](https://creativecommons.org/licenses/by/2.0/))