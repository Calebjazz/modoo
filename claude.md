# CLAUDE.md — MODOO

## 1. Project Overview

**Project Name:** MODOO  
**Project Type:** 3D Virtual Fashion Studio  
**Platform:** Android and iOS  
**Frontend:** Flutter (Dart)  
**3D Engine:** Unity 3D (C#)  
**Local Database:** SQLite  
**Architecture:** Flutter + Embedded Unity

### Product Vision

MODOO is a 3D virtual fashion customization application that allows users to experiment with different clothing combinations using realistic, customizable 3D human avatars.

Users can select a default male or female avatar, customize its appearance, explore a digital wardrobe and dress the avatar by selecting or dragging different clothing items onto the 3D human.

The experience should feel similar to changing character costumes in a modern video game, but with realistic human models and fashionable clothing.

**Tagline:** Wear it your way.

MODOO is not an ordinary e-commerce application. Its main purpose is virtual fashion exploration and 3D outfit customization.

---

## 2. Core Features

### A. 3D Human Avatars

Provide default prebuilt human models.

Requirements:

- Male and female avatars.
- Realistic human appearance.
- Different skin tones.
- Different body shapes and proportions.
- Adjustable height where supported.
- Avatar rotation.
- Zoom controls.
- Front, side and back viewing.
- Different poses and animations where available.

Users should be able to customize their virtual appearance.

### B. Virtual Fashion Studio

This is the core feature of MODOO.

Display a large interactive 3D human avatar.

Users should be able to select or drag clothing items onto the avatar.

Clothing categories:

1. Tops
2. Bottoms
3. Dresses
4. Jackets
5. Shoes
6. Caps
7. Accessories

Requirements:

- Change individual clothing items independently.
- Remove selected clothing.
- Replace existing clothing.
- Preview outfit combinations immediately.
- Rotate and zoom the avatar.
- Reset the outfit.
- Save the current outfit.

Changing a shirt must not replace the entire human model.

### C. Avatar Customization

Allow users to customize:

- Avatar type.
- Skin tone.
- Body shape.
- Height.
- Body proportions.
- Hairstyle.
- Facial appearance where supported.

### D. Digital Wardrobe

Provide a collection of available clothing assets.

Each item should have:

- Unique ID.
- Clothing name.
- Category.
- Description.
- Thumbnail.
- 3D asset reference.
- Available variations.
- Color information.

Users should be able to browse and select clothing items.

### E. Outfit Management

Users should be able to:

- Save outfits.
- View saved outfits.
- Rename outfits.
- Delete outfits.
- Edit previously saved outfits.
- Apply saved outfits to their avatar.

### F. Profile

Include:

- User information.
- Saved avatars.
- Saved outfits.
- Wardrobe.
- Preferences.
- Application settings.

---

## 3. Technology Stack

### Flutter

Flutter is responsible for:

- Main application UI.
- Navigation.
- Home screen.
- Wardrobe interface.
- Clothing selection panels.
- Avatar customization controls.
- User interactions.
- SQLite database operations.
- Saved outfits.
- Application settings.
- use providers.

### Unity 3D

Unity is responsible for:

- Rendering 3D human avatars.
- Loading 3D clothing assets.
- Applying clothing to human models.
- Changing clothing independently.
- Changing skin materials.
- Avatar rotation.
- Zooming.
- Animations and poses.
- 3D scene management.

### SQLite

Use SQLite for local data persistence.

It should store:

- Clothing information.
- Clothing categories.
- Asset identifiers.
- Avatar configurations.
- Selected skin tones.
- Saved outfits.
- Outfit history.
- User preferences.

Use Drift or sqflite depending on the project's database requirements.

### Local Storage

Store 3D assets and associated resources locally.

Examples:

- Human models.
- Clothing models.
- Textures.
- Materials.
- Clothing thumbnails.
- Avatar resources.

Do not store large 3D binary files directly inside SQLite.

---

## 4. Flutter and Unity Communication

Flutter and Unity must communicate through a suitable integration bridge.

Investigate and verify the compatibility of:

- flutter_embed_unity.
- flutter_unity_widget_2.
- Unity as a Library.

Do not assume that any package is compatible with the project's current Flutter and Unity versions.

### Communication Responsibilities

Flutter sends commands to Unity.

Unity processes the commands and updates the 3D scene.

Unity can send events and responses back to Flutter.

Example commands:

```text
ChangeAvatar("male_01")
ChangeTop("red_shirt")
ChangeBottom("black_trousers")
ChangeShoes("white_sneakers")
ChangeCap("black_cap")
ChangeSkinTone("dark_brown")
RotateAvatar(90)
ResetOutfit()
```

Use a clearly defined communication contract between Flutter and Unity.

Avoid tightly coupling Flutter UI components to Unity implementation details.

---

## 5. Proposed Architecture

Use a modular architecture.

```text
lib/
│
├── main.dart
│
├── core/
│   ├── constants/
│   ├── database/
│   ├── theme/
│   ├── utils/
│   └── services/
│
├── features/
│   │
│   ├── home/
│   │   ├── screens/
│   │   └── widgets/
│   │
│   ├── studio/
│   │   ├── screens/
│   │   ├── widgets/
│   │   ├── models/
│   │   ├── services/
│   │   └── controllers/
│   │
│   ├── avatars/
│   │   ├── screens/
│   │   ├── models/
│   │   └── services/
│   │
│   ├── wardrobe/
│   │   ├── screens/
│   │   ├── widgets/
│   │   ├── models/
│   │   └── services/
│   │
│   ├── outfits/
│   │   ├── screens/
│   │   ├── models/
│   │   └── services/
│   │
│   └── profile/
│       ├── screens/
│       └── widgets/
│
├── shared/
│   ├── widgets/
│   └── models/
│
└── unity_bridge/
    ├── unity_service.dart
    ├── unity_commands.dart
    └── unity_events.dart
```

The Unity project should remain separately organized.

Suggested Unity structure:

```text
UnityProject/
│
├── Assets/
│   ├── Scenes/
│   ├── Scripts/
│   │   ├── Avatar/
│   │   ├── Clothing/
│   │   ├── Materials/
│   │   └── Communication/
│   │
│   ├── Models/
│   │   ├── Male/
│   │   └── Female/
│   │
│   ├── Clothing/
│   │   ├── Tops/
│   │   ├── Bottoms/
│   │   ├── Dresses/
│   │   ├── Jackets/
│   │   ├── Shoes/
│   │   ├── Caps/
│   │   └── Accessories/
│   │
│   ├── Materials/
│   ├── Textures/
│   └── Prefabs/
│
└── ProjectSettings/
```

Adapt this structure when the actual Unity integration requirements are established.

---

## 6. Database Design

Start with the following conceptual tables.

### clothing_items

- id
- name
- category_id
- description
- thumbnail_path
- asset_identifier
- color
- created_at

### clothing_categories

- id
- name
- description

### avatars

- id
- name
- avatar_type
- model_identifier
- default_skin_tone
- created_at

### saved_outfits

- id
- name
- avatar_id
- created_at
- updated_at

### outfit_items

- id
- outfit_id
- clothing_item_id
- clothing_slot

### avatar_settings

- id
- avatar_id
- skin_tone
- body_shape
- height
- hairstyle

Adapt the schema when implementation requirements become clearer.

---

## 7. Design System

MODOO must use a strictly monochromatic visual identity.

### Colors

- Primary: #000000
- Background: #FFFFFF
- Secondary: #808080
- Borders: Light grey.
- Primary text: #000000.
- Secondary text: Grey.

Do not introduce colorful accent colors.

### Font style

- use the one imported in the project and not from the design

### Design Style

- Minimalist.
- Premium.
- Fashion-focused.
- Modern.
- Elegant.
- Futuristic.

Avoid:

- Excessive gradients.
- Glassmorphism.
- Unnecessary decorative elements.
- Overcrowded layouts.
- Conventional e-commerce layouts.

Prioritize large 3D avatar previews, clear clothing thumbnails, elegant typography and intuitive controls.

---

## 8. Development Strategy

Develop MODOO incrementally.

### Phase 1: Technical Foundation

- Create Flutter project.
- Establish Unity integration.
- Verify Android compatibility.
- Display one Unity 3D scene inside Flutter.
- Load one realistic human avatar.
- Verify communication between Flutter and Unity.

Do not proceed until the integration works reliably.

### Phase 2: Avatar System

- Add male and female avatars.
- Implement avatar selection.
- Implement skin tone changes.
- Implement rotation and zoom.
- Add basic body customization.

### Phase 3: Clothing System

- Prepare compatible clothing assets.
- Implement clothing attachment.
- Implement independent clothing replacement.
- Implement tops, bottoms and shoes.
- Add remaining categories.
- Test clothing compatibility with each avatar.

### Phase 4: SQLite and Wardrobe

- Implement database.
- Add clothing catalogue.
- Store avatar configurations.
- Implement saved outfits.
- Implement outfit management.

### Phase 5: UI Integration

- Connect the Studio screen to Unity.
- Implement clothing selection panels.
- Implement avatar customization UI.
- Add wardrobe and outfit screens.
- Improve transitions and user experience.

### Phase 6: Optimization

- Optimize 3D assets.
- Reduce unnecessary memory consumption.
- Improve model loading.
- Test low-end Android devices.
- Verify offline functionality.
- Test application stability.

---

## 9. Coding Guidelines

Follow these rules throughout development:

1. Use Flutter and Dart for the mobile application.
2. Use Unity and C# for the 3D engine.
3. Keep Flutter and Unity responsibilities separate.
4. Use reusable widgets and components.
5. Keep the code modular and understandable.
6. Avoid unnecessary architectural complexity.
7. Do not introduce a backend unless a future feature genuinely requires one.
8. Use SQLite for local persistence.
9. Keep 3D assets separate from database records.
10. Avoid unnecessary dependencies.
11. Preserve existing working code when implementing new features.
12. Do not rewrite unrelated files.
13. Do not introduce hardcoded dummy functionality as if it were real.
14. Ensure every interactive control has a functional implementation.
15. Explain important architectural decisions before making major changes.

When implementing a feature, work step by step and explain which files are being created or modified.

---

## 10. Important Project Rules

- Do not introduce AI virtual try-on in the first version.
- Do not build an online shopping or payment system.
- Do not assume that Unity integration is already working.
- Do not download or use unlicensed 3D assets.
- Do not use ordinary 2D clothing images as if they were functional 3D garments.
- Do not replace an entire avatar when changing one clothing item.
- Do not begin large-scale development before proving the Flutter-Unity integration.

---

## 11. Current Development Priority

The immediate priority is to establish a working Flutter-Unity integration.

The first technical proof of concept must demonstrate:

1. A Flutter application opens successfully.
2. A Unity 3D scene appears inside a Flutter screen.
3. A realistic human avatar loads.
4. Flutter sends a command to Unity.
5. Unity changes the avatar's clothing or material.
6. Unity sends a response back to Flutter.

Only after successfully demonstrating these requirements should full MODOO development begin.

## 12. Push and Commits to Github

- Always use convetional commits when commiting to github

**Remember: MODOO is a 3D Virtual Fashion Studio. The interactive human avatar and clothing customization experience are the heart of the application.**